#!/bin/bash

set -e

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
CYAN='\033[0;36m'
NC='\033[0m' # No Color

# Configuration
GITHUB_REPO="ft-karlsson/nordkraft-io"
INSTALL_DIR="/usr/local/bin"
BINARY_NAME="nordkraft"
BASE_URL="https://github.com/${GITHUB_REPO}/releases/latest/download"

# Banner
echo -e "${CYAN}🚀 Nordkraft CLI Installer${NC}"
echo -e "${CYAN}Zero-Trust Container Cloud${NC}"
echo ""

# Function to print colored output
print_status() {
    echo -e "${GREEN}✓${NC} $1"
}

print_warning() {
    echo -e "${YELLOW}⚠${NC} $1"
}

print_error() {
    echo -e "${RED}✗${NC} $1" >&2
}

print_info() {
    echo -e "${BLUE}ℹ${NC} $1"
}

# Function to detect OS and architecture
detect_platform() {
    local os=""
    local arch=""
    
    # Detect OS
    case "$(uname -s)" in
        Darwin*)
            os="darwin"
            ;;
        Linux*)
            os="linux"
            ;;
        *)
            print_error "Unsupported operating system: $(uname -s)"
            exit 1
            ;;
    esac
    
    # Detect architecture
    case "$(uname -m)" in
        x86_64)
            arch="amd64"
            ;;
        arm64|aarch64)
            arch="arm64"
            ;;
        *)
            print_error "Unsupported architecture: $(uname -m)"
            exit 1
            ;;
    esac
    
    echo "${os}-${arch}"
}

# Function to check if command exists
command_exists() {
    command -v "$1" >/dev/null 2>&1
}

# Function to check dependencies
check_dependencies() {
    print_info "Checking dependencies..."
    
    if ! command_exists curl; then
        print_error "curl is required but not installed."
        print_error "Please install curl and try again."
        exit 1
    fi
    
    if ! command_exists tar; then
        print_error "tar is required but not installed."
        exit 1
    fi
    
    print_status "Dependencies OK"
}

# Function to download and install
install_nordkraft() {
    local platform=$(detect_platform)
    local download_url="${BASE_URL}/nordkraft-${platform}.tar.gz"
    local temp_dir=$(mktemp -d)
    local temp_file="${temp_dir}/nordkraft.tar.gz"
    
    print_info "Detected platform: ${platform}"
    print_info "Downloading from: ${download_url}"
    
    # Download the binary
    if ! curl -fsSL "${download_url}" -o "${temp_file}"; then
        print_error "Failed to download nordkraft binary"
        print_error "URL: ${download_url}"
        exit 1
    fi
    
    print_status "Downloaded nordkraft binary"
    
    # Extract the binary
    if ! tar -xzf "${temp_file}" -C "${temp_dir}"; then
        print_error "Failed to extract nordkraft binary"
        exit 1
    fi
    
    print_status "Extracted binary"
    
    # Check if we have write permission to install directory
    if [ ! -w "$(dirname "${INSTALL_DIR}")" ]; then
        print_warning "Need sudo permission to install to ${INSTALL_DIR}"
        
        # Install with sudo
        if ! sudo mv "${temp_dir}/${BINARY_NAME}" "${INSTALL_DIR}/${BINARY_NAME}"; then
            print_error "Failed to install nordkraft to ${INSTALL_DIR}"
            exit 1
        fi
        
        # Make it executable
        if ! sudo chmod +x "${INSTALL_DIR}/${BINARY_NAME}"; then
            print_error "Failed to make nordkraft executable"
            exit 1
        fi
    else
        # Install without sudo
        if ! mv "${temp_dir}/${BINARY_NAME}" "${INSTALL_DIR}/${BINARY_NAME}"; then
            print_error "Failed to install nordkraft to ${INSTALL_DIR}"
            exit 1
        fi
        
        # Make it executable
        if ! chmod +x "${INSTALL_DIR}/${BINARY_NAME}"; then
            print_error "Failed to make nordkraft executable"
            exit 1
        fi
    fi
    
    # Cleanup
    rm -rf "${temp_dir}"
    
    print_status "Installed nordkraft to ${INSTALL_DIR}/${BINARY_NAME}"
}

# Function to verify installation
verify_installation() {
    if command_exists nordkraft; then
        local version=$(nordkraft --version 2>/dev/null || echo "unknown")
        print_status "Installation verified (${version})"
        return 0
    else
        print_error "Installation verification failed"
        print_error "nordkraft command not found in PATH"
        return 1
    fi
}

# Function to show next steps
show_next_steps() {
    echo ""
    echo -e "${GREEN}🎉 Installation Complete!${NC}"
    echo ""
    echo -e "${CYAN}Next steps:${NC}"
    echo "1. Ensure you have WireGuard VPN connection configured"
    echo "2. Test your connection:"
    echo -e "   ${YELLOW}nordkraft auth login${NC}"
    echo ""
    echo -e "${CYAN}Quick commands:${NC}"
    echo -e "   ${YELLOW}nordkraft help${NC}                    # Show all commands"
    echo -e "   ${YELLOW}nordkraft auth status${NC}             # Check connection"
    echo -e "   ${YELLOW}nordkraft container list${NC}          # List containers"
    echo ""
    echo -e "${CYAN}Need help?${NC}"
    echo "• Documentation: https://docs.nordkraft.io"
    echo "• WireGuard setup: https://docs.nordkraft.io/wireguard"
    echo "• Issues: https://github.com/ft-karlsson/nordkraft-io/issues"
    echo ""
}

# Main installation flow
main() {
    print_info "Starting Nordkraft CLI installation..."
    
    # Check if already installed
    if command_exists nordkraft; then
        local current_version=$(nordkraft --version 2>/dev/null || echo "unknown")
        print_warning "Nordkraft is already installed (${current_version})"
        read -p "Do you want to reinstall? [y/N]: " -n 1 -r
        echo
        if [[ ! $REPLY =~ ^[Yy]$ ]]; then
            print_info "Installation cancelled"
            exit 0
        fi
    fi
    
    check_dependencies
    install_nordkraft
    
    if verify_installation; then
        show_next_steps
    else
        print_error "Installation failed verification"
        exit 1
    fi
}

# Handle Ctrl+C
trap 'echo -e "\n${RED}Installation cancelled${NC}"; exit 1' INT

# Run main function
main "$@"
