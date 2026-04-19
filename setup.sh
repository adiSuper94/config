#!/bin/env bash

TAT=false

DOTFILES="$HOME"/dev/config
SCRIPT_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )
. "$SCRIPT_DIR/bob/utils.sh"
read -r os _arch _arch_alt flavour _release < <(os_info)
read -r apt install _uninstall _update _autoremove < <(get_apt)

install_homebrew() {
  if ! command -v brew &> /dev/null; then
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
    grep -q "brew shellenv" "$HOME/.zshenv" || (
      # shellcheck disable=SC2016
      echo "Did not find brew shellenv in .zshenv, adding it" &&
      echo 'eval "$(/opt/homebrew/bin/brew shellenv)"' >> "$HOME/.zshenv"
      eval "$(/opt/homebrew/bin/brew shellenv)"
  )
  else
    echo "Homebrew already installed"
  fi
}

## check if default shell is zsh/fish
ensure_sh() {
  ISHELL=$1
  if [[ $SHELL != *"$ISHELL"* ]]; then
    printf "Current shell is set to %s\n" "$SHELL"
    printf "This script needs to run with %s as default shell.\n" "$ISHELL"
    if ask "Do you want to change default shell to $ISHELL"; then
      if ! command -v "$ISHELL" &> /dev/null; then
          if ask "Do you want to install $ISHELL"; then
            sudo "$apt" "$install" "$ISHELL"
            printf "Tried installing %s." "$ISHELL"
          fi
      fi
      if ! command -v "$ISHELL" &> /dev/null; then
        printf "Can't find %s in PATH. Please install %s and run the script again.\nExiting...\n" "$ISHELL" "$ISHELL"
        exit 1
      fi
      chsh -s "$(which "$ISHELL")"
      printf "I have tried to set the default shell to %s.\n" "$ISHELL"
      printf "You might need to restart the terminal, or even your machine for this to take effect.\n"
      exit 1
    else
      printf "Please change default shell to %s and run the script again.\n" "$ISHELL"
      exit 1
    fi
  fi
  return 0
}

configure_zsh() {
  mkdir -p "$HOME"/.zsh/zfunc
  git clone https://github.com/zsh-users/zsh-autosuggestions ~/.zsh/zsh-autosuggestions
  git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ~/.zsh/zsh-syntax-highlighting
  git clone https://github.com/zsh-users/zsh-completions.git ~/.zsh/zsh-completions
  git clone https://github.com/olets/zsh-abbr ~/.zsh/zsh-abbr --recurse-submodules --single-branch --branch v6 --depth 1
  git clone https://github.com/Aloxaf/fzf-tab ~/.zsh/fzf-tab
  rm -rf ~/powerlevel10k
  git clone --depth=1 https://github.com/romkatv/powerlevel10k.git ~/powerlevel10k

  if [[ $TAT = true ]]; then
    # add this to first line of .zshrc
    printf "# Ensure that sourcing tat is the first line in .zshrc\n . %s/.tat/tat.sh\n" "$HOME" |
      cat - "$HOME/.zshrc" > /tmp/zshrc && mv /tmp/zshrc "$HOME/.zshrc"
  fi
  echo "To recompile zsh-completions run: 'rm -f ~/.zcompdump; compinit'"
}


os_specific_setup(){
  case $os in
    "linux")
      case $flavour in
        "ubuntu")
          curl -fsSL https://apt.fury.io/wez/gpg.key | sudo gpg --yes --dearmor -o /usr/share/keyrings/wezterm-fury.gpg
          echo 'deb [signed-by=/usr/share/keyrings/wezterm-fury.gpg] https://apt.fury.io/wez/ * *' | sudo tee /etc/apt/sources.list.d/wezterm.list
          sudo chmod 644 /usr/share/keyrings/wezterm-fury.gpg
          sudo apt update -y
          sudo apt install -y $(cat "$SCRIPT_DIR"/apt_pkglist.txt)
          ;;
        "fedora")
          sudo dnf update
          sudo dnf copr enable wezfurlong/wezterm-nightly
          sudo dnf install $(cat "$SCRIPT_DIR"/dnf_pkglist.txt)
          ;;
        *)
          printf "No OS specific setup for %s:%s\n" "$os" "$flavour"
          return 1
          ;;
      esac
      sudo -v && wget -nv -O- https://download.calibre-ebook.com/linux-installer.sh | sudo sh /dev/stdin
      curl -f https://zed.dev/install.sh | sh
      ;;
    "darwin")
      printf "Homebrew installation should also trigger Xcode CLI tools installation. Please follow the prompts\n\n"
      install_homebrew
      export HOMEBREW_NO_ENV_HINTS=TRUE
      brew bundle --file="$SCRIPT_DIR"/Brewfile
      curl -Lo ssh-3.7.3.pkg https://github.com/libfuse/sshfs/releases/download/sshfs-3.7.3/sshfs-3.7.3-ccb6821.pkg
      sudo installer -pkg ssh-3.7.3.pkg -target /
      rm -f ssh-3.7.3.pkg
    ;;
    *)
      printf "No OS specific setup for %s\n" "$os"
      return 1
      ;;
  esac
}

sym_link(){
  for pkg_config in nvim alacritty wezterm foot tmux sway i3 aerospace regolith3 rofi waybar git lazygit mise zed; do
    if [[ -d "$HOME"/.config/$pkg_config ]]; then
      if [[ -L "$HOME"/.config/$pkg_config ]]; then
        rm -rf "$HOME"/.config/$pkg_config
      else
        mv "$HOME/.config/$pkg_config" "$HOME/.config/${pkg_config}.bak"
      fi
    fi
    ln -s "$DOTFILES/$pkg_config" "$HOME/.config/$pkg_config"
  done
  ln -s "$DOTFILES/ssh/config" "$HOME/.ssh/config"
  rm -f "$HOME/nutter-tools/bin/irg" 2> /dev/null
  rm -f "$HOME/nutter-tools/bin/hpg" 2> /dev/null
  ln -s "$DOTFILES/kutti-scripts/irg" "$HOME/nutter-tools/bin/"
  ln -s "$DOTFILES/kutti-scripts/hpg" "$HOME/nutter-tools/bin/"
  ln -s "$DOTFILES/lsp" "$HOME/nutter-tools/bin/"
}

setup() {
  ensure_sh "fish"
  os_specific_setup
  echo "Setting up basic tools"
  if [ ! -d "$HOME/nutter-tools" ]; then
    mkdir -p "$HOME"/nutter-tools/bin
  fi
  rm -rf ~/.zsh
  configure_zsh
  printf "\nInstalling brave browser\n\n"
  curl -fsS https://dl.brave.com/install.sh | sh
  curl https://mise.run | sh
  sym_link
  exit 0
}
os_info "true"
setup
