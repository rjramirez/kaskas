# /llm

Run local LLM. No API calls.

## Input
- Financial questions
- Analysis requests
- Pattern queries
- Recommendation requests

## Process

1. **Load model** → local LLM (Ollama, LM Studio, etc.)
2. **Prepare context** → from `/memory` + `/embed`
3. **Generate response** → using local model
4. **Validate** → check against schemas
5. **Return** → markdown output

## Models

**Recommended**
- Llama 2 (7B, 13B)
- Mistral (7B)
- Neural Chat (7B)
- Orca (7B, 13B)

**Setup**
- Download via Ollama: `ollama pull llama2`
- Or LM Studio: download + run locally
- No internet needed after download

## Commands

- `/llm ask [question]` → ask financial question
- `/llm analyze [data]` → analyze transactions
- `/llm suggest [category]` → get suggestions
- `/llm explain [transaction]` → explain spending

## Examples

**Ask:** "Why high food spending?"
→ LLM analyzes patterns, returns insights

**Analyze:** "My subscriptions"
→ LLM reviews all subs, suggests cuts

**Suggest:** "How reduce utilities?"
→ LLM recommends based on patterns

**Explain:** "Large Grab charge"
→ LLM contextualizes vs normal spending

## Privacy

- All local. No cloud.
- No data leaves device.
- No tracking.
- User owns everything.

Fast. Private. Offline.
