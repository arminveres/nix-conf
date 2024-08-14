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

    neovim-nightly.url = "github:nix-community/neovim-nightly-overlay";

    # NOTE(aver): Don't use the default flake input, as it breaks when building with split-monitor-workspaces
    hyprland.url = "git+https://github.com/hyprwm/Hyprland?submodules=1";
    hyprland-plugins = {
      url = "github:hyprwm/hyprland-plugins";
      inputs.hyprland.follows = "hyprland";
    };
  };

  outputs = inputs@{ self, nixpkgs, nixpkgs-stable, nixos-hardware, nix-darwin, home-manager, neovim-nightly, ... }:
    let
      systemSettings = {
        system = "x86_64-linux";
        timezone = "Europe/Zurich";
        locale = "en_US.UTF-8";
        kernelVersion = "6_9";
      };
      userSettings = { username = "arminveres"; };
      pkgs = import nixpkgs {
        system = systemSettings.system;
        overlays = [ neovim-nightly.overlays.default ];
        config = { allowUnfree = true; };
      };
      pkgs-stable = import nixpkgs-stable {
        system = systemSettings.system;
        overlays = [ neovim-nightly.overlays.default ];
        config = { allowUnfree = true; };
      };
    in
    {
      # NOTE(aver): We let Home Manager be managed through flakes, therefore no `homeConfigurations`
      # needed here
      nixosConfigurations = (
        import ./hosts {
          inherit (nixpkgs) lib;
          inherit inputs nixpkgs pkgs pkgs-stable nixos-hardware systemSettings userSettings home-manager;
        }
      );
      # NOTE(aver): don't inherit pkgs and system, as it is not a x86_64-linux based system
      darwinConfigurations = (import ./darwin {
        inherit self inputs nixpkgs home-manager nix-darwin userSettings neovim-nightly;
      });
    };
}
