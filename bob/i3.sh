#!/bin/bash
SCRIPT_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )
. "$SCRIPT_DIR/utils.sh"
read -r os _arch _arch_alt flavour _release < <(os_info)
read -r apt install uninstall update autoremove < <(get_apt)

if [[ $os != "linux" ]]; then
  echo "ERROR: This script is for Linux only."
  exit 1
fi

if [[ $flavour == "ubuntu" ]]; then
  echo "ERROR: Use Regolith instead."
  exit 1
fi

if [[ $XDG_SESSION_TYPE != "x11" ]]; then
  echo "ERROR: Use i3 only if system is x11. For Wayland, use Sway."
  exit 1
fi

install(){
  sudo "$apt" "$install" i3 i3blocks i3lock i3status
  git clone https://github.com/vivien/i3blocks-contrib ~/.config/i3blocks
  cp "$SCRIPT_DIR/../i3/i3blocks"  ~/.config/i3blocks/config
}

uninstall(){
  sudo "$apt" "$uninstall" i3 i3blocks i3lock i3status
  sudo "$apt" "$autoremove"
  rm -rf ~/.config/i3blocks
}

case $1 in
  "build"|"install")
    install
    ;;
  "remove"|"uninstall")
    uninstall
    ;;
  *)
    printf "Unknown command: %s\n" "$@"
    echo "I can only install or uninstall i3."
    ;;
esac
