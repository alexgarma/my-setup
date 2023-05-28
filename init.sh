#!/bin/bash

# Detect package manager for Linux or macOS

# Check if running on macOS
if [[ "$(uname)" == "Darwin" ]]; then
    echo "Detected macOS"
    if [[ -x "$(command -v brew)" ]]; then
        echo "Package manager: Homebrew"
    else
        echo "Package manager not found"
    fi
# Check if running on Linux
elif [[ "$(uname)" == "Linux" ]]; then
    # Detect package manager based on known package management tools
    if [[ -x "$(command -v apt-get)" ]]; then
        echo "Detected Debian-based Linux"
        echo "Package manager: apt-get"
    elif [[ -x "$(command -v dnf)" ]]; then
        echo "Detected Fedora-based Linux"
        echo "Package manager: DNF"
    elif [[ -x "$(command -v yum)" ]]; then
        echo "Detected CentOS/RHEL-based Linux"
        echo "Package manager: YUM"
    elif [[ -x "$(command -v pacman)" ]]; then
        echo "Detected Arch Linux"
        echo "Package manager: Pacman"
    else
        echo "Package manager not found"
    fi
else
    echo "Unsupported operating system"
fi
