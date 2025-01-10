#!/bin/bash

ask(){
  if [[ $YES = true ]]; then
    return 0
  fi
  read -r -p "$1 [Y/n/q] " response
  if [[ $response =~ ^[nN]$ ]]; then
    return 1
  elif [[ $response =~ ^[yY]$ ]] || [[ -z $response ]]; then
    return 0
  elif [[ $response =~ ^[qQ]$ ]]; then
    printf "Exiting...\n"
    exit 0
  else
    printf "Invalid response. Please enter y or n\n"
    ask "$1"
  fi
}

get_apt(){
  local os arch arch_alt flavour release
  local apt install uninstall update autoremove
  read -r os arch arch_alt flavour release < <(os_info false)
  install="install"
  uninstall="remove"
  update="update"
  apt=""
  autoremove="autoremove"
  case $os in
    linux)
    case $flavour in
      "ubuntu"|"debian")
      apt="apt"
        ;;
      "fedora")
      apt="dnf"
        ;;
      *)
      echo "Unknown flavour of Linux, aborting..." >&2
      echo "Error"
      exit 1
        ;;
    esac
      ;;
    darwin)
      apt="brew"
      install="install --quiet"
      ;;
    *)
    echo "Unknown OS, aborting..." >&2
    echo "Error"
    exit 1
      ;;
  esac
  echo "$apt $install $uninstall $update $autoremove"
  return 0
}

os_info(){
  if [[ $1 == "true" ]]; then
    human_print=true
  else
    human_print=false
  fi
  uname=$(uname -sm)
  local os arch arch_alt flavour release
  read -r os arch <<< "$uname"
  case $os in
  Darwin)   os=darwin
    flavour=macos
    arch_alt=arch
    ;;
  Linux) os=linux
    if [ -f /etc/os-release ]; then
      # not tested
      flavour=$(awk -F= '$1 == "ID" { print $2; exit }' /etc/os-release)
      flavour=${flavour#\"}
      flavour=${flavour%\"}
      release=$(awk -F= '$1 == "VERSION_ID" { print $2; exit }' /etc/os-release)
      release=${release#\"}
      release=${release%\"}
    fi
    if [[ $arch = "x86_64" ]]; then
      arch_alt="amd64"
    fi
  ;;
  esac

  if [[ $os != "linux" && $os != "darwin" ]]; then
    printf '%s\n' "Unknown OS, aborting..." >&2
    exit 1
  fi
  if [[ $flavour != "ubuntu" && $flavour != "debian" && $flavour != "macos" && $flavour != "fedora" ]]; then
    printf '%s\n' "Unknown flavour of Mac/Linux, aborting..." >&2
    exit 1
  fi

  if [[ $human_print = true ]]; then
    printf "\n------ OS Info ------\n"
    echo "os: $os"
    echo "arch: $arch"
    echo "flavour: $flavour"
    echo "arch_alt: $arch_alt"
    echo "release: $release"
    echo "---------------------"
  else
    echo "$os $arch $arch_alt $flavour $release"
  fi
  return 0
}
