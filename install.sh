#!/bin/bash

set -e

SCRIPT_NAME="mvp"
INSTALL_DIR="/usr/local/bin"
REPO_URL="https://raw.githubusercontent.com/D4rkL4s3r/mvp/main/mvp"

print_success() {
    echo -e "\033[0;32m✓ $1\033[0m"
}

print_error() {
    echo -e "\033[0;31m✗ $1\033[0m"
}

print_info() {
    echo -e "\033[0;34mℹ $1\033[0m"
}

check_dependencies() {
    print_info "Checking dependencies..."
    
    local missing_deps=()
    
    if ! command -v rsync &> /dev/null; then
        missing_deps+=("rsync")
    fi
    
    if ! command -v df &> /dev/null; then
        missing_deps+=("coreutils")
    fi
    
    if [ ${#missing_deps[@]} -gt 0 ]; then
        print_error "Missing dependencies: ${missing_deps[*]}"
        echo ""
        echo "Install them with:"
        echo "  Debian/Ubuntu: sudo apt install ${missing_deps[*]}"
        echo "  CentOS/RHEL:   sudo yum install ${missing_deps[*]}"
        echo "  Arch:          sudo pacman -S ${missing_deps[*]}"
        exit 1
    fi
    
    print_success "All dependencies are installed"
}

install_local() {
    print_info "Installing from local file..."
    
    if [ ! -f "$SCRIPT_NAME" ]; then
        print_error "File '$SCRIPT_NAME' not found in current directory"
        exit 1
    fi
    
    if [ ! -w "$INSTALL_DIR" ]; then
        print_info "Installing to $INSTALL_DIR (requires sudo)..."
        sudo cp "$SCRIPT_NAME" "$INSTALL_DIR/$SCRIPT_NAME"
        sudo chmod +x "$INSTALL_DIR/$SCRIPT_NAME"
    else
        cp "$SCRIPT_NAME" "$INSTALL_DIR/$SCRIPT_NAME"
        chmod +x "$INSTALL_DIR/$SCRIPT_NAME"
    fi
    
    print_success "Installed to $INSTALL_DIR/$SCRIPT_NAME"
}

install_remote() {
    print_info "Downloading from GitHub..."
    
    if ! command -v curl &> /dev/null && ! command -v wget &> /dev/null; then
        print_error "Neither curl nor wget is installed"
        exit 1
    fi
    
    local temp_file=$(mktemp)
    
    if command -v curl &> /dev/null; then
        curl -fsSL "$REPO_URL" -o "$temp_file"
    else
        wget -q "$REPO_URL" -O "$temp_file"
    fi
    
    if [ ! -s "$temp_file" ]; then
        print_error "Download failed"
        rm -f "$temp_file"
        exit 1
    fi
    
    if [ ! -w "$INSTALL_DIR" ]; then
        print_info "Installing to $INSTALL_DIR (requires sudo)..."
        sudo mv "$temp_file" "$INSTALL_DIR/$SCRIPT_NAME"
        sudo chmod +x "$INSTALL_DIR/$SCRIPT_NAME"
    else
        mv "$temp_file" "$INSTALL_DIR/$SCRIPT_NAME"
        chmod +x "$INSTALL_DIR/$SCRIPT_NAME"
    fi
    
    print_success "Installed to $INSTALL_DIR/$SCRIPT_NAME"
}

uninstall() {
    print_info "Uninstalling $SCRIPT_NAME..."
    
    if [ ! -f "$INSTALL_DIR/$SCRIPT_NAME" ]; then
        print_error "$SCRIPT_NAME is not installed"
        exit 1
    fi
    
    if [ ! -w "$INSTALL_DIR" ]; then
        sudo rm "$INSTALL_DIR/$SCRIPT_NAME"
    else
        rm "$INSTALL_DIR/$SCRIPT_NAME"
    fi
    
    print_success "$SCRIPT_NAME has been uninstalled"
}

show_help() {
    cat << EOF
mvp Installation Script

Usage: ./install.sh [option]

Options:
    install         Install from local file (default)
    install-remote  Download and install from GitHub
    uninstall       Remove mvp from system
    help            Show this help message

Examples:
    ./install.sh
    ./install.sh install-remote
    ./install.sh uninstall

EOF
}

main() {
    echo "================================"
    echo "  mvp Installation Script"
    echo "================================"
    echo ""
    
    check_dependencies
    echo ""
    
    case "${1:-install}" in
        install)
            install_local
            ;;
        install-remote)
            install_remote
            ;;
        uninstall)
            uninstall
            ;;
        help|--help|-h)
            show_help
            exit 0
            ;;
        *)
            print_error "Unknown option: $1"
            show_help
            exit 1
            ;;
    esac
    
    echo ""
    if [ "$1" != "uninstall" ]; then
        print_success "Installation complete!"
        echo ""
        echo "Try it out:"
        echo "  mvp --help"
        echo "  mvp -p file.txt /destination/"
    fi
}

main "$@"
