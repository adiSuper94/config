#!/bin/bash

SCRIPT_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )
. "$SCRIPT_DIR/utils.sh"
read -r os _arch _arch_alt flavour release < <(os_info)
distro_codename=""

os_check(){
  case $os in
    "linux")
      case $flavour in
        "ubuntu")
          case $release in
            "22.04")
              distro_codename="jammy"
              ;;
            "24.04")
              distro_codename="noble"
              ;;
            *)
              printf "ERROR: This OS is using $os release %s\n" "$release"
              printf "ERROR: This script support installing Regolith only on Ubuntu 22.04 and 24.04. Aborting.\n"
              exit 1
              ;;
          esac
          ;;
        "debian")
          case $release in
            "12")
              distro_codename="bookworm"
              ;;
            *)
              printf "ERROR: This OS is using $os release %s\n" "$release"
              printf "ERROR: This script support installing Regolith only on Debian 12. Aborting.\n"
              exit 1
              ;;
          esac
          ;;
        *)
          printf "ERROR: This OS is using ubuntu release %s\n" "$release"
          printf "ERROR: Regolith only is meant for Ubuntu/Debian based systems. Aborting.\n"
          exit 1
          ;;
      esac
      ;;
    *)
      printf "ERROR: This OS is using ubuntu release %s\n" "$release"
      printf "ERROR: Regolith only is meant for Linux(Ubuntu/Debian) based systems. Aborting.\n"
      exit 1
      ;;
  esac
}

install(){
  printf "\nInstalling Regolith\n"
  keyring="/usr/share/keyrings/regolith-archive-keyring.gpg"
  apt_source_file="/etc/apt/sources.list.d/regolith.list"
  wget -qO - https://archive.regolith-desktop.com/regolith.key | \
    gpg --dearmor | sudo tee $keyring > /dev/null
  printf "tee-ing the following to /etc/apt/sources.list.d/regolith.list :\n"

  echo deb "[arch=amd64 signed-by=$keyring] \
    https://archive.regolith-desktop.com/$flavour/stable $distro_codename v3.3" | \
  sudo tee $apt_source_file
  sudo apt update
  sudo apt install regolith-desktop regolith-session-flashback regolith-session-sway regolith-look-lascaille regolith-look-gruvbox regolith-look-i3-default

  sudo rm -f "/usr/share/regolith/i3/config.d/60_config_keybindings"
  sudo rm -f "/usr/share/regolith/common/config.d/30_navigation"
  sudo rm -f "/usr/share/regolith/common/config.d/40_workspace-config"

  printf "Deleting \n\tkeyring: %s\n\tapt source file: %s\n" "$keyring" "$apt_source_file"
  sudo rm -f $keyring
  sudo rm -f $apt_source_file

  printf "\n\n\n"
  exit 0
}

uninstall(){
  sudo apt uninstall regolith-desktop regolith-session-flashback regolith-look-lascaille regolith-look-gruvbox regolith-look-i3-default
  sudo apt autoremove
  exit 0
}

ensure_ubuntu

case $1 in
  "build"|"install")
    install
    ;;
  "remove"|"uninstall")
    uninstall
    ;;
  *)
    printf "Unknown command: %s\n" "$@"
    echo "I can only install or uninstall Regolith."
    ;;
esac
