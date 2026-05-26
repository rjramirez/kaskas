# Local LLM Configuration

## Supported Models

### Llama 2
- Size: 7B, 13B, 70B
- Speed: fast (7B), medium (13B)
- Quality: high
- Setup: `ollama pull llama2`

### Mistral
- Size: 7B
- Speed: very fast
- Quality: high
- Setup: `ollama pull mistral`

### Neural Chat
- Size: 7B
- Speed: fast
- Quality: good
- Setup: `ollama pull neural-chat`

### Orca
- Size: 7B, 13B
- Speed: medium
- Quality: very high
- Setup: `ollama pull orca-mini`

## Setup

### Ollama (Recommended)
1. Download: https://ollama.ai
2. Install locally
3. Run: `ollama serve`
4. Pull model: `ollama pull llama2`
5. Access: localhost:11434

### LM Studio
1. Download: https://lmstudio.ai
2. Install locally
3. Download model in UI
4. Start server
5. Access: localhost:1234

## Configuration

**Model Selection**
- Default: llama2:7b
- Fallback: mistral:7b
- Custom: user-specified

**Parameters**
- Temperature: 0.7 (balanced)
- Top-p: 0.9 (diversity)
- Max tokens: 1024 (response length)
- Context: 2048 tokens (memory)

## Performance

**7B Models**
- Response time: 1-5 seconds
- Memory: 4-8GB RAM
- Quality: good

**13B Models**
- Response time: 3-10 seconds
- Memory: 8-16GB RAM
- Quality: very good

**70B Models**
- Response time: 10-30 seconds
- Memory: 40GB+ RAM
- Quality: excellent

## Privacy

- All local
- No internet needed
- No data transmission
- User owns everything

## Fallback

If local LLM unavailable:
- Use Claude API (with permission)
- Or return error + manual analysis

Local first. Always.
