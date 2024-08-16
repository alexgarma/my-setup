#!/bin/bash
local oh_my_zsh=$1
local fzf=$2
local anaconda=$3
local tmux=$4

# Retrun not implemented for package manager
return_not_implemented() {
    echo "This package manager is not implemented yet."
    return 1
}

return_not_implemented