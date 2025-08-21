# 🛠️ My Dotfiles

A personal collection of configuration files to set up and customize my linux environment.
These dotfiles help streamline workflows, keep settings consistent across machines, and make it easy to get up and running quickly.

## 📂 Structure

```
dotfiles/
├── bash/                  # Bash shell configuration files
├── starship/.config/      # Starship prompt configuration
├── sddm/...
```

## 🚀 Features

- **Bash Configurations** – Aliases, functions, and environment variables for a productive shell experience.
- **Starship Prompt** – A fast, customizable, and minimal prompt for any shell.
- **Portable Setup** – Easily clone and apply these settings to new systems.

## 📦 Usage

1. **Clone the repository**
   ```bash
   git clone https://github.com/mmj2023/dotfiles.git ~/dotfiles
   ```

2. **Navigate to the directory**
   ```bash
   cd ~/dotfiles
   ```

3. **Symlink the configuration files** (example for bash and starship) or use gnu stow which is a symlink manager for which my dotfiles have structured.
   ```bash
   ln -s ~/dotfiles/bash/.bashrc ~/.bashrc
   ln -s ~/dotfiles/starship/.config/starship.toml ~/.config/starship.toml
   # or
   # stow (whatever-you-want-to-symlink_(only the intial directory name in dotfiles/))/
   # like
   stow bash
   stow starship/
   ```
- there is a sddm config for which you need to use it's makefile to install it cause it will put stuff in the root directory.

## ⚙️ Requirements

- **Bash** (latest stable version recommended)
- **[Starship Prompt](https://starship.rs/)** installed and available in your shell
- **[ Blesh ](https://github.com/akinomyoga/ble.sh)** needed for for the starship prompt
- a whole bunch of other projects or applications which are optional and can be installed when you want to install them and then you can just symlink their config files. even my .bashrc and starship prompt are optional.

## 📜 License

This project is licensed under the [MIT License](LICENSE).
