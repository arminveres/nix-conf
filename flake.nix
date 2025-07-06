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

    /* hyprland-plugins = {
         url = "github:hyprwm/hyprland-plugins";
         inputs.hyprland.follows = "hyprland";
       };
    */

    # Some additional overlays
    neovim-nightly.url = "github:nix-community/neovim-nightly-overlay";

    # DayZ Launcher
    dzgui-nix = {
      url = "github:lelgenio/dzgui-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    zen-browser.url = "github:MarceColl/zen-browser-flake";
  };

  outputs = inputs@{ nixpkgs, nixos-hardware, home-manager, ... }:
    let
      systemSettings = {
        system = "x86_64-linux";
        timezone = "Europe/Zurich";
        locale = "en_US.UTF-8";
        kernelVersion = "6_15";
        username = "arminveres";
      };
    in {
      # NOTE(aver): We let Home Manager be managed through flakes, therefore no `homeConfigurations`
      # needed here
      nixosConfigurations = (import ./hosts {
        inherit (nixpkgs) lib;
        inherit inputs nixpkgs nixos-hardware systemSettings home-manager;
      });
      /* # NOTE(aver): don't inherit pkgs and system, as it is not a x86_64-linux based system
         darwinConfigurations =
           (import ./darwin { inherit self inputs nixpkgs home-manager nix-darwin; });
      */
    };
}
