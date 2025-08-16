#!/bin/bash

# Open WebUI Management Script
# This script helps manage Open WebUI installation and operations

set -e

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

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

# Function to check if Open WebUI is running
check_webui_status() {
    if docker ps --format "table {{.Names}}" | grep -q "open-webui"; then
        return 0
    else
        return 1
    fi
}

# Function to install Open WebUI
install_webui() {
    print_header "Installing Open WebUI"
    
    # Check if Docker is installed
    if ! command_exists docker; then
        print_error "Docker is required to install Open WebUI"
        print_status "Please install Docker first: https://docs.docker.com/get-docker/"
        exit 1
    fi
    
    # Check if Docker is running
    if ! docker info >/dev/null 2>&1; then
        print_error "Docker is not running"
        print_status "Please start Docker and try again"
        exit 1
    fi
    
    # Check if Ollama is running
    if ! pgrep -f "ollama serve" >/dev/null; then
        print_error "Ollama is not running"
        print_status "Please start Ollama first: ollama serve"
        exit 1
    fi
    
    print_status "Pulling Open WebUI Docker image..."
    if docker pull ghcr.io/open-webui/open-webui:main; then
        print_status "Open WebUI Docker image pulled successfully"
    else
        print_error "Failed to pull Open WebUI Docker image"
        exit 1
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
        exit 1
    fi
}

# Function to start Open WebUI
start_webui() {
    print_header "Starting Open WebUI"
    
    if check_webui_status; then
        print_warning "Open WebUI is already running"
        return 0
    fi
    
    if [[ ! -f "docker-compose.yml" ]]; then
        print_error "docker-compose.yml not found"
        print_status "Please run install first"
        exit 1
    fi
    
    print_status "Starting Open WebUI..."
    if docker-compose up -d; then
        print_status "Open WebUI started successfully!"
        print_status "Access at: http://localhost:3000"
    else
        print_error "Failed to start Open WebUI"
        exit 1
    fi
}

# Function to stop Open WebUI
stop_webui() {
    print_header "Stopping Open WebUI"
    
    if ! check_webui_status; then
        print_warning "Open WebUI is not running"
        return 0
    fi
    
    print_status "Stopping Open WebUI..."
    if docker-compose down; then
        print_status "Open WebUI stopped successfully!"
    else
        print_error "Failed to stop Open WebUI"
        exit 1
    fi
}

# Function to restart Open WebUI
restart_webui() {
    print_header "Restarting Open WebUI"
    
    stop_webui
    sleep 2
    start_webui
}

# Function to show status
show_status() {
    print_header "Open WebUI Status"
    
    if check_webui_status; then
        print_status "✓ Open WebUI is running"
        echo ""
        print_status "Container information:"
        docker ps --filter "name=open-webui" --format "table {{.Names}}\t{{.Status}}\t{{.Ports}}"
        echo ""
        print_status "Access URL: http://localhost:3000"
    else
        print_warning "⚠ Open WebUI is not running"
        echo ""
        print_status "To start Open WebUI, run: $0 start"
    fi
}

# Function to show logs
show_logs() {
    print_header "Open WebUI Logs"
    
    if check_webui_status; then
        docker-compose logs -f open-webui
    else
        print_warning "Open WebUI is not running"
        print_status "To start Open WebUI, run: $0 start"
    fi
}

# Function to update Open WebUI
update_webui() {
    print_header "Updating Open WebUI"
    
    print_status "Pulling latest Open WebUI image..."
    if docker pull ghcr.io/open-webui/open-webui:main; then
        print_status "Latest image pulled successfully"
        
        if check_webui_status; then
            print_status "Restarting Open WebUI with new image..."
            restart_webui
        else
            print_status "Open WebUI is not running. New image is ready for next start."
        fi
    else
        print_error "Failed to pull latest image"
        exit 1
    fi
}

# Function to uninstall Open WebUI
uninstall_webui() {
    print_header "Uninstalling Open WebUI"
    
    print_warning "This will remove Open WebUI and all its data!"
    echo -n "Are you sure? (y/N): "
    read -r confirm
    
    if [[ ! "$confirm" =~ ^[Yy]$ ]]; then
        print_status "Uninstallation cancelled"
        exit 0
    fi
    
    if check_webui_status; then
        print_status "Stopping Open WebUI..."
        docker-compose down
    fi
    
    print_status "Removing Open WebUI container and volumes..."
    docker-compose down -v 2>/dev/null || true
    
    print_status "Removing Open WebUI image..."
    docker rmi ghcr.io/open-webui/open-webui:main 2>/dev/null || true
    
    print_status "Removing configuration files..."
    rm -f docker-compose.yml
    
    print_status "Open WebUI has been completely removed!"
}

# Function to show help
show_help() {
    print_header "Open WebUI Management Script"
    echo "Usage: $0 [COMMAND]"
    echo ""
    echo "Commands:"
    echo "  install     Install Open WebUI"
    echo "  start       Start Open WebUI"
    echo "  stop        Stop Open WebUI"
    echo "  restart     Restart Open WebUI"
    echo "  status      Show Open WebUI status"
    echo "  logs        Show Open WebUI logs"
    echo "  update      Update Open WebUI to latest version"
    echo "  uninstall   Remove Open WebUI completely"
    echo "  help        Show this help message"
    echo ""
    echo "Examples:"
    echo "  $0 install    # Install Open WebUI"
    echo "  $0 start      # Start Open WebUI"
    echo "  $0 status     # Check if Open WebUI is running"
    echo ""
}

# Main script logic
case "${1:-help}" in
    install)
        install_webui
        ;;
    start)
        start_webui
        ;;
    stop)
        stop_webui
        ;;
    restart)
        restart_webui
        ;;
    status)
        show_status
        ;;
    logs)
        show_logs
        ;;
    update)
        update_webui
        ;;
    uninstall)
        uninstall_webui
        ;;
    help|--help|-h)
        show_help
        ;;
    *)
        print_error "Unknown command: $1"
        echo ""
        show_help
        exit 1
        ;;
esac

