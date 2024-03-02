{
  description = "A simple NixOS flake with Neovim nightly";

  inputs = {
    nixpkgs.url = "nixpkgs/nixos-unstable";
    nixpkgs-stable.url = "nixpkgs/nixos-23.11";
    neovim-nightly-overlay.url = "github:nix-community/neovim-nightly-overlay";
    home-manager = {
      url = "github:nix-community/home-manager/master";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { self, nixpkgs, nixpkgs-stable, home-manager, neovim-nightly-overlay, ... }:
      let
        systemSettings={
          system = "x86_64-linux";
          hostname = "homews";
          timezone = "Europe/Zurich";
          locale = "en_US.UTF-8";
        };

        userSettings = {
          username = "arminveres";
        };

        pkgs = import nixpkgs {
          system = systemSettings.system;

          overlays = [ neovim-nightly-overlay.overlay ];
          config = {
            allowUnfree = true;
          };
        };

        pkgs-stable = import nixpkgs-stable {
          system = systemSettings.system;
          overlays = [ neovim-nightly-overlay.overlay ];
          config = {
            allowUnfree = true;
          };
        };

        lib = nixpkgs.lib;

      in {
        homeConfiguration = {
          user = home-manager.lib.homeManagerConfiguration {
            inherit pkgs;
            modules = [./nixos/home.nix];
            extraSpecialArgs = {
              inherit pkgs-stable;
              inherit systemSettings;
              inherit userSettings;
            };
          };
        };
        nixosConfigurations = {
          vm = nixpkgs.lib.nixosSystem {
          system = systemSettings.system;
            specialArgs = {
              inherit pkgs;
            };
            modules = [./nixos/hosts/vm-hw.nix ./nixos/configuration.nix];
          };
          x1c = nixpkgs.lib.nixosSystem {
          system = systemSettings.system;
            specialArgs = {
              inherit pkgs;
            };
            modules = [./nixos/hosts/x1c-hw.nix ./nixos/configuration.nix];
          };
        };
      };
}
