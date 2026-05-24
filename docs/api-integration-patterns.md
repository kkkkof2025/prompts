# AI API 集成模式实战

> 把 AI 嵌入真实应用，不只是调一个 API 那么简单。这一节覆盖错误处理、流式输出、重试策略、成本追踪等工程实践。

## 一、为什么需要专门的集成模式

直接把 AI API 调用写在业务代码里会发生什么？

```text
用户请求 → 调 AI API → 等待3秒 → 返回结果 → 搞定！
```

第一次跑通了。但一个月后：

```text
用户请求 → 调 AI API → 超时！ → 整个页面卡住 → 用户投诉
用户请求 → 调 AI API → 429 Rate Limit → 返回错误 → 数据丢失
用户请求 → 调 AI API → 返回空内容 → 业务逻辑崩了
```

**AI API 和普通 REST API 的本质区别**：
1. **延迟高且不稳定**：几毫秒到几十秒不等
2. **结果是概率性的**：同样的输入每次可能不同
3. **有 token 限制**：不是传多少都能处理
4. **可能返回空/截断/幻觉**：需要验证
5. **按 token 计费**：成本需要主动控制

---

## 二、基础集成模式

### 2.1 同步调用（最简单，适合脚本和批处理）
{: #2-1同步调用最简单适合脚本和批处理 }

```python
import os
from openai import OpenAI

client = OpenAI(api_key=os.getenv("OPENAI_API_KEY"))

def simple_call(prompt: str, model: str = "gpt-4o-mini") -> str:
    """最基础的同步调用——适合简单脚本"""
    try:
        response = client.chat.completions.create(
            model=model,
            messages=[{"role": "user", "content": prompt}],
            max_tokens=500
        )
        return response.choices[0].message.content or ""
    except Exception as e:
        return f"Error: {e}"
```

**适用场景**：一次性任务、批处理、脚本
**不适用场景**：Web服务（会阻塞请求）

### 2.2 带超时和错误处理
{: #2-2带超时和错误处理 }

```python
import time
from typing import Optional

def call_with_timeout(
    prompt: str,
    model: str = "gpt-4o-mini",
    timeout: int = 30,
    retries: int = 2
) -> Optional[str]:
    """带超时和重试的调用"""
    
    for attempt in range(retries + 1):
        try:
            response = client.chat.completions.create(
                model=model,
                messages=[{"role": "user", "content": prompt}],
                max_tokens=500,
                timeout=timeout
            )
            return response.choices[0].message.content
        except Exception as e:
            if attempt < retries:
                wait = 2 ** attempt  # 指数退避: 1s, 2s, 4s
                print(f"Attempt {attempt+1} failed: {e}. Retrying in {wait}s...")
                time.sleep(wait)
            else:
                print(f"All {retries+1} attempts failed: {e}")
                return None
```

### 2.3 流式输出（适合聊天和实时反馈）
{: #2-3流式输出适合聊天和实时反馈 }

```python
def stream_call(prompt: str, model: str = "gpt-4o-mini"):
    """流式输出——适合需要逐字显示的场景"""
    stream = client.chat.completions.create(
        model=model,
        messages=[{"role": "user", "content": prompt}],
        stream=True
    )
    
    full_response = ""
    for chunk in stream:
        if chunk.choices[0].delta.content:
            content = chunk.choices[0].delta.content
            full_response += content
            print(content, end="", flush=True)  # 实时输出
    
    return full_response
```

---

## 三、生产级集成模式

### 3.1 Token 预算控制
{: #3-1Token预算控制 }

```python
import tiktoken

class TokenBudget:
    """控制每次调用的 token 消耗"""
    
    def __init__(self, model: str = "gpt-4o-mini"):
        self.encoder = tiktoken.encoding_for_model(model)
        
    def count(self, text: str) -> int:
        return len(self.encoder.encode(text))
    
    def truncate_prompt(self, prompt: str, max_tokens: int) -> str:
        """如果 prompt 太长，截断到预算内"""
        tokens = self.encoder.encode(prompt)
        if len(tokens) <= max_tokens:
            return prompt
        # 保留开头和结尾（开头通常最重要）
        half = max_tokens // 2
        return (self.encoder.decode(tokens[:half]) + 
                "\n...(内容已截断)...\n" +
                self.encoder.decode(tokens[-half:]))
```

### 3.2 结果验证层
{: #3-2结果验证层 }

```python
import json

def validated_call(
    prompt: str,
    expected_format: str = "text",  # text, json, list
    min_length: int = 10,
    required_fields: list = None
) -> dict:
    """调用 AI 并验证结果"""
    
    result = call_with_timeout(prompt)
    
    if result is None:
        return {"status": "error", "reason": "call_failed", "content": None}
    
    if len(result) < min_length:
        return {"status": "error", "reason": "too_short", "content": result}
    
    if expected_format == "json":
        try:
            data = json.loads(result)
        except json.JSONDecodeError:
            return {"status": "error", "reason": "invalid_json", "content": result}
        
        if required_fields:
            missing = [f for f in required_fields if f not in data]
            if missing:
                return {"status": "error", "reason": f"missing_fields:{missing}", "content": data}
        
        return {"status": "ok", "content": data}
    
    return {"status": "ok", "content": result}
```

### 3.3 异步并发调用
{: #3-3异步并发调用 }

```python
import asyncio

async def async_call(prompt: str, model: str = "gpt-4o-mini") -> str:
    """异步调用——适合 Web 服务"""
    response = await client.chat.completions.create(
        model=model,
        messages=[{"role": "user", "content": prompt}],
        max_tokens=500
    )
    return response.choices[0].message.content or ""

async def batch_call(prompts: list[str], concurrency: int = 5) -> list[str]:
    """批量并发调用——控制并发数避免触发 rate limit"""
    semaphore = asyncio.Semaphore(concurrency)
    
    async def bounded_call(prompt):
        async with semaphore:
            return await async_call(prompt)
    
    tasks = [bounded_call(p) for p in prompts]
    return await asyncio.gather(*tasks, return_exceptions=True)
```

---

## 四、成本追踪

### 4.1 每次调用的成本记录
{: #4-1每次调用的成本记录 }

```python
from dataclasses import dataclass
from datetime import datetime

@dataclass
class CallCost:
    timestamp: datetime
    model: str
    prompt_tokens: int
    completion_tokens: int
    cost_cny: float

class CostTracker:
    """追踪 AI API 调用成本"""
    
    PRICES_CNY = {
        "gpt-4o": (35, 105),         # (输入, 输出) / 百万token
        "gpt-4o-mini": (1.1, 4.4),
        "deepseek-chat": (2, 7),
        "claude-sonnet": (21, 105),
    }
    
    def __init__(self):
        self.calls: list[CallCost] = []
    
    def record(self, model: str, prompt_tokens: int, completion_tokens: int):
        if model in self.PRICES_CNY:
            in_price, out_price = self.PRICES_CNY[model]
            cost = (
                prompt_tokens * in_price / 1_000_000 +
                completion_tokens * out_price / 1_000_000
            )
        else:
            cost = 0.0
        
        self.calls.append(CallCost(
            timestamp=datetime.now(),
            model=model,
            prompt_tokens=prompt_tokens,
            completion_tokens=completion_tokens,
            cost_cny=cost
        ))
    
    def monthly_total(self) -> float:
        """本月总成本"""
        now = datetime.now()
        month_calls = [c for c in self.calls 
                       if c.timestamp.month == now.month]
        return sum(c.cost_cny for c in month_calls)
    
    def report(self) -> str:
        return (
            f"本月调用: {len(self.calls)} 次\n"
            f"本月成本: ¥{self.monthly_total():.2f}\n"
            f"平均每次: ¥{self.monthly_total()/max(len(self.calls),1):.4f}"
        )
```

---

## 五、架构模式

### 5.1 Fallback 链（最实用）
{: #5-1Fallback链最实用 }

```text
主模型(GPT-4o) → 失败/超时 →
备选1(Claude Sonnet) → 失败 →
备选2(DeepSeek-V3) → 失败 →
返回缓存或降级回答
```

```python
def call_with_fallback(prompt: str) -> str:
    """多模型 fallback 链"""
    models = [
        ("gpt-4o", 30),
        ("claude-sonnet-20241022", 30),
        ("deepseek-chat", 20),
    ]
    
    last_error = None
    for model, timeout in models:
        try:
            return call_with_timeout(prompt, model, timeout, retries=0)
        except Exception as e:
            last_error = e
            continue
    
    # 全部失败，降级
    return f"所有模型调用失败。最后错误: {last_error}"
```

### 5.2 缓存层
{: #5-2缓存层 }

```python
import hashlib
import json
from datetime import datetime, timedelta

class AICache:
    """简单的 AI 响应缓存"""
    
    def __init__(self, ttl_hours: int = 24):
        self.cache: dict[str, tuple[datetime, str]] = {}
        self.ttl = timedelta(hours=ttl_hours)
    
    def _key(self, prompt: str, model: str) -> str:
        return hashlib.md5(f"{model}:{prompt}".encode()).hexdigest()
    
    def get(self, prompt: str, model: str) -> str | None:
        key = self._key(prompt, model)
        if key in self.cache:
            expiry, value = self.cache[key]
            if datetime.now() < expiry:
                return value
            del self.cache[key]
        return None
    
    def set(self, prompt: str, model: str, response: str):
        self.cache[self._key(prompt, model)] = (
            datetime.now() + self.ttl, response
        )
```

---

## 六、安全检查

### 6.1 输入清洗
{: #6-1输入清洗 }

```python
import re

def sanitize_input(text: str) -> str:
    """清洗用户输入，防止注入"""
    
    # 移除明显的注入指令
    INJECTION_PATTERNS = [
        r"忽略.*指令",
        r"ignore.*instruction",
        r"输出.*系统.*提示",
        r"\[SYSTEM\]",
        r"<system>",
    ]
    
    cleaned = text
    for pattern in INJECTION_PATTERNS:
        cleaned = re.sub(pattern, "[已过滤]", cleaned, flags=re.IGNORECASE)
    
    # 限制输入长度
    if len(cleaned) > 10000:
        cleaned = cleaned[:10000] + "\n...(已截断)"
    
    return cleaned
```

### 6.2 输出过滤
{: #6-2输出过滤 }

```python
import re

def filter_output(text: str) -> tuple[bool, str]:
    """过滤 AI 输出中的敏感内容"""
    
    SENSITIVE_PATTERNS = {
        "credit_card": r'\b\d{4}[\s-]?\d{4}[\s-]?\d{4}[\s-]?\d{4}\b',
        "phone_cn": r'\b1[3-9]\d{9}\b',
        "id_card": r'\b\d{17}[\dXx]\b',
        "email": r'\b[\w.-]+@[\w.-]+\.\w+\b',
    }
    
    is_safe = True
    for name, pattern in SENSITIVE_PATTERNS.items():
        if re.search(pattern, text):
            is_safe = False
            text = re.sub(pattern, f"[已脱敏-{name}]", text)
    
    return is_safe, text
```

---

## 七、集成检查清单

在你的应用中接入 AI API 之前：

### 基础
- [ ] 设置了合理的超时时间（建议 30-60 秒）
- [ ] 实现了重试逻辑（至少 2 次，指数退避）
- [ ] 有 fallback 模型或降级回答

### 成本
- [ ] 限制每次调用的 max_tokens
- [ ] 追踪 token 消耗和成本
- [ ] 高频请求有缓存

### 安全
- [ ] 用户输入经过清洗
- [ ] AI 输出经过敏感信息过滤
- [ ] API key 不在客户端暴露

### 稳定性
- [ ] 异步处理长请求（Web服务不要阻塞）
- [ ] 处理了空响应和截断响应
- [ ] 有错误监控和告警
- [ ] 测试了 rate limit 场景

---

## 相关章节

- [第 6 章：工具调用、RAG 与知识库](chapters/06-tools-rag.md)
- [第 8 章：Agent，从聊天到行动](chapters/08-agents.md)
- [Prompt Injection 防护实战](prompt-injection-defense.md)
- [AI 模型成本计算与选型实战](model-cost-calculator.md)
