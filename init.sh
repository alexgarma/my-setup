#!/bin/bash

# Function to detect package manager for Linux or macOS
detect_package_manager() {
    # Check if running on macOS
    if [[ "$(uname)" == "Darwin" ]]; then
        echo "Detected macOS"
        if [[ -x "$(command -v brew)" ]]; then
            echo "Package manager: Homebrew"
            return 0
        else
            echo "Package manager not found"
            return 1
        fi
    # Check if running on Linux
    elif [[ "$(uname)" == "Linux" ]]; then
        # Detect package manager based on known package management tools
        if [[ -x "$(command -v apt-get)" ]]; then
            echo "Detected Debian-based Linux"
            echo "Package manager: apt-get"
            return 0
        elif [[ -x "$(command -v dnf)" ]]; then
            echo "Detected Fedora-based Linux"
            echo "Package manager: DNF"
            return 0
        elif [[ -x "$(command -v yum)" ]]; then
            echo "Detected CentOS/RHEL-based Linux"
            echo "Package manager: YUM"
            return 0
        elif [[ -x "$(command -v pacman)" ]]; then
            echo "Detected Arch Linux"
            echo "Package manager: Pacman"
            return 0
        else
            echo "Package manager not found"
            return 1
        fi
    else
        echo "Unsupported operating system"
        return 1
    fi
}

# Function to install applications using Homebrew
install_with_homebrew() {
    echo "Installing applications with Homebrew..."
    brew install app1
    brew install app2
    brew install app3
}

# Function to install applications using apt-get
install_with_apt_get() {
    echo "Installing applications with apt-get..."
    sudo apt-get update
    sudo apt-get install -y app1
    sudo apt-get install -y app2
    sudo apt-get install -y app3
}

# Function to install applications using DNF
install_with_dnf() {
    echo "Installing applications with DNF..."
    sudo dnf update
    echo "Installing python3..."
    sudo dnf install -y python3
}

# Function to install applications using the detected package manager
install_applications() {
    local package_manager=$1

    case $package_manager in
        "Homebrew")
            install_with_homebrew
            ;;
        "apt-get")
            install_with_apt_get
            ;;
        "DNF")
            install_with_dnf
            ;;
        *)
            echo "Package manager not supported for application installation"
            ;;
    esac
}

# Assign package manager detector to a variable
package_manager=$(detect_package_manager)

echo "Package manager: $package_manager"
# Install applications based on the detected package manager
install_applications "$package_manager"
