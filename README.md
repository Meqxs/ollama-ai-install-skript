# Ollama AI Installation Script

A comprehensive installation script for Ollama with AI model selection options. This script automates the installation of Ollama and provides an interactive menu to install various AI models.

## Features

- **Multiple installation modes**: Choose between Ollama only, AI models, Open WebUI, or complete setup
- **Cross-platform support**: Works on macOS, Ubuntu, Debian, CentOS, and Fedora
- **Automatic OS detection**: Detects your operating system and installs accordingly
- **Interactive model selection**: Choose from popular AI models or enter custom ones
- **Open WebUI integration**: Install and configure Open WebUI for web-based AI interface
- **Comprehensive error handling**: Robust error checking and user feedback
- **Colored output**: Easy-to-read colored status messages
- **Installation verification**: Tests the installation to ensure everything works

## Supported AI Models

The script includes options for these popular models:

### General Purpose Models
- **llama2** - Meta's Llama 2 (7B parameters)
- **llama2:13b** - Meta's Llama 2 (13B parameters)
- **llama2:70b** - Meta's Llama 2 (70B parameters)
- **mistral** - Mistral AI's 7B model
- **mixtral** - Mixtral 8x7B MoE model

### Code-Focused Models
- **codellama** - Code-focused Llama 2 variant
- **codellama:13b** - Code-focused Llama 2 (13B parameters)
- **codellama:34b** - Code-focused Llama 2 (34B parameters)

### Other Models
- **gemma:2b** - Google's Gemma 2B model
- **gemma:7b** - Google's Gemma 7B model
- **phi2** - Microsoft's Phi-2 model
- **neural-chat** - Intel's Neural Chat model
- **qwen2:7b** - Alibaba's Qwen2 7B model
- **qwen2:14b** - Alibaba's Qwen2 14B model

## Installation

### Prerequisites

- **macOS**: Homebrew (recommended) or curl
- **Linux**: curl (usually pre-installed)
- **Internet connection** for downloading Ollama and models

### Quick Start

1. **Download the script**:
   ```bash
   # Clone the repository
   git clone https://github.com/yourusername/ollama-ai-install-skript.git
   cd ollama-ai-install-skript
   
   # Or download directly with curl
   curl -O https://raw.githubusercontent.com/yourusername/ollama-ai-install-skript/main/install_ollama.sh
   ```

2. **Make it executable**:
   ```bash
   chmod +x install_ollama.sh
   ```

3. **Run the installation**:
   ```bash
   ./install_ollama.sh
   ```

4. **Choose installation mode**:
   - **Ollama + AI Models**: Install Ollama and select AI models
   - **Ollama Only**: Install Ollama without AI models
   - **Open WebUI Only**: Install Open WebUI (requires existing Ollama)
   - **Ollama + Open WebUI**: Install both Ollama and Open WebUI
   - **Complete Setup**: Install Ollama, AI models, and Open WebUI

### What the Script Does

1. **Shows installation mode menu** to choose what to install
2. **Detects your operating system**
3. **Installs Ollama** (if selected) using the appropriate method for your OS
4. **Starts the Ollama service** (if Ollama is installed)
5. **Verifies the installation**
6. **Presents an interactive menu** to select AI models (if selected)
7. **Downloads and installs** your selected models
8. **Installs Open WebUI** (if selected) with Docker
9. **Provides usage instructions**

## Installation Modes

### 1. Ollama + AI Models
- Installs Ollama and allows you to select AI models
- Best for users who want to use AI models via command line
- Includes interactive model selection menu

### 2. Ollama Only
- Installs Ollama without any AI models
- Best for users who want to install models later
- Minimal installation with just the Ollama runtime

### 3. Open WebUI Only
- Installs Open WebUI (requires existing Ollama installation)
- Best for users who already have Ollama installed
- Provides web-based interface for AI interactions

### 4. Ollama + Open WebUI
- Installs both Ollama and Open WebUI
- Best for users who want web interface without AI models initially
- Models can be installed later through the web interface

### 5. Complete Setup
- Installs Ollama, AI models, and Open WebUI
- Best for users who want everything set up at once
- Full-featured AI development environment

## Open WebUI

Open WebUI provides a beautiful web interface for interacting with your AI models. Features include:

- **Web-based chat interface** for all your AI models
- **Model management** - install, remove, and switch between models
- **Chat history** and conversation management
- **Multiple user support** with authentication
- **API access** for integration with other applications
- **Responsive design** that works on desktop and mobile

### Open WebUI Requirements
- **Docker**: Required for running Open WebUI
- **Ollama**: Must be installed and running
- **Port 3000**: Used by the web interface

### Accessing Open WebUI
- **URL**: http://localhost:3000
- **Default username**: admin
- **Default password**: admin
- **Important**: Change the default password after first login!

## Usage Examples

After installation, you can use Ollama with these commands:

### Basic Usage
```bash
# List installed models
ollama list

# Run a model interactively
ollama run llama2

# Run a model with a specific prompt
ollama run codellama "Write a Python function to sort a list"

# Download a new model
ollama pull llama2:13b

# Remove a model
ollama rm llama2
```

### Code Generation Examples
```bash
# Generate Python code
ollama run codellama "Create a function that calculates fibonacci numbers"

# Generate JavaScript code
ollama run codellama "Write a React component for a todo list"

# Generate shell script
ollama run codellama "Create a bash script to backup files"
```

### Chat Examples
```bash
# General conversation
ollama run llama2 "Explain quantum computing in simple terms"

# Creative writing
ollama run mistral "Write a short story about a robot learning to paint"

# Problem solving
ollama run mixtral "Help me plan a weekend trip to the mountains"
```

### Open WebUI Commands
```bash
# Start Open WebUI (if installed via script)
docker-compose up -d

# Stop Open WebUI
docker-compose down

# View Open WebUI logs
docker-compose logs open-webui

# Restart Open WebUI
docker-compose restart open-webui
```

## Model Sizes and Requirements

| Model | Size | RAM Required | Best For |
|-------|------|--------------|----------|
| llama2 | ~4GB | 8GB+ | General purpose |
| llama2:13b | ~8GB | 16GB+ | Better reasoning |
| llama2:70b | ~40GB | 64GB+ | High performance |
| codellama | ~4GB | 8GB+ | Code generation |
| mistral | ~4GB | 8GB+ | Fast responses |
| mixtral | ~26GB | 32GB+ | High quality |
| gemma:2b | ~1.5GB | 4GB+ | Lightweight |
| gemma:7b | ~4GB | 8GB+ | Good balance |

## Troubleshooting

### Common Issues

1. **"Permission denied" error**:
   ```bash
   chmod +x install_ollama.sh
   ```

2. **Ollama service won't start**:
   ```bash
   # Check if Ollama is running
   ps aux | grep ollama
   
   # Start manually
   ollama serve
   ```

3. **Model download fails**:
   - Check your internet connection
   - Ensure you have enough disk space
   - Try downloading the model manually: `ollama pull <model_name>`

4. **Out of memory errors**:
   - Close other applications
   - Use smaller models (2B or 7B variants)
   - Increase your system's swap space

### Getting Help

- **Ollama Documentation**: https://ollama.ai/docs
- **Ollama GitHub**: https://github.com/ollama/ollama
- **Model Library**: https://ollama.ai/library

## System Requirements

### Minimum Requirements
- **CPU**: 64-bit processor
- **RAM**: 4GB (8GB recommended)
- **Storage**: 10GB free space
- **OS**: macOS 10.15+, Ubuntu 18.04+, or equivalent
- **Docker**: Required for Open WebUI (if using web interface)

### Recommended Requirements
- **CPU**: Multi-core processor
- **RAM**: 16GB or more
- **Storage**: 50GB+ free space
- **GPU**: NVIDIA GPU with CUDA support (optional, for acceleration)
- **Docker**: Latest version for Open WebUI

## License

This script is provided as-is for educational and personal use. Ollama itself is licensed under the MIT License.

## Contributing

Feel free to submit issues, feature requests, or pull requests to improve this installation script.

---

**Happy AI coding! 🚀**
