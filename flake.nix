{
  description = "Linux (and MacOS?) home configuration";

  inputs = {
    utils.url = "github:numtide/flake-utils";
    nixpkgs.url = "github:nixos/nixpkgs/nixos-25.11";
    nixpkgs-unstable.url = "github:NixOS/nixpkgs/nixos-unstable";
  };
  outputs = { self, utils, nixpkgs, nixpkgs-unstable }: utils.lib.eachDefaultSystem (system:
    let
      pkgs = nixpkgs.legacyPackages.${system};
      unstable_pkgs = nixpkgs-unstable.legacyPackages.${system};
      common_pkgs = [
        pkgs.unzip
        pkgs.wget
        pkgs.bat
        pkgs.bat-extras.core
        pkgs.btop
        pkgs.eza
        pkgs.fd
        pkgs.ripgrep
        pkgs.fzf
        pkgs.jq
        pkgs.zoxide
        pkgs.lazygit
        pkgs.tree-sitter
        pkgs.opencode
        pkgs.tmux
        pkgs.pgcli
        pkgs.nodejs_24
        pkgs.pnpm
        pkgs.vtsls
        pkgs.oxlint
        pkgs.tailwindcss-language-server
        pkgs.vscode-langservers-extracted
        pkgs.yaml-language-server
        pkgs.lua-language-server
        pkgs.stylua
        pkgs.taplo
        pkgs.uv
        pkgs.ty
        pkgs.ruff
        pkgs.go
        pkgs.gopls
        pkgs.pass-nodmenu
        pkgs.bash-language-server
        unstable_pkgs.devenv
        unstable_pkgs.neovim
        unstable_pkgs.oxfmt
        unstable_pkgs.tsgolint
      ];

      linux_pkgs = [
        pkgs.kdiff3
        pkgs.copyq
        pkgs.maim
        pkgs.sshfs
        pkgs.calibre
        pkgs.variety
        pkgs.gammastep
      ];
    in
    {
      packages.default = pkgs.buildEnv {
        name = "adisuper";
        paths = common_pkgs ++ (if pkgs.stdenv.isLinux then linux_pkgs else [ ]);
      };
      formatter = pkgs.nixpkgs-fmt;
    }
  );
}
