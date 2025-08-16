#!/bin/bash

# Test script for Ollama installation
# This script verifies that Ollama is properly installed and working

set -e

# Colors for output
GREEN='\033[0;32m'
RED='\033[0;31m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

print_status() {
    echo -e "${GREEN}[TEST]${NC} $1"
}

print_error() {
    echo -e "${RED}[ERROR]${NC} $1"
}

print_warning() {
    echo -e "${YELLOW}[WARNING]${NC} $1"
}

echo "=================================="
echo "Ollama Installation Test Script"
echo "=================================="
echo ""

# Test 1: Check if Ollama is installed
print_status "Testing Ollama installation..."
if command -v ollama >/dev/null 2>&1; then
    print_status "✓ Ollama is installed"
    ollama_version=$(ollama --version 2>/dev/null || echo "version unknown")
    echo "   Version: $ollama_version"
else
    print_error "✗ Ollama is not installed or not in PATH"
    exit 1
fi

# Test 2: Check if Ollama service is running
print_status "Testing Ollama service..."
if pgrep -f "ollama serve" >/dev/null; then
    print_status "✓ Ollama service is running"
else
    print_warning "⚠ Ollama service is not running"
    echo "   Starting Ollama service..."
    if ollama serve >/dev/null 2>&1 & then
        sleep 3
        if pgrep -f "ollama serve" >/dev/null; then
            print_status "✓ Ollama service started successfully"
        else
            print_error "✗ Failed to start Ollama service"
            exit 1
        fi
    else
        print_error "✗ Failed to start Ollama service"
        exit 1
    fi
fi

# Test 3: Test basic Ollama functionality
print_status "Testing Ollama basic functionality..."
if ollama list >/dev/null 2>&1; then
    print_status "✓ Ollama is responding to commands"
    echo ""
    echo "Installed models:"
    ollama list
else
    print_error "✗ Ollama is not responding properly"
    exit 1
fi

# Test 4: Check available models
print_status "Checking available models..."
model_count=$(ollama list 2>/dev/null | wc -l)
if [ "$model_count" -gt 1 ]; then
    print_status "✓ Found $((model_count - 1)) installed model(s)"
else
    print_warning "⚠ No models installed yet"
    echo "   You can install models using: ollama pull <model_name>"
    echo "   Example: ollama pull llama2"
fi

# Test 5: Test model download (optional)
echo ""
echo "=================================="
echo "Optional: Test Model Download"
echo "=================================="
echo "This will download a small test model to verify everything works."
echo -n "Do you want to test downloading a model? (y/N): "
read -r test_download

if [[ "$test_download" =~ ^[Yy]$ ]]; then
    print_status "Testing model download with phi2 (small model)..."
    if ollama pull phi2; then
        print_status "✓ Model download test successful!"
        echo ""
        echo "Testing model inference..."
        if echo "Hello, how are you?" | ollama run phi2 >/dev/null 2>&1; then
            print_status "✓ Model inference test successful!"
        else
            print_warning "⚠ Model inference test failed (this might be normal for some models)"
        fi
    else
        print_error "✗ Model download test failed"
        print_warning "This might be due to network issues or insufficient disk space"
    fi
fi

echo ""
echo "=================================="
echo "Test Results Summary"
echo "=================================="
print_status "Ollama installation test completed!"
echo ""
echo "If all tests passed, your Ollama installation is working correctly."
echo ""
echo "Next steps:"
echo "1. Install models: ollama pull <model_name>"
echo "2. Run models: ollama run <model_name>"
echo "3. Get help: ollama --help"
echo ""
echo "Happy AI coding! 🚀"
