#!/bin/env bash

DOTFILES="$HOME"/dev/config
SCRIPT_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )
. "$SCRIPT_DIR/bob/utils.sh"
read -r os _arch _arch_alt flavour _release < <(os_info)

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
      curl -f https://zed.dev/install.sh | sh
      ;;
    "darwin")
      printf "Homebrew installation should also trigger Xcode CLI tools installation. Please follow the prompts\n\n"
      install_homebrew
      export HOMEBREW_NO_ENV_HINTS=TRUE
      brew bundle --file="$SCRIPT_DIR"/Brewfile
    ;;
    *)
      printf "No OS specific setup for %s\n" "$os"
      return 1
      ;;
  esac
}

sym_link(){
  for pkg_config in nvim wezterm foot tmux sway aerospace rofi waybar git lazygit zed; do
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
  if [ ! -d "$HOME/nutter-tools" ]; then
    mkdir -p "$HOME"/nutter-tools/bin
  fi
  case $os in
    "darwin")
      if ! command -v brew &> /dev/null; then
        printf "[ERROR]: Homebrew required on macos"
        exit 1
      fi
      ;;
    *)
      if ! command -v nix &> /dev/null; then
        printf "[WARN]: Nix required to install packages"
      fi
      ;;
  esac
  os_specific_setup
  echo "Setting up basic tools"
  printf "\nInstalling brave browser\n\n"
  curl -fsS https://dl.brave.com/install.sh | sh
  curl https://mise.run | sh
  sym_link
  exit 0
}
os_info "true"
setup
