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

- `--oh-my-zsh=true` to install Zsh and Oh-My-Zsh framework
- `--tmux=true` to install Tmux terminal multiplexer
- `--fzf=true` to install FZF fuzzy finder
- `--anaconda=true` to install Anaconda Python distribution

Recommended order of installation: Oh-My-Zsh -> Tmux -> FZF -> Anaconda 📦

Recommendation: Run the script in a clean environment (fresh installation of the OS) to avoid conflicts with existing configurations. 🧹

# Further improvements 🚀

- [ ] Add support for Windows Subsystem for Linux (WSL)
- [X] Parameterize the Linux distribution to avoid redundancy in the utility scripts
- [X] Add neoVim installation and configuration logic
- [ ] Add support to validate the OS version and architecture (64-bit, ARM) since some tools are not supported in all architectures or installations may vary (eg. Anaconda)
- [ ] Test the script in different MacOS versions
- [ ] Add logic for Arch Linux installation
- [ ] Add more options to install other tools and utilities
  - [X] Add support for R installation and configuration in Linux
- [ ] Make the parameters shorter and more intuitive (e.g. --oh-my-zsh -> -z, --tmux -> -t, etc)
- [ ] Limit who can contribute to the repository to avoid malicious code, make it private

# Author 🧑‍💻

Alex Garduno - [LinkedIn](https://www.linkedin.com/in/alexgarduno/) - [GitHub](https://github.com/alexgarma)

# Acknowledgements 🙏

Some of the resources used to build this setup, thanks to the authors and contributors of those projects:

- [Oh-My-Zsh](https://ohmyz.sh/)
- [Tmux](https://github.com/tmux/tmux)
- [gpakoz tmux configuration](https://github.com/gpakosz/.tmux.git)
- [FZF](https://github.com/junegunn/fzf)
- [NeoVim](https://neovim.io/)
- [Kickstart nvim](https://github.com/nvim-lua/kickstart.nvim)

# Contributing 🤝

Pull requests are welcome. For major changes, please open an issue first to discuss what you would like to change. 📝

# License 📜

This project is licensed under the MIT License - see the [LICENSE.md](LICENSE.md) file for details