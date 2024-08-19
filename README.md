# Objective 🎯

This repository contains shell script(s) to deploy my custom setup (dotfiles, configfiles , etc) on local machine or cloud instances. The setup is based on Zsh shell with Oh-My-Zsh framework. The script(s) are written in bash. ⚙️

- Works for UNIX based operating systems only (MacOS and multiple Linux distributions). 🐧
- .zshrc is the base file for custom setup, modify it to suit your needs

# Usage 🛠

```bash
cd ~
git clone https://github.com/alexgarma/my-setup.git
cd my-setup
chmod +x init.sh
./init.sh --oh-my-zsh=true
exit # Restart of terminal is required
```

You can also run the script with the following options, by default all options are set to false:

- `--oh-my-zsh=true` to install Oh-My-Zsh framework
- `--tmux=true` to install Tmux terminal multiplexer
- `--fzf=true` to install FZF fuzzy finder
- `--anaconda=true` to install Anaconda Python distribution

Recommended order of installation: Oh-My-Zsh -> Tmux -> FZF -> Anaconda 📦

Recommendation: Run the script in a clean environment (fresh installation of the OS) to avoid conflicts with existing configurations. 🧹

# Further improvements 🚀

- Add support for Windows Subsystem for Linux (WSL)
- Parameterize the Linux distribution to avoid redundancy in the utility scripts
- Add neoVim installation and configuration logic
- Add support to validate the OS version and architecture (64-bit, ARM) since some tools are not supported in all architectures or installations may vary.
- Test the script in different MacOS versions
- Add logic for Arch Linux installation
- Add more options to install other tools and utilities like Docker, Rust, R, Scala, Spark, etc.
- Make the parameters shorter and more intuitive (e.g. --oh-my-zsh -> -z, --tmux -> -t, etc)

# License 📜

This project is licensed under the MIT License - see the [LICENSE.md](LICENSE.md) file for details