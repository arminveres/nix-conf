{
  description = "A NixOS flake with support for Linux and Darwin";

  inputs = {
    nixpkgs.url = "nixpkgs/nixos-unstable";
    nixos-hardware.url = "github:nixos/nixos-hardware/master"; # Hardware Specific Configurations

    home-manager = {
      url = "github:nix-community/home-manager/master";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    hyprland.url = "github:hyprwm/Hyprland";

    neovim-nightly.url = "github:nix-community/neovim-nightly-overlay";

    # DayZ Launcher
    dzgui-nix = {
      url = "github:lelgenio/dzgui-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    probe-rs-rules.url = "github:jneem/probe-rs-rules";

    pwndbg.url = "github:pwndbg/pwndbg";
  };

  outputs =
    inputs@{
      nixpkgs,
      nixos-hardware,
      home-manager,
      ...
    }:
    let
      systemSettings = rec {
        system = "x86_64-linux";
        timezone = "Europe/Zurich";
        locale = "en_US.UTF-8";
        kernelVersion = "6_18";
        username = "arminveres";
        homeDirectory = "/home/${username}";
      };
      overlays = [ inputs.neovim-nightly.overlays.default ];
      system = systemSettings.system;
      pkgs = import nixpkgs {
        inherit system;
        config.allowUnfree = true; # optional
      };
    in
    {
      # NOTE(aver): We let Home Manager be managed through flakes, therefore no `homeConfigurations`
      # needed here
      nixosConfigurations = (
        import ./hosts {
          inherit (nixpkgs) lib;
          inherit
            inputs
            nixpkgs
            nixos-hardware
            systemSettings
            home-manager
            ;
        }
      );
      # TODO(aver): Move into modules, refactor the ./modules/home/default.nix file to accommodate
      # standalone instantiations.
      homeConfigurations."ubuntu" = home-manager.lib.homeManagerConfiguration {
        inherit pkgs;
        extraSpecialArgs = { inherit inputs systemSettings; };
        modules = [
          (
            {
              inputs,
              pkgs,
              lib,
              ...
            }:
            {
              nixpkgs.overlays = overlays;
              imports = [ ./modules/home/modules ];

              home = {
                username = systemSettings.username;
                homeDirectory = systemSettings.homeDirectory;
                # IMPORTANT: set this once and don’t change it casually.
                stateVersion = "26.05"; # pick your HM release/state version
                packages = [
                  pkgs.nodejs
                  inputs.pwndbg.packages.${system}.pwndbg
                ];
              };

              xdg.enable = true;

              programs = {
                home-manager.enable = true;
                nh = {
                  enable = true;
                  clean.enable = true;
                  clean.extraArgs = "--keep-since 4d --keep 3";
                  flake = "${systemSettings.homeDirectory}/nix-conf?submodules=1"; # sets NH_OS_FLAKE variable for you
                };

                fzf = {
                  enable = true;
                  enableZshIntegration = true;
                  tmux.enableShellIntegration = true;
                  # defaultCommand = "rg --hidden -l ''";
                  # defaultCommand = "fd --type f";
                  defaultOptions = [
                    "--height 40%"
                    "--layout=reverse"
                    "--border"
                  ];
                };

                zoxide = {
                  enable = true;
                  enableZshIntegration = true;
                  options = [ "--cmd cd" ];
                };

                direnv = {
                  nix-direnv.enable = true;
                  enable = true;
                  enableZshIntegration = true;
                };

                ripgrep.enable = true;
                fd.enable = true;
              };

              # my modules
              ave = {
                neovim.enable = true;
                zsh.enable = true;
              };

            }
          )
        ];
      };

      # # Don't inherit pkgs and system, as it is not a x86_64-linux based system
      # darwinConfigurations =
      #   (import ./darwin { inherit self inputs nixpkgs home-manager nix-darwin; });
    };
}
