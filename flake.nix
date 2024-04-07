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
    hyprland.url = "github:hyprwm/Hyprland";
  };

  outputs = { self, nixpkgs, nixpkgs-stable, home-manager, neovim-nightly-overlay, ... }:
    let
      systemSettings = {
        system = "x86_64-linux";
        hostname = "homews";
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

      lib = nixpkgs.lib;

    in
    {
      nixosConfigurations = {
        vm = lib.nixosSystem {
          system = systemSettings.system;
          specialArgs = { inherit pkgs; };
          modules = [ ./hosts/vm-hw.nix ./configuration.nix ];
        };
        x1c = lib.nixosSystem {
          system = systemSettings.system;
          specialArgs = { inherit pkgs; };
          modules = [
            ./hosts/x1c-hw.nix
            ./configuration.nix
            home-manager.nixosModules.home-manager
            {
              home-manager.users.arminveres = import ./home.nix;
              home-manager.useGlobalPkgs = true;
              home-manager.useUserPackages = true;
              home-manager.extraSpecialArgs = { inherit pkgs-stable systemSettings userSettings; };
            }
          ];
        };
        desktop = lib.nixosSystem {
          system = systemSettings.system;
          specialArgs = { inherit pkgs; };
          modules = [
            ./hosts/desktop-hw.nix
            ./configuration.nix
            home-manager.nixosModules.home-manager
            {
              home-manager.users.arminveres = import ./home.nix;
              home-manager.useGlobalPkgs = true;
              home-manager.useUserPackages = true;
              home-manager.extraSpecialArgs = { inherit pkgs-stable systemSettings userSettings; };
            }
          ];
        };
      };
    };
}
