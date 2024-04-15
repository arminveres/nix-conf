{
  description = "A NixOS flake with support for Linux and Darwin";

  inputs = {
    nixpkgs.url = "nixpkgs/nixos-unstable";
    nixpkgs-stable.url = "nixpkgs/nixos-23.11";
    nixos-hardware.url = "github:nixos/nixos-hardware/master"; # Hardware Specific Configurations

    # MacOS Package Management
    nix-darwin = {
      url = "github:lnl7/nix-darwin/master";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    home-manager = {
      url = "github:nix-community/home-manager/master";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    neovim-nightly-overlay.url = "github:nix-community/neovim-nightly-overlay";

    hyprland = {
      url = "github:hyprwm/Hyprland";
    };
    hyprland-plugins = {
      url = "github:hyprwm/hyprland-plugins";
      inputs.hyprland.follows = "hyprland";
    };
    split-monitor-workspaces = {
      url = "github:Duckonaut/split-monitor-workspaces";
      inputs.hyprland.follows = "hyprland";
    };

  };

  outputs =
    inputs@{ self, nixpkgs, nixpkgs-stable, nixos-hardware, nix-darwin, home-manager, neovim-nightly-overlay, split-monitor-workspaces, ... }:
    let
      systemSettings = {
        system = "x86_64-linux";
        timezone = "Europe/Zurich";
        locale = "en_US.UTF-8";
      };
      userSettings = { username = "arminveres"; };
      pkgs = import nixpkgs {
        system = systemSettings.system;
        overlays = [ neovim-nightly-overlay.overlay ];
        config = { allowUnfree = true; };
      };
      pkgs-stable = import nixpkgs-stable {
        system = systemSettings.system;
        overlays = [ neovim-nightly-overlay.overlay ];
        config = { allowUnfree = true; };
      };
    in
    {
      # NOTE(aver): We let Home Manager be managed through flakes, therefore no `homeConfigurations`
      # needed here
      nixosConfigurations = (
        import ./hosts {
          inherit (nixpkgs) lib;
          inherit inputs nixpkgs pkgs pkgs-stable nixos-hardware systemSettings userSettings
            home-manager split-monitor-workspaces;
        }
      );
      darwinConfigurations = (import ./darwin {
        inherit self inputs nixpkgs home-manager nix-darwin userSettings neovim-nightly-overlay;
      });
    };
}
