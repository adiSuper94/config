{
  description = "Linux (and MacOS?) home configuration";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-26.05";
    nixpkgs-unstable.url = "github:NixOS/nixpkgs/nixos-unstable";
    neovim-nightly-overlay.url = "github:nix-community/neovim-nightly-overlay";
  };
  outputs =
    {
      self,
      nixpkgs,
      nixpkgs-unstable,
      neovim-nightly-overlay,
    }:
    let
      systems = [
        "aarch64-linux"
        "x86_64-linux"
        "aarch64-darwin"
        "x86_64-darwin"
      ];

      unstablePkgsFor =
        system:
        import nixpkgs-unstable {
          inherit system;
          overlays = [ neovim-nightly-overlay.overlays.default ];
        };

      forEachSystem =
        fn:
        nixpkgs.lib.genAttrs systems (system: fn nixpkgs.legacyPackages.${system} (unstablePkgsFor system));
    in
    {
      packages = forEachSystem (
        stable_pkgs: pkgs:
        let
          common_pkgs = [
            #LSP-esques
            pkgs.tailwindcss-language-server
            pkgs.gopls
            pkgs.bash-language-server
            pkgs.shellcheck
            pkgs.vscode-langservers-extracted
            pkgs.yaml-language-server
            pkgs.lua-language-server
            pkgs.stylua
            pkgs.taplo
            pkgs.uv
            pkgs.ty
            pkgs.ruff
            pkgs.tsgolint
            pkgs.nil
            stable_pkgs.oxfmt
            stable_pkgs.oxlint
            # Languages
            pkgs.go
            pkgs.pnpm
            pkgs.nodejs
            # Tools
            pkgs.gnupg
            pkgs.pass-nodmenu
            pkgs.wget2
            pkgs.unzip
            pkgs.btop
            pkgs.pgcli
            pkgs.opencode
            pkgs.neovim
            pkgs.tree-sitter
            pkgs.tuicr
            pkgs.gh
            pkgs.bat
            pkgs.bat-extras.core
            pkgs.eza
            pkgs.fd
            pkgs.ripgrep
            pkgs.fzf
            pkgs.jq
            pkgs.zoxide
            pkgs.lazygit
            pkgs.direnv
            pkgs.tmux
            pkgs.ijq
            pkgs.ncdu
            pkgs.pkgconf
            pkgs.podman
            pkgs.podman-compose
            pkgs.postgresql
            pkgs.lazysql
          ];

          linux_pkgs = [
            stable_pkgs.kdiff3
            stable_pkgs.copyq
            stable_pkgs.maim
            stable_pkgs.sshfs
            stable_pkgs.calibre
            stable_pkgs.variety
            stable_pkgs.gammastep
            pkgs.legcord
            pkgs.waybar
            pkgs.sway
          ];
        in
        {
          default = stable_pkgs.buildEnv {
            name = "adisuper";
            paths = common_pkgs ++ (if stable_pkgs.stdenv.isLinux then linux_pkgs else [ ]);
          };
        }
      );
    };
}
