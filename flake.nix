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
      homeConfigurations = (
        import ./home {
          inherit
            home-manager
            inputs
            overlays
            pkgs
            systemSettings
            ;
        }
      );
    };
}
