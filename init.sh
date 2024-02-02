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

# Function to trim leading and trailing spaces from a string
trim() {
    local var=$1
    var=$(echo "$var" | sed -e 's/^[[:space:]]*//' -e 's/[[:space:]]*$//')
    echo -n "$var"
}

# Function to install applications using Homebrew
install_with_homebrew() {
    echo "Installing applications with Homebrew..."
    # brew install app1
    # brew install app2
    # brew install app3
}

# Function to install applications using apt-get
install_with_apt_get() {
    echo "Installing applications with apt-get..."
    # sudo apt-get update
    # sudo apt-get install -y app1
    # sudo apt-get install -y app2
    # sudo apt-get install -y app3
}

# Function to install applications using DNF
install_with_dnf() {
    
    # Update dependencies
    echo "Installing applications with DNF..."
    echo "Updating dependencies..."
    sudo dnf update

    # Install python3
    if ! command -v python3 &>/dev/null; then
        echo "Python3 not found. Installing..."
        sudo dnf install -y python3
    fi

    # Install pip3
    if ! command -v pip3 &>/dev/null; then
        echo "Pip3 not found. Installing..."
        sudo dnf install -y python3-pip
    fi

    # Install SSH
    if ! command -v ssh &>/dev/null; then
        echo "SSH not found. Installing..."
        sudo dnf install -y openssh
    fi
    # TODO: Add commands to activate ssh

    # Validate if git is installed
    if ! command -v git &>/dev/null; then
        echo "Git not found. Installing..."
        sudo dnf install -y git
    fi

    # Utils util-linux-user (only needed to change shell in Fedora an other distros)
    # sudo dnf install util-linux-user

    # Zsh
    echo "Installing zsh..."
    sudo dnf install zsh
    # Make defaul shell (default user)
    sudo chsh -s $(which zsh) $(whoami) 

    echo "The default shell is: $SHELL"

    # Oh my zsh
    echo "Installing oh-my-zsh..."
    sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"

    # Neovim

    # Download and install NeoVim if not already present
    #if ! command -v nvim &>/dev/null; then
    #    echo "NeoVim not found. Downloading and installing..."
    #    curl -LO https://github.com/neovim/neovim/releases/latest/download/nvim.appimage
    #    chmod u+x nvim.appimage
    #    ./nvim.appimage
    #fi
    #
    ## Check if NeoVim is installed successfully
    #if ! command -v nvim &>/dev/null; then
    #    echo "NeoVim installation failed. Extracting and running the app image..."
    #    ./nvim.appimage --appimage-extract
    #    ./squashfs-root/AppRun --version
    #fi
    ## TODO: Make neovim the default editor
    
}

# Function to install applications using the detected package manager
install_applications() {
    local package_manager=$1

    echo "The package manager is: $package_manager"

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

# Trim leading and trailing spaces from the package manager value
package_manager=$(trim "${package_manager##*:}")

# Install applications based on the detected package manager
install_applications "$package_manager"