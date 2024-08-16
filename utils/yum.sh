#!/bin/bash

# Update dependencies
echo "Installing applications with YUM..."
echo "Updating dependencies..."
sudo yum update

# Validate if git is installed
if ! command -v git &>/dev/null; then
    echo "Git not found. Installing..."
    sudo yum install -y git
fi

# Install python3
if ! command -v python3 &>/dev/null; then
    echo "Python3 not found. Installing..."
    sudo yum install -y python3
fi

# Install pip3
if ! command -v pip3 &>/dev/null; then
    echo "Pip3 not found. Installing..."
    sudo yum install -y python3-pip
fi

# Install awscli
if ! command -v aws &>/dev/null; then
    echo "AWS CLI not found. Installing..."
    curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"
    unzip awscliv2.zip
    sudo ./aws/install
fi

# Install SSH
if ! command -v ssh &>/dev/null; then
    echo "SSH not found. Installing..."
    sudo yum install -y openssh
fi

# TODO: Add ssh-agent

# Utils util-linux-user (is only needed to change default shell in some distros)
if ! command -v chsh &>/dev/null; then
    echo "Chsh not found. Installing..."
    sudo yum install util-linux-user
fi

# Install Zsh if not already present
if ! command -v zsh &>/dev/null; then
    echo "Zsh not found. Installing..."
    sudo yum install -y zsh
fi

# Make Zsh defaul shell (default user)
sudo chsh -s $(which zsh) $(whoami)
# source ~/.zshrc

echo "The default shell is: $SHELL"

# Install Oh my zsh if not already present
if [[ ! -d "$HOME/.oh-my-zsh" ]]; then
    echo "Installing oh-my-zsh..."
    sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
fi

# Install fzf if not already present
if ! command -v fzf &>/dev/null; then
    echo "Fzf not found. Installing..."
    git clone --depth 1 https://github.com/junegunn/fzf.git ~/.fzf
    source ~/.fzf/install
fi

# Personalize Oh my zsh
echo "Personalizing oh-my-zsh..."
cp dotfiles/.zshrc ~/.zshrc
#source ~/.zshrc

# Check if wget is installed
if ! command -v wget &>/dev/null; then
    echo "Wget not found. Installing..."
    sudo yum install -y wget
fi

# Install Anaconda

# Check if Anaconda is already installed
if ! command -v conda &>/dev/null; then
    echo "Anaconda not found. Downloading and installing..."
    # Make a request to the Anaconda website
    wget https://repo.anaconda.com/archive/
    # Extract the latest version of Anaconda ignoring the rest of the HTML and cut the first result
    latest_version=$(grep -o 'Anaconda3-.*-Linux-x86_64.sh' index.html | head -n 1)
    # Split the string by the delimiter `>` and get the second element
    latest_version=$(echo $latest_version | cut -d '>' -f 2)
    # Remove the index.html file
    rm index.html
    # Download the latest version of Anaconda
    echo "Downloading Anaconda version: $latest_version"
    curl -LO https://repo.anaconda.com/archive/$latest_version
    #Bash script to install Anaconda answering yes to all prompts
    bash $latest_version -b -p $HOME/anaconda3
    # Remove the downloaded file
    rm $latest_version
fi

# Install tmux if not already present
if ! command -v tmux &>/dev/null; then
    echo "Tmux not found. Installing..."
    sudo yum install -y libevent
    sudo yum install -y ncurses
    #If libevent or ncurses are not found
    if ! command -v libevent &>/dev/null || ! command -v ncurses &>/dev/null; then
        echo "Libevent or ncurses installation failed. Installing..."
        sudo yum install -y libevent-devel
        sudo yum install -y ncurses-devel
        sudo yum install -y gcc
        sudo yum install -y make
        sudo yum install -y bison
        #sudo yum install -y pkg-config
    fi
    sudo yum install -y autoconf
    sudo yum install -y automake
    
    sudo git clone https://github.com/tmux/tmux.git /usr/local/
    #sudo sh -c "cd /usr/local/tmux && ./autogen.sh && ./configure && make && make install"
    sudo sh /usr/local/tmux/autogen.sh
    sudo sh /usr/local/tmux/configure
    sudo make && sudo make install

    # Check if tmux was installed successfully if not end the script
    if ! command -v tmux &>/dev/null; then
        echo "Tmux installation failed. Exiting..."
        exit 1
    fi

    echo "Tmux installed successfully"
    
    echo "Personalizing tmux..."
    cd ~
    git clone https://github.com/gpakosz/.tmux.git
    ln -s -f .tmux/.tmux.conf
    cp .tmux/.tmux.conf.local .
fi

#TODO: Install neovim
## Install NeoVim if not already present
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
# TODO: Make neovim the default editor