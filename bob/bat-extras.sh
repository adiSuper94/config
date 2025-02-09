#!/bin/bash
SCRIPT_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )
. "$SCRIPT_DIR/utils.sh"
read -r os _arch _arch_alt flavour _release < <(os_info)

if [[ $os != "linux" ]]; then
  echo "ERROR: This script is for Linux only."
  exit 1
fi

install(){
  mkdir -p "$HOME/nutter-tools/"
  git clone https://github.com/eth-p/bat-extras.git "$HOME/nutter-tools/bat-extras"
  cd "$HOME/nutter-tools/bat-extras" || exit 1
  ./build.sh --minify=none
  if [[ -d "$HOME/nutter-tools/bat-extras/bin" ]]; then
    for f in "$HOME/nutter-tools/bat-extras/bin/"*; do
      if [[ -f "$f" ]]; then
        ln -s "$f" "$HOME/nutter-tools/bin/$(basename "$f")"
      fi
    done
  fi
}

uninstall(){
  if [[ -d "$HOME/nutter-tools/bat-extras/bin" ]]; then
    for f in "$HOME/nutter-tools/bat-extras/bin/"*; do
      if [[ -f "$f" ]]; then
        rm "$HOME/nutter-tools/bin/$(basename "$f")"
      fi
    done
  fi
  rm -rf "$HOME/nutter-tools/bat-extras"
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
    echo "I can only install or uninstall bat-extras."
    ;;
esac
