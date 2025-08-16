#!/bin/bash

# Ollama Installation Script with AI Model Selection
# This script installs Ollama and provides options to install various AI models

set -e  # Exit on any error

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Function to print colored output
print_status() {
    echo -e "${GREEN}[INFO]${NC} $1"
}

print_warning() {
    echo -e "${YELLOW}[WARNING]${NC} $1"
}

print_error() {
    echo -e "${RED}[ERROR]${NC} $1"
}

print_header() {
    echo -e "${BLUE}================================${NC}"
    echo -e "${BLUE}$1${NC}"
    echo -e "${BLUE}================================${NC}"
}

# Function to check if command exists
command_exists() {
    command -v "$1" >/dev/null 2>&1
}

# Function to detect OS
detect_os() {
    if [[ "$OSTYPE" == "linux-gnu"* ]]; then
        if command_exists apt-get; then
            echo "ubuntu"
        elif command_exists yum; then
            echo "centos"
        elif command_exists dnf; then
            echo "fedora"
        else
            echo "linux"
        fi
    elif [[ "$OSTYPE" == "darwin"* ]]; then
        echo "macos"
    else
        echo "unknown"
    fi
}

# Function to install Ollama
install_ollama() {
    print_header "Installing Ollama"
    
    local os=$(detect_os)
    
    case $os in
        "macos")
            print_status "Installing Ollama on macOS..."
            if command_exists brew; then
                brew install ollama
            else
                print_warning "Homebrew not found. Installing via curl..."
                curl -fsSL https://ollama.ai/install.sh | sh
            fi
            ;;
        "ubuntu"|"debian")
            print_status "Installing Ollama on Ubuntu/Debian..."
            curl -fsSL https://ollama.ai/install.sh | sh
            ;;
        "centos"|"fedora")
            print_status "Installing Ollama on CentOS/Fedora..."
            curl -fsSL https://ollama.ai/install.sh | sh
            ;;
        *)
            print_error "Unsupported operating system: $os"
            print_status "Please visit https://ollama.ai/download for manual installation"
            exit 1
            ;;
    esac
    
    print_status "Ollama installation completed!"
}

# Function to start Ollama service
start_ollama() {
    print_status "Starting Ollama service..."
    
    if ! ollama serve >/dev/null 2>&1 & then
        print_error "Failed to start Ollama service"
        exit 1
    fi
    
    # Wait a moment for the service to start
    sleep 3
    
    if pgrep -f "ollama serve" >/dev/null; then
        print_status "Ollama service started successfully!"
    else
        print_error "Ollama service failed to start"
        exit 1
    fi
}

# Function to install AI model
install_model() {
    local model_name=$1
    print_status "Installing model: $model_name"
    
    if ollama pull "$model_name"; then
        print_status "Successfully installed $model_name"
    else
        print_error "Failed to install $model_name"
        return 1
    fi
}

# Function to show model menu
show_model_menu() {
    print_header "AI Model Selection"
    echo "Available models to install:"
    echo ""
    echo "1)  llama2          - Meta's Llama 2 (7B parameters)"
    echo "2)  llama2:13b      - Meta's Llama 2 (13B parameters)"
    echo "3)  llama2:70b      - Meta's Llama 2 (70B parameters)"
    echo "4)  codellama       - Code-focused Llama 2 variant"
    echo "5)  codellama:13b   - Code-focused Llama 2 (13B parameters)"
    echo "6)  codellama:34b   - Code-focused Llama 2 (34B parameters)"
    echo "7)  mistral         - Mistral AI's 7B model"
    echo "8)  mixtral         - Mixtral 8x7B MoE model"
    echo "9)  gemma:2b        - Google's Gemma 2B model"
    echo "10) gemma:7b        - Google's Gemma 7B model"
    echo "11) phi2            - Microsoft's Phi-2 model"
    echo "12) neural-chat     - Intel's Neural Chat model"
    echo "13) qwen2:7b        - Alibaba's Qwen2 7B model"
    echo "14) qwen2:14b       - Alibaba's Qwen2 14B model"
    echo "15) custom          - Enter custom model name"
    echo "16) all             - Install all models (WARNING: Large download)"
    echo "0)  skip            - Skip model installation"
    echo ""
}

# Function to get model name by selection
get_model_name() {
    local selection=$1
    case $selection in
        1) echo "llama2" ;;
        2) echo "llama2:13b" ;;
        3) echo "llama2:70b" ;;
        4) echo "codellama" ;;
        5) echo "codellama:13b" ;;
        6) echo "codellama:34b" ;;
        7) echo "mistral" ;;
        8) echo "mixtral" ;;
        9) echo "gemma:2b" ;;
        10) echo "gemma:7b" ;;
        11) echo "phi2" ;;
        12) echo "neural-chat" ;;
        13) echo "qwen2:7b" ;;
        14) echo "qwen2:14b" ;;
        15) 
            echo -n "Enter custom model name: "
            read custom_model
            echo "$custom_model"
            ;;
        16) echo "all" ;;
        *) echo "" ;;
    esac
}

# Function to install selected models
install_selected_models() {
    local models=("$@")
    
    for model in "${models[@]}"; do
        if [[ "$model" == "all" ]]; then
            print_warning "Installing all models. This will download several GB of data."
            echo -n "Are you sure? (y/N): "
            read -r confirm
            if [[ "$confirm" =~ ^[Yy]$ ]]; then
                local all_models=(
                    "llama2" "llama2:13b" "llama2:70b" "codellama" "codellama:13b" 
                    "codellama:34b" "mistral" "mixtral" "gemma:2b" "gemma:7b" 
                    "phi2" "neural-chat" "qwen2:7b" "qwen2:14b"
                )
                for m in "${all_models[@]}"; do
                    install_model "$m"
                done
            else
                print_status "Skipping all models installation"
            fi
        elif [[ -n "$model" ]]; then
            install_model "$model"
        fi
    done
}

# Function to test Ollama installation
test_ollama() {
    print_header "Testing Ollama Installation"
    
    if command_exists ollama; then
        print_status "Ollama command found"
        
        # Test basic functionality
        if ollama list >/dev/null 2>&1; then
            print_status "Ollama is working correctly!"
            echo ""
            ollama list
        else
            print_error "Ollama is not responding properly"
            return 1
        fi
    else
        print_error "Ollama command not found"
        return 1
    fi
}

# Function to show usage information
show_usage() {
    print_header "Ollama Usage Information"
    echo "After installation, you can use Ollama with these commands:"
    echo ""
    echo "  ollama list                    - List installed models"
    echo "  ollama run <model_name>        - Run a model interactively"
    echo "  ollama run <model_name> <prompt> - Run a model with a prompt"
    echo "  ollama pull <model_name>       - Download a new model"
    echo "  ollama rm <model_name>         - Remove a model"
    echo "  ollama serve                   - Start the Ollama server"
    echo ""
    echo "Examples:"
    echo "  ollama run llama2 'Hello, how are you?'"
    echo "  ollama run codellama 'Write a Python function to sort a list'"
    echo ""
}

# Function to show installation mode menu
show_installation_mode_menu() {
    print_header "Installation Mode Selection"
    echo "Choose what you want to install:"
    echo ""
    echo "1)  Ollama + AI Models     - Install Ollama and select AI models"
    echo "2)  Ollama Only            - Install Ollama without AI models"
    echo "3)  Open WebUI Only        - Install Open WebUI (requires existing Ollama)"
    echo "4)  Ollama + Open WebUI    - Install both Ollama and Open WebUI"
    echo "5)  Complete Setup         - Install Ollama, AI models, and Open WebUI"
    echo "0)  Exit                   - Exit without installing anything"
    echo ""
}

# Function to get installation mode
get_installation_mode() {
    local selection=$1
    case $selection in
        1) echo "ollama_models" ;;
        2) echo "ollama_only" ;;
        3) echo "webui_only" ;;
        4) echo "ollama_webui" ;;
        5) echo "complete" ;;
        0) echo "exit" ;;
        *) echo "" ;;
    esac
}

# Function to install Open WebUI
install_open_webui() {
    print_header "Installing Open WebUI"
    
    # Check if Docker is installed
    if ! command_exists docker; then
        print_error "Docker is required to install Open WebUI"
        print_status "Please install Docker first: https://docs.docker.com/get-docker/"
        return 1
    fi
    
    # Check if Docker is running
    if ! docker info >/dev/null 2>&1; then
        print_error "Docker is not running"
        print_status "Please start Docker and try again"
        return 1
    fi
    
    print_status "Pulling Open WebUI Docker image..."
    if docker pull ghcr.io/open-webui/open-webui:main; then
        print_status "Open WebUI Docker image pulled successfully"
    else
        print_error "Failed to pull Open WebUI Docker image"
        return 1
    fi
    
    # Create docker-compose.yml for Open WebUI
    print_status "Creating Open WebUI configuration..."
    cat > docker-compose.yml << 'EOF'
version: '3.8'

services:
  open-webui:
    image: ghcr.io/open-webui/open-webui:main
    container_name: open-webui
    restart: unless-stopped
    ports:
      - "3000:8080"
    environment:
      - OLLAMA_BASE_URL=http://host.docker.internal:11434
      - WEBUI_SECRET_KEY=your-secret-key-here
    volumes:
      - open-webui:/app/backend/data
    extra_hosts:
      - "host.docker.internal:host-gateway"

volumes:
  open-webui:
EOF
    
    print_status "Starting Open WebUI..."
    if docker-compose up -d; then
        print_status "Open WebUI started successfully!"
        echo ""
        print_status "Open WebUI is now available at: http://localhost:3000"
        print_status "Default credentials: admin / admin"
        echo ""
        print_warning "Please change the default password after first login!"
    else
        print_error "Failed to start Open WebUI"
        return 1
    fi
}

# Function to check if Open WebUI is already installed
check_open_webui() {
    if docker ps --format "table {{.Names}}" | grep -q "open-webui"; then
        return 0
    else
        return 1
    fi
}

# Main installation function
main() {
    print_header "Ollama AI Installation Script"
    echo "This script will help you install Ollama, AI models, and Open WebUI."
    echo ""
    
    # Show installation mode menu
    show_installation_mode_menu
    
    local mode=""
    while [[ -z "$mode" ]]; do
        echo -n "Enter your choice (0-5): "
        read -r choice
        
        mode=$(get_installation_mode "$choice")
        if [[ -z "$mode" ]]; then
            print_error "Invalid choice. Please enter a number between 0-5"
        fi
    done
    
    # Handle exit
    if [[ "$mode" == "exit" ]]; then
        print_status "Exiting installation script"
        exit 0
    fi
    
    # Handle different installation modes
    case $mode in
        "ollama_models")
            install_ollama_if_needed
            install_ai_models
            ;;
        "ollama_only")
            install_ollama_if_needed
            ;;
        "webui_only")
            if ! command_exists ollama; then
                print_error "Ollama is required to use Open WebUI"
                print_status "Please install Ollama first or choose option 4 or 5"
                exit 1
            fi
            install_open_webui
            ;;
        "ollama_webui")
            install_ollama_if_needed
            install_open_webui
            ;;
        "complete")
            install_ollama_if_needed
            install_ai_models
            install_open_webui
            ;;
    esac
    
    # Show final instructions
    show_final_instructions "$mode"
}

# Function to install Ollama if needed
install_ollama_if_needed() {
    # Check if Ollama is already installed
    if command_exists ollama; then
        print_warning "Ollama is already installed!"
        echo -n "Do you want to reinstall? (y/N): "
        read -r reinstall
        if [[ ! "$reinstall" =~ ^[Yy]$ ]]; then
            print_status "Skipping Ollama installation"
        else
            install_ollama
        fi
    else
        install_ollama
    fi
    
    # Start Ollama service
    start_ollama
    
    # Test installation
    if test_ollama; then
        print_status "Ollama installation verified successfully!"
    else
        print_error "Ollama installation test failed"
        exit 1
    fi
}

# Function to install AI models
install_ai_models() {
    # Model installation
    echo ""
    show_model_menu
    
    local selected_models=()
    while true; do
        echo -n "Enter your choice (0-16, or 'done' to finish): "
        read -r choice
        
        if [[ "$choice" == "done" ]]; then
            break
        elif [[ "$choice" == "0" ]]; then
            print_status "Skipping model installation"
            break
        elif [[ "$choice" =~ ^[0-9]+$ ]] && [[ "$choice" -ge 1 ]] && [[ "$choice" -le 16 ]]; then
            local model_name=$(get_model_name "$choice")
            if [[ -n "$model_name" ]]; then
                selected_models+=("$model_name")
                if [[ "$model_name" == "all" ]]; then
                    break
                fi
            fi
        else
            print_error "Invalid choice. Please enter a number between 0-16 or 'done'"
        fi
    done
    
    # Install selected models
    if [[ ${#selected_models[@]} -gt 0 ]]; then
        print_header "Installing Selected Models"
        install_selected_models "${selected_models[@]}"
    fi
}

# Function to show final instructions based on installation mode
show_final_instructions() {
    local mode=$1
    
    print_header "Installation Complete!"
    
    case $mode in
        "ollama_models")
            print_status "Ollama and AI models have been successfully installed!"
            print_status "You can now start using AI models with the 'ollama run' command."
            ;;
        "ollama_only")
            print_status "Ollama has been successfully installed!"
            print_status "You can install models later using: ollama pull <model_name>"
            ;;
        "webui_only")
            print_status "Open WebUI has been successfully installed!"
            print_status "Access the web interface at: http://localhost:3000"
            ;;
        "ollama_webui")
            print_status "Ollama and Open WebUI have been successfully installed!"
            print_status "Access the web interface at: http://localhost:3000"
            print_status "You can install models later using: ollama pull <model_name>"
            ;;
        "complete")
            print_status "Complete setup has been successfully installed!"
            print_status "Access the web interface at: http://localhost:3000"
            print_status "You can also use AI models directly with: ollama run <model_name>"
            ;;
    esac
    
    echo ""
    show_usage
    
    if [[ "$mode" == *"webui"* ]]; then
        echo ""
        print_status "Open WebUI Information:"
        echo "  - URL: http://localhost:3000"
        echo "  - Default username: admin"
        echo "  - Default password: admin"
        echo "  - Change password after first login!"
        echo ""
        print_status "To stop Open WebUI: docker-compose down"
        print_status "To start Open WebUI: docker-compose up -d"
    fi
    
    echo ""
    print_status "Happy AI coding! 🚀"
}
    


# Run main function
main "$@"
#end of script