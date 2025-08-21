#!/bin/bash

SCRIPT_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )
. "$SCRIPT_DIR/utils.sh"
read -r os _arch _arch_alt _flavour _release < <(os_info)

## Fonts name map, for nerd fonts
## Key is the name of the font folder in nerd-fonts repo
## Find values by guessing, or https://gist.github.com/davidteren/898f2dcccd42d9f8680ec69a3a5d350e
fonts=(
  # BitstreamVeraSansMono
  # CodeNewRoman
  # DroidSansMono
  # Go-Mono
  # Hack
  # Hasklig
  # Hermit
  # Meslo
  # Noto
  # Overpass
  # ProggyClean
  # RobotoMono
  # SourceCodePro
  # SpaceMono
  # Gohu
  "JetBrainsMono=jetbrains-mono"
  # "FiraCode=fira-code"
  # "FiraMono=fira-mono"
  # "GeistMono=geist-mono"
  # "Hasklig=hasklug"
  # "Lilex=lilex"
  # "Ubuntu=ubuntu"
  # "UbuntuMono=ubuntu-mono"
  # "UbuntuSans=ubuntu-sans"
)

linux_install_fonts(){
  version='3.4.0'
  fonts_dir="$HOME/.local/share/fonts"
  if [[ ! -d "$fonts_dir" ]]; then
      mkdir -p "$fonts_dir"
  fi
  for font_entry in "${fonts[@]}"; do
    font_name=$(echo "$font_entry" | awk -F'=' '{print $1}')
    zip_file="${font_name}.zip"
    download_url="https://github.com/ryanoasis/nerd-fonts/releases/download/v${version}/${zip_file}"
    echo "Downloading $download_url"
    wget "$download_url"
    unzip "$zip_file" "*.ttf" -d "$fonts_dir"
    rm "$zip_file"
  done
  find "$fonts_dir" -name '*Windows Compatible*' -delete
  find "$fonts_dir" -name '*NLNerdFont*' -delete
  find "$fonts_dir" -name '*NerdFontPropo*' -delete
  find "$fonts_dir" -name '*NerdFontMono*' -delete
  fc-cache -fv
}

linux_uninstall_fonts(){
  for font_entry in "${fonts[@]}"; do
    font_name=$(echo "$font_entry" | awk -F'=' '{print $1}')
    find "$fonts_dir" -name "'*${font_name}*'" -delete
  done
  fc-cache -fv
}

macos_install_fonts(){
  for font_entry in "${fonts[@]}"; do
    font_pkg_name=$(echo "$font_entry" | awk -F'=' '{print $2}')
    brew install --cask "font-${font_pkg_name}-nerd-font"
  done
}

macos_uninstall_fonts(){
  for font_entry in "${fonts[@]}"; do
    font_pkg_name=$(echo "$font_entry" | awk -F'=' '{print $2}')
    brew uninstall --cask "font-${font_pkg_name}-nerd-font"
  done
}

install(){
  case $os in
    linux) linux_install_fonts ;;
    darwin) macos_install_fonts ;;
  esac
}

uninstall(){
  case $os in
    linux) linux_uninstall_fonts ;;
    darwin) macos_uninstall_fonts ;;
  esac
}

case $1 in
  "build"|"install")
    install
    ;;
  "remove"|"uninstall")
    uninstall
    ;;
  *)
    printf "Unknown command: %s\n" "$1"
    echo "I can only install or uninstall fonts."
    ;;
esac
