# Ollama Quick Reference Cheatsheet

## Basic Commands

| Command | Description |
|---------|-------------|
| `ollama --version` | Check Ollama version |
| `ollama list` | List installed models |
| `ollama serve` | Start Ollama server |
| `ollama pull <model>` | Download a model |
| `ollama rm <model>` | Remove a model |
| `ollama run <model>` | Run model interactively |
| `ollama run <model> <prompt>` | Run model with prompt |

## Open WebUI Commands

| Command | Description |
|---------|-------------|
| `docker-compose up -d` | Start Open WebUI |
| `docker-compose down` | Stop Open WebUI |
| `docker-compose logs open-webui` | View Open WebUI logs |
| `docker-compose restart open-webui` | Restart Open WebUI |
| `docker-compose ps` | Check Open WebUI status |

## Popular Models

### General Purpose
```bash
ollama pull llama2          # Meta's Llama 2 (7B)
ollama pull llama2:13b      # Llama 2 (13B)
ollama pull llama2:70b      # Llama 2 (70B)
ollama pull mistral         # Mistral AI 7B
ollama pull mixtral         # Mixtral 8x7B
```

### Code Generation
```bash
ollama pull codellama       # Code-focused Llama
ollama pull codellama:13b   # Code Llama (13B)
ollama pull codellama:34b   # Code Llama (34B)
```

### Lightweight Models
```bash
ollama pull gemma:2b        # Google Gemma 2B
ollama pull gemma:7b        # Google Gemma 7B
ollama pull phi2            # Microsoft Phi-2
```

## Usage Examples

### Interactive Chat
```bash
# Start interactive session
ollama run llama2

# Exit interactive mode
/bye or Ctrl+C
```

### One-shot Prompts
```bash
# General question
ollama run llama2 "What is machine learning?"

# Code generation
ollama run codellama "Write a Python function to calculate factorial"

# Creative writing
ollama run mistral "Write a haiku about programming"
```

### Code Generation Examples
```bash
# Python
ollama run codellama "Create a function that sorts a list of dictionaries by a specific key"

# JavaScript
ollama run codellama "Write a React hook for managing form state"

# Shell script
ollama run codellama "Create a bash script that backs up files older than 30 days"

# SQL
ollama run codellama "Write a SQL query to find duplicate records in a table"
```

## Advanced Usage

### Model Parameters
```bash
# Set temperature (creativity)
ollama run llama2 --temperature 0.7

# Set top-p (nucleus sampling)
ollama run llama2 --top-p 0.9

# Set top-k
ollama run llama2 --top-k 40

# Set seed for reproducible results
ollama run llama2 --seed 42
```

### File Input
```bash
# Run with file input
ollama run codellama < input.txt

# Run with file and prompt
echo "Explain this code:" | cat - input.txt | ollama run codellama
```

### API Usage
```bash
# Start server
ollama serve

# Use with curl
curl -X POST http://localhost:11434/api/generate \
  -H "Content-Type: application/json" \
  -d '{
    "model": "llama2",
    "prompt": "Hello, how are you?"
  }'
```

## Model Management

### Check Model Info
```bash
# List all models
ollama list

# Show model details
ollama show llama2
```

### Update Models
```bash
# Pull latest version
ollama pull llama2

# Remove old version
ollama rm llama2
```

### Custom Models
```bash
# Create custom model from Modelfile
ollama create mymodel -f Modelfile

# Run custom model
ollama run mymodel
```

## Troubleshooting

### Common Issues
```bash
# Check if Ollama is running
ps aux | grep ollama

# Restart Ollama service
pkill ollama && ollama serve

# Check disk space
df -h

# Check available memory
free -h
```

### Performance Tips
```bash
# Use smaller models for faster responses
ollama run gemma:2b

# Use larger models for better quality
ollama run llama2:70b

# Close other applications to free memory
```

## Environment Variables

| Variable | Description |
|----------|-------------|
| `OLLAMA_HOST` | Set Ollama server host |
| `OLLAMA_ORIGINS` | Set allowed origins |
| `OLLAMA_MODELS` | Set models directory |

## Integration Examples

### Python Integration
```python
import requests

def ask_ollama(prompt, model="llama2"):
    response = requests.post(
        "http://localhost:11434/api/generate",
        json={"model": model, "prompt": prompt}
    )
    return response.json()["response"]

# Usage
answer = ask_ollama("What is Python?")
print(answer)
```

### JavaScript Integration
```javascript
async function askOllama(prompt, model = "llama2") {
    const response = await fetch("http://localhost:11434/api/generate", {
        method: "POST",
        headers: { "Content-Type": "application/json" },
        body: JSON.stringify({ model, prompt })
    });
    const data = await response.json();
    return data.response;
}

// Usage
askOllama("What is JavaScript?").then(console.log);
```

## Open WebUI Usage

### Accessing the Web Interface
- **URL**: http://localhost:3000
- **Default login**: admin / admin
- **Change password**: Required after first login

### Web Interface Features
- **Chat with AI models** through web browser
- **Install/remove models** via web interface
- **Chat history** and conversation management
- **Multiple user accounts** with authentication
- **API access** for integration
- **Mobile responsive** design

### Managing Open WebUI
```bash
# Start Open WebUI
docker-compose up -d

# Stop Open WebUI
docker-compose down

# Check status
docker-compose ps

# View logs
docker-compose logs -f open-webui

# Update Open WebUI
docker-compose pull && docker-compose up -d
```

## Quick Start Commands

```bash
# 1. Install Ollama (if not already installed)
curl -fsSL https://ollama.ai/install.sh | sh

# 2. Start Ollama service
ollama serve

# 3. Download a model
ollama pull llama2

# 4. Test the model
ollama run llama2 "Hello, world!"

# 5. Start coding with AI
ollama run codellama "Write a hello world program in Python"

# 6. Optional: Start Open WebUI
docker-compose up -d
```

---

**Pro Tip**: Use `ollama run <model> --help` to see all available options for a specific model!
