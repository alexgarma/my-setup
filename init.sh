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
        echo "Unsupported operating system or distribution"
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
    # Recieve the arguments passed to the function
    local oh_my_zsh=$1
    local fzf=$2
    local anaconda=$3
    local tmux=$4

    # Execute the script in utils with the arguments
    source utils/homebrew.sh "$oh_my_zsh" "$fzf" "$anaconda" "$tmux"
}

# Function to install applications using apt-get
install_with_apt_get() {
    # Recieve the arguments passed to the function
    local oh_my_zsh=$1
    local fzf=$2
    local anaconda=$3
    local tmux=$4

    # Execute the script in utils with the arguments
    source utils/apt-get.sh "$oh_my_zsh" "$fzf" "$anaconda" "$tmux"
}

# Function to install applications using DNF
install_with_dnf() {
    # Recieve the arguments passed to the function
    local oh_my_zsh=$1
    local fzf=$2
    local anaconda=$3
    local tmux=$4

    # Execute the script in utils with the arguments
    source utils/dnf.sh "$oh_my_zsh" "$fzf" "$anaconda" "$tmux"
}
    
# Function to install applications using YUM
install_with_yum() {
    # Recieve the arguments passed to the function
    local oh_my_zsh=$1
    local fzf=$2
    local anaconda=$3
    local tmux=$4

    # Execute the script in utils with the arguments
    source utils/yum.sh "$oh_my_zsh" "$fzf" "$anaconda" "$tmux"
}


# Function to install applications using the detected package manager
install_applications() {
    local package_manager=$1
    local oh_my_zsh=$2
    local fzf=$3
    local anaconda=$4
    local tmux=$5

    echo "The package_manager is:  $package_manager..."

    case $package_manager in
        "Homebrew")
            install_with_homebrew "$oh_my_zsh" "$fzf" "$anaconda" "$tmux"
            ;;
        "apt-get")
            install_with_apt_get "$oh_my_zsh" "$fzf" "$anaconda" "$tmux"
            ;;
        "DNF")
            install_with_dnf "$oh_my_zsh" "$fzf" "$anaconda" "$tmux"
            ;;
        "YUM")
            install_with_yum "$oh_my_zsh" "$fzf" "$anaconda" "$tmux"
            ;;
        *)
            echo "Unsupported package manager"
            ;;
    esac

}

parse_arguments() {
    local oh_my_zsh=false
    local fzf=false
    local anaconda=false
    local tmux=false

    for arg in "$@"; do
        case $arg in
            --oh-my-zsh=*)
                oh_my_zsh="${arg#*=}"
                ;;
            --fzf=*)
                fzf="${arg#*=}"
                ;;
            --anaconda=*)
                anaconda="${arg#*=}"
                ;;
            --tmux=*)
                tmux="${arg#*=}"
                ;;
            *)
                echo "Invalid argument: $arg"
                ;;
        esac
    done

    install_applications "$package_manager" "$oh_my_zsh" "$fzf" "$anaconda" "$tmux"
}

# Assign package manager detector to a variable
package_manager=$(detect_package_manager)

# Trim leading and trailing spaces from the package manager value
package_manager=$(trim "${package_manager##*:}")

parse_arguments "$@"