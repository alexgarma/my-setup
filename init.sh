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
        elif [[ -x "$(command -v zypper)" ]]; then
            echo "Detected OpenSUSE"
            echo "Package manager: Zypper"
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

# Function to install applications using MacOS package manager
install_with_macos_package_manager() {
    # Recieve the arguments passed to the function
    local package_manager=$1
    local oh_my_zsh=$2
    local fzf=$3
    local anaconda=$4
    local tmux=$5
    local r=$6
    local nvim=$7

    # Execute the script in utils with the arguments
    source utils/macos_package_manager.sh "$package_manager" "$oh_my_zsh" "$fzf" "$anaconda" "$tmux" "$r" "$nvim"
}

# Function to install applications using Linux package managers
install_with_linux_package_manager() {
    # Recieve the arguments passed to the function
    local package_manager=$1
    local oh_my_zsh=$2
    local fzf=$3
    local anaconda=$4
    local tmux=$5
    local r=$6
    local nvim=$7

    # Execute the script in utils with the arguments
    source utils/linux_package_manager.sh "$package_manager" "$oh_my_zsh" "$fzf" "$anaconda" "$tmux" "$r" "$nvim"
}

# Function to install applications using the detected package manager
install_applications() {
    local package_manager=$1
    local oh_my_zsh=$2
    local fzf=$3
    local anaconda=$4
    local tmux=$5
    local r=$6
    local nvim=$7

    echo "The package_manager is:  $package_manager..."

    case $package_manager in
        "Homebrew")
            install_with_macos_package_manager "$package_manager" "$oh_my_zsh" "$fzf" "$anaconda" "$tmux" "$r" "$nvim"
            ;;
        "apt-get")
            install_with_linux_package_manager "$package_manager" "$oh_my_zsh" "$fzf" "$anaconda" "$tmux" "$r" "$nvim"
            ;;
        "DNF")
            install_with_linux_package_manager "$package_manager" "$oh_my_zsh" "$fzf" "$anaconda" "$tmux" "$r" "$nvim"
            ;;
        "YUM")
            install_with_linux_package_manager "$package_manager" "$oh_my_zsh" "$fzf" "$anaconda" "$tmux" "$r" "$nvim"
            ;;
        "Zypper")
            install_with_linux_package_manager "$package_manager" "$oh_my_zsh" "$fzf" "$anaconda" "$tmux" "$r" "$nvim"
            ;;
        "Pacman")
            install_with_linux_package_manager "$package_manager" "$oh_my_zsh" "$fzf" "$anaconda" "$tmux" "$r" "$nvim"
            ;;
        *)
            echo "Unsupported package manager"
            ;;
    esac

}

# TODO: Function to get OS architecture: 32-bit, 64-bit, or ARM
# get_architecture() {
#    local architecture=$(uname -m)
#    if [[ $architecture == "x86_64" ]]; then
#        echo "64-bit"
#    elif [[ $architecture == "arm"* ]]; then
#        echo "ARM"
#    else
#        echo "32-bit"
#    fi
#}

parse_arguments() {
    local oh_my_zsh=false
    local fzf=false
    local anaconda=false
    local tmux=false
    local r=false
    local nvim=false

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
            --r=*)
                r="${arg#*=}"
                ;;
            *)
                echo "Invalid argument: $arg"
                ;;
        esac
    done

    install_applications "$package_manager" "$oh_my_zsh" "$fzf" "$anaconda" "$tmux" "$r" "$nvim"
}

# Assign package manager detector to a variable
package_manager=$(detect_package_manager)

# Trim leading and trailing spaces from the package manager value
package_manager=$(trim "${package_manager##*:}")

# Print the package manager value
echo "--- Package manager: $package_manager ----"
echo $package_manager | tr '[:upper:]' '[:lower:]'

parse_arguments "$@"
