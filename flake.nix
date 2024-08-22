{
  description = "A NixOS flake with support for Linux and Darwin";

  inputs = {
    nixpkgs.url = "nixpkgs/nixos-unstable";
    nixpkgs-stable.url = "nixpkgs/nixos-24.05";
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

    # NOTE(aver): Don't use the default flake input, as it breaks when building with split-monitor-workspaces
    hyprland.url = "git+https://github.com/hyprwm/Hyprland?submodules=1&rev=9a09eac79b85c846e3a865a9078a3f8ff65a9259";
    hyprland-plugins = {
      url = "github:hyprwm/hyprland-plugins";
      inputs.hyprland.follows = "hyprland";
    };

    # Some additional overlays
    neovim-nightly.url = "github:nix-community/neovim-nightly-overlay";

  };

  outputs = inputs@{ self, nixpkgs, nixpkgs-stable, nixos-hardware, nix-darwin, home-manager, ... }:
    let
      systemSettings = {
        system = "x86_64-linux";
        timezone = "Europe/Zurich";
        locale = "en_US.UTF-8";
        kernelVersion = "6_10";
        username = "arminveres";
      };
      pkgs = import nixpkgs {
        system = systemSettings.system;
        config = { allowUnfree = true; };
        overlays = [
          inputs.neovim-nightly.overlays.default
          # inputs.nixd-git.overlays.default
        ];
      };
      pkgs-stable = import nixpkgs-stable {
        system = systemSettings.system;
        config = { allowUnfree = true; };
        overlays = [
          inputs.neovim-nightly.overlays.default
          # inputs.nixd-git.overlays.default
        ];
      };
    in {
      # NOTE(aver): We let Home Manager be managed through flakes, therefore no `homeConfigurations`
      # needed here
      nixosConfigurations = (import ./hosts {
        inherit (nixpkgs) lib;
        inherit inputs nixpkgs pkgs pkgs-stable nixos-hardware systemSettings home-manager;
      });
      # NOTE(aver): don't inherit pkgs and system, as it is not a x86_64-linux based system
      darwinConfigurations =
        (import ./darwin { inherit self inputs nixpkgs home-manager nix-darwin; });
    };
}
