{
  description = "A NixOS flake with support for Linux and Darwin";

  inputs = {
    nixpkgs.url = "nixpkgs/nixos-unstable";
    # Hardware Specific Configurations
    nixos-hardware = {
      url = "github:nixos/nixos-hardware/master";
      inputs.nixpkgs.follows = "nixpkgs";
    };

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

    probe-rs-rules = {
      url = "github:jneem/probe-rs-rules";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    pwndbg.url = "github:pwndbg/pwndbg";
    xremap = {
      url = "github:xremap/nix-flake";
      inputs.nixpkgs.follows = "nixpkgs";
    };
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
        username = "arminveres"; # TODO: switch to 'user' for anonymity
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
