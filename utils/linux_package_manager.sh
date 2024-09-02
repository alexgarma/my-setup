#!/bin/bash
local package_manager=$1
local oh_my_zsh=$2
local fzf=$3
local anaconda=$4
local tmux=$5
local r=$6
local nvim=$7

# Update dependencies
echo "Installing applications with $package_manager..."
echo "Updating dependencies..."
sudo $package_manager update

# When oh_my_zsh is true
if [ $oh_my_zsh = true ]; then
    # Validate if git is installed
    if ! command -v git &>/dev/null; then
        echo "Git not found. Installing..."
        sudo $package_manager install -y git
    fi

    # Install python3
    if ! command -v python3 &>/dev/null; then
        echo "Python3 not found. Installing..."
        sudo $package_manager install -y python3
    fi

    # Install pip3
    if ! command -v pip3 &>/dev/null; then
        echo "Pip3 not found. Installing..."
        sudo $package_manager install -y python3-pip
    fi

    # Install unzip
    if ! command -v unzip &>/dev/null; then
        echo "Unzip not found. Installing..."
        sudo $package_manager install -y unzip
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
        sudo $package_manager install -y openssh
    fi
    # TODO: Add ssh-agent

    # Utils util-linux-user (is only needed to change default shell in some distros)
    if ! command -v chsh &>/dev/null; then
        echo "Chsh not found. Installing..."
        sudo $package_manager install util-linux-user
    fi

    # Install Zsh if not already present
    if ! command -v zsh &>/dev/null; then
        echo "Zsh not found. Installing..."
        sudo $package_manager install -y zsh
    fi

    # Make Zsh default shell (default user)
    sudo chsh -s $(which zsh) $(whoami)
    #source ~/.zshrc
    echo "The default shell is: $SHELL"

    # Install Oh my zsh if not already present
    if [[ ! -d "$HOME/.oh-my-zsh" ]]; then
        echo "Installing oh-my-zsh..."
        sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
    fi
    
    echo "Oh-my-zsh installed successfully"
    
    # Personalize Oh my zsh by copying the .zshrc file
    echo "Personalizing oh-my-zsh..."
    sh -c "cp ~/my-setup/dotfiles/.zshrc ~/.zshrc"
    echo "Oh-my-zsh personalized successfully"

fi

# When fzf is true
if [ $fzf = true ]; then
    # Install fzf if not already present
    if ! command -v fzf &>/dev/null; then
        echo "Fzf not found. Installing..."
        git clone --depth 1 https://github.com/junegunn/fzf.git ~/.fzf
        sh -c "~/.fzf/install"
    fi

fi

# When anaconda is true
if [ $anaconda = true ]; then
    # Check if wget is installed
    if ! command -v wget &>/dev/null; then
        echo "Wget not found. Installing..."
        sudo $package_manager install -y wget
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
        #Bash script to install Anaconda
        bash $latest_version
        # Remove the downloaded file
        rm $latest_version
    fi
fi

# When tmux is true
if [ $tmux = true ]; then
    # Install tmux if not already present
    if ! command -v tmux &>/dev/null; then
        echo "Tmux not found. Installing..."
        sudo $package_manager install -y libevent
        sudo $package_manager install -y ncurses
        sudo $package_manager install -y perl
        #If libevent or ncurses are not found
        if ! command -v libevent &>/dev/null || ! command -v ncurses &>/dev/null; then
            echo "Libevent or ncurses installation failed. Installing..."
            sudo $package_manager install -y libevent-devel
            sudo $package_manager install -y ncurses-devel
            sudo $package_manager install -y gcc
            sudo $package_manager install -y make
            sudo $package_manager install -y bison
            #sudo yum install -y pkg-config
        fi
        sudo $package_manager install -y autoconf
        sudo $package_manager install -y automake

        sudo git clone https://github.com/tmux/tmux.git /usr/local/tmux
        sudo sh -c "cd /usr/local/tmux && ./autogen.sh && ./configure && sudo make && sudo make install"

        # Check if tmux was installed successfully if not end the script
        if ! command -v tmux &>/dev/null; then
            echo "Tmux installation failed. Exiting..."
            exit 1
        fi

        echo "Tmux installed successfully"

    fi

    echo "Tmux already installed"
    read -p "Do you want to personalize tmux? (y/n): " personalize_tmux

    # Personalize tmux
    if [[ $personalize_tmux = "y" ]]; then
        echo "Personalizing tmux..."
    
        git clone https://github.com/gpakosz/.tmux.git $HOME/oh-my-tmux
        mkdir -p $HOME/.config/tmux
        ln -s "$HOME/oh-my-tmux/.tmux.conf" "$HOME/.config/tmux/tmux.conf"
        cp "$HOME/oh-my-tmux/.tmux.conf.local" "$HOME/.config/tmux/tmux.conf.local"

    fi

fi

# When r is true
if [ $r = true ]; then
    # Install radian in a conda base environment
    if ! command -v radian &>/dev/null; then
        echo "Radian not found. Installing..."
        #Check if conda is installed
        if ! command -v conda &>/dev/null; then
            echo "Conda not found. Install anaconda first. Exiting..."
            exit 1
        fi
        conda install -c conda-forge radian
    fi
    # Install R if not already present
    if ! command -v R &>/dev/null; then
        echo "R not found. Installing..."
        sudo $package_manager install R
    fi

    # Install RStudio
    #if ! command -v rstudio &>/dev/null; then
    #    echo "RStudio not found. Installing..."
    #    sudo $package_manager install -y rstudio
    #fi

    # Modify zshrc to include Radian as the default R interpreter
    read -p "Do you want to make an alias for Radian as R interpreter ? (y/n): " make_alias_radian
    if [[ $make_alias_radian = "y" ]]; then
        echo "Personalizing zshrc..."
        echo "alias r=radian" >> ~/.zshrc
        #echo "alias RStudio=rstudio" >> ~/.zshrc
    fi

    # Install R  packages
    read -p "Do you want to install R languageserver,httpgd packages? (y/n): " install_r_packages
    if [[ $install_r_packages = "y" ]]; then
        echo "Installing R packages..."
        sudo R -e "install.packages('languageserver', repos='https://cran.rstudio.com/')"
        sudo R -e "install.packages('httpgd', repos='https://cran.rstudio.com/')"
        #echo "y" | R -e "install.packages('languageserver', repos='https://cran.rstudio.com/')"
        #echo "y" | R -e "install.packages('httpgd', repos='https://cran.rstudio.com/')"
        #R -e "install.packages('languageserver', repos='http://cran.rstudio.com/', lib='~/R/library')"
    fi
fi

# When nvim is true
if [ $nvim = true ]; then
    # Install prerequisites
    echo "Installing prerequisites for NeoVim..."
    #sudo $package_manager -y install fuse
    sudo $package_manager -y install libfuse2

    # Install NeoVim if not already present
    if ! command -v nvim &>/dev/null; then
        echo "NeoVim not found. Downloading and installing..."
        curl -LO https://github.com/neovim/neovim/releases/latest/download/nvim.appimage
        chmod u+x nvim.appimage
        ./nvim.appimage

        # Check if NeoVim is installed successfully
        if ! command -v nvim &>/dev/null; then
            echo "NeoVim installation failed. Extracting and running the app image..."
            ./nvim.appimage --appimage-extract
            ./squashfs-root/AppRun --version
            # Exposing nvim globally
            sudo mv squashfs-root /
            sudo ln -s /squashfs-root/AppRun /usr/bin/nvim
            #nvim
        fi
        
        # Exposing nvim globally
        mkdir -p /opt/nvim
        mv nvim.appimage /opt/nvim/nvim
        # Add nvim to the PATH
        echo "export PATH=$PATH:/opt/nvim" >> ~/.zshrc

        echo "NeoVim installed successfully"
    fi

    # Ask user if they want to personalize NeoVim
    read -p "Do you want to personalize NeoVim? (y/n): " personalize_nvim

    # Personalize NeoVim
    if [[ $personalize_nvim = "y" ]]; then
        # Install dependencies
        echo "Installing dependencies ..."
        sudo $package_manager install -y xclip
        sudo $package_manager install -y ripgrep # TODO: Check if it was installed successfully
        sudo $package_manager install -y make
        sudo $package_manager install -y unzip
        sudo $package_manager install -y gcc
    fi

    git clone https://github.com/alexgarma/kickstart.nvim.git "${XDG_CONFIG_HOME:-$HOME/.config}"/nvim

    echo "NeoVim personalized successfully, please run nvim to apply changes"

    # Ask user if they want to make NeoVim the default editor
    read -p "Do you want to make NeoVim the default editor? (y/n): " make_nvim_default

    # Make NeoVim the default editor
    if [[ $make_nvim_default = "y" ]]; then
        echo "Making NeoVim the default editor..."
        sudo update-alternatives --install /usr/bin/editor editor /opt/nvim/nvim 100
        sudo update-alternatives --set editor /opt/nvim/nvim
        sudo update-alternatives --install /usr/bin/vi vi /opt/nvim/nvim 100
        sudo update-alternatives --set vi /opt/nvim/nvim
        sudo update-alternatives --set vim /opt/nvim/nvim
    fi

fi