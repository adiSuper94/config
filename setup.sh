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

ubuntu_purge_snap(){
  if ! command -v snap &> /dev/null; then
    printf "Yayy! Loooks like snap is not installed\n"
    return 0
  fi
  if ask "Do you want to remove all snap pakages, and disable snap competely ? This might break ubuntu ui"; then
    echo "Removing all Snap packages ..."
  else
    echo "You chose not to remove Snap packages. Exiting ..."
    return 1
  fi
  while true; do
    snap_packages=$(snap list 2> /dev/null| awk 'NR>1 {print $1}')
    if [[ -z "$snap_packages" ]]; then
      echo "All Snap packages have been removed."
      break
    fi
    # Try to remove each package
    for snap_package in $snap_packages; do
      echo "Attempting to remove Snap package: $snap_package"
      sudo snap remove --purge "$snap_package" || echo "Failed to remove $snap_package. Will retry."
    done
  done
  sudo systemctl stop snapd
  sudo systemctl disable snapd
  sudo systemctl mask snapd
  sudo apt purge snapd
  sudo apt-mark hold snapd
  sudo rm -rf ~/snap
  sudo rm -rf /snap
  sudo rm -rf /var/snap
  sudo rm -rf /var/lib/snapd
  echo "Blocking Snap installation ..."
  sudo cat <<EOF | sudo tee /etc/apt/preferences.d/nosnap.pref
Package: snapd
Pin: release a=*
Pin-Priority: -10
EOF
  printf "Congratulations! You have Thanos snapped 🫰 Snap out of existence.\n\n"
}

os_specific_setup(){
  case $os in
    "linux")
      case $flavour in
        "ubuntu")
          ubuntu_purge_snap
          sudo apt update
          sudo apt install build-essential
          sudo apt install coreutils gcc curl wget unzip clang
          sudo apt install tmux htop jq rofi copyq redshift maim
          sudo apt install fd-find ripgrep eza bat kdiff3 variety sshfs pass
          curl -fsSL https://apt.fury.io/wez/gpg.key | sudo gpg --yes --dearmor -o /usr/share/keyrings/wezterm-fury.gpg
          echo 'deb [signed-by=/usr/share/keyrings/wezterm-fury.gpg] https://apt.fury.io/wez/ * *' | sudo tee /etc/apt/sources.list.d/wezterm.list
          sudo apt install wezterm
          sudo chmod 644 /usr/share/keyrings/wezterm-fury.gpg
          sudo mv /usr/bin/fdfind /usr/bin/fd
          sudo mv /usr/bin/batcat /usr/bin/bat
          ;;
        "fedora")
          sudo dnf update
          sudo dnf group install development-tools c-development
          sudo dnf install coreutils gcc curl wget unzip clang
          sudo dnf install tmux htop jq rofi-wayland gammastep copyq maim
          sudo dnf install bat ripgrep fd-find kdiff3 fzf sshfs pass
          sudo dnf install variety yaru-gtk4-theme yaru-icon-theme foot
          sudo dnf copr enable wezfurlong/wezterm-nightly
          sudo dnf install wezterm
          ;;
        *)
          printf "No OS specific setup for %s:%s\n" "$os" "$flavour"
          return 1
          ;;
      esac
      curl -fsSL https://fnm.vercel.app/install | bash -s -- --skip-shell
      curl -fsSL https://deno.land/install.sh | sh
      curl -sSfL https://raw.githubusercontent.com/ajeetdsouza/zoxide/main/install.sh | sh
      sudo -v && wget -nv -O- https://download.calibre-ebook.com/linux-installer.sh | sudo sh /dev/stdin
      curl -LsSf https://astral.sh/uv/install.sh | sh
      ;;
    "darwin")
      printf "Homebrew installation should also trigger Xcode CLI tools installation. Please follow the prompts\n\n"
      install_homebrew
      export HOMEBREW_NO_ENV_HINTS=TRUE
      brew install --quiet tmux unzip htop jq wget bat bat-extras fnm zoxide fd ripgrep eza neovim pass deno
      brew install --cask nikitabobko/tap/aerospace
      brew install --cask kdfiff3
      brew install --cask copyq
      brew install --cask macfuse
      brew install --cask wezterm
      curl -Lo ssh-3.7.3.pkg https://github.com/libfuse/sshfs/releases/download/sshfs-3.7.3/sshfs-3.7.3-ccb6821.pkg
      sudo installer -pkg ssh-3.7.3.pkg -target /
      rm -f ssh-3.7.3.pkg
      curl -LsSf https://astral.sh/uv/install.sh | sh
    ;;
    *)
      printf "No OS specific setup for %s\n" "$os"
      return 1
      ;;
  esac
}

sym_link(){
  for pkg_config in nvim alacritty wezterm foot tmux sway i3 aerospace regolith3 rofi waybar git lazygit; do
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
  sym_link
  printf "Basic setup complete\n. Use Bob to install more packages\n"
  exit 0
}
os_info "true"
setup
