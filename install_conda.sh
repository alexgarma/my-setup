#!/bin/bash

# Check if wget is installed
if ! command -v wget &>/dev/null; then
    echo "Wget not found. Installing..."
    sudo yum install -y wget
fi

# Install Anaconda
echo "Installing Anaconda..."
# Check if Anaconda is already installed
#if ! command -v conda &>/dev/null; then
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
curl -LO https://repo.anaconda.com/archive/$latest_version $HOME/$latest_version
#Bash script to install Anaconda answering yes to all prompts
#sh $HOME/$latest_version -b -p $HOME/anaconda3
#sh $HOME/$latest_version $HOME/anaconda3
#fi