#!/usr/bin/env bash

DOTFILES="$HOME"/dev/config
. "$DOTFILES/bob/utils.sh"
read -r os arch _arch_alt flavour _release < <(os_info)

cmd=""
help(){
  printf "Usage: lsp (command) (lsp-server)\n"
  printf "Commands:\n"
  printf "  install (lsp-server)                  Install specified LSP server(s)\n"
  printf "  uninstall (lsp-server)                Uninstall specified LSP server(s)\n"
  printf "  help, -h, --help                      Show this help message\n"
  printf "Supported LSP servers:\n"
  printf "  clangd, lua, typescript \n"
  printf "  all (installs/uninstalls all supported LSP servers)\n"
}

install_luals(){
  local luals_version="3.15.0"
  case $os in
    "linux")
      if [[ "$arch" != "x86_64" ]]; then
        printf "Unsupported architecture for lua-language-server installation. Please install it manually.\n"
        return 1
      fi
      local url="https://github.com/LuaLS/lua-language-server/releases/download/${luals_version}/lua-language-server-${luals_version}-linux-x64.tar.gz"
    curl -o "$HOME/nutter-tools/luals-${os}-${arch}.tar.gz" -L "$url"
    mkdir -p "$HOME/nutter-tools/luals-${luals_version}"
    tar -xvf "$HOME/nutter-tools/luals-${os}-${arch}.tar.gz" --directory "$HOME"/nutter-tools/luals-${luals_version}
    ln -s "$HOME/nutter-tools/luals-${luals_version}/bin/lua-language-server" "$HOME/nutter-tools/bin"
    rm "$HOME/nutter-tools/luals-${os}-${arch}.tar.gz"
    ;;
  "darwin")
    brew install lua-language-server
    ;;
  *)
    printf "Unsupported OS for lua-language-server installation. Please install it manually.\n"
    return
    ;;
  esac
}

install_js_dap(){
  local version="v1.105.0"
  local file_name="js-dap-${version}.tar.gz"
  curl -Lo "${file_name}" "https://github.com/microsoft/vscode-js-debug/releases/download/${version}/js-debug-dap-${version}.tar.gz"
  mkdir -p "$HOME/nutter-tools"
  tar -xvf "${file_name}" --directory "$HOME/nutter-tools"
  rm "${file_name}"
}

uninstall_luals(){
  case $os in
    "linux")
      rm -rf "$HOME/nutter-tools/luala-3.15.0"
      rm "$HOME/nutter-tools/bin/lua-language-server"
      ;;
    "darwin")
      brew uninstall lua-language-server
      ;;
    *)
      printf "Unsupported OS for lua-language-server uninstallation. Please uninstall it manually.\n"
      return
      ;;
  esac
}

case $1 in
  "install"|"uninstall")
    cmd=$1
    ;;
  "help"|"-h"|"--help")
    help
    exit 0
    ;;
  *)
    printf "Invalid command. Use 'lsp help' for usage information.\n"
    help
    exit 1
    ;;
esac

case $2 in
  "all")
    servers=("clangd" "lua" "typescript")
    ;;
  "clangd"|"c"|"cpp")
    servers=("clangd")
    ;;
  "lua")
    servers=("lua")
    ;;
  "typescript"|"javascript"|"ts"|"js")
    servers=("typescript")
    ;;
  *)
    printf "Invalid or missing server. Use 'lsp help' for usage information.\n"
    help
    exit 1
    ;;
esac

for server in "${servers[@]}"; do
  case $cmd in
    "install")
      printf "Installing %s LSP server...\n" "$server"
      case $server in
        "clangd")
          case $os in
            "linux")
              case $flavour in
                "ubuntu"|"debian")
                  sudo apt install -y clangd
                  ;;
                "fedora")
                  sudo dnf install -y clang-tools-extra
                  ;;
              esac
              ;;
            "macos")
              brew install llvm
              ;;
            *)
              printf "Unsupported OS for clangd installation. Please install it manually.\n"
              ;;
          esac
          ;;
        "lua")
          install_luals
          ;;
        "typescript")
          install_js_dap
          ;;
      esac
      ;;
    "uninstall")
      printf "Uninstalling %s LSP server...\n" "$server"
      case $server in
        "clangd")
          case $os in
            "ubuntu"|"debian")
              sudo apt remove -y clangd
              ;;
            "fedora")
              sudo dnf remove -y clang-tools-extra
              ;;
            "macos")
              brew uninstall llvm
              ;;
            *)
              printf "Unsupported OS for clangd uninstallation. Please uninstall it manually.\n"
              ;;
          esac
          ;;
        "lua")
          uninstall_luals
          ;;
        "typescript")
          rm -rf "$HOME/nutter-tools/js-debug"
          ;;
      esac
      ;;
  esac
done

