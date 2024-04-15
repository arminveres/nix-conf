{
  description = "A simple NixOS flake with Neovim nightly";

  inputs = {
    nixpkgs.url = "nixpkgs/nixos-unstable";
    nixpkgs-stable.url = "nixpkgs/nixos-23.11";
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

    colloid-gtk-theme = {
      url = "github:arminveres/colloid-gtk-theme";
    };

  };

  outputs =
    { self
    , nixpkgs
    , nixpkgs-stable
    , home-manager
    , neovim-nightly-overlay
    , split-monitor-workspaces
    , colloid-gtk-theme
    , ...
    }@inputs:
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

        /* vm = lib.nixosSystem {
          system = systemSettings.system;
          specialArgs = { inherit pkgs; };
          modules = [ ./hosts/vm-hw.nix ./configuration.nix ];
        }; */

        x1c = lib.nixosSystem {
          system = systemSettings.system;
          specialArgs = { inherit pkgs inputs; };
          modules = [
            ./hosts/x1c-hw.nix
            ./configuration.nix
            home-manager.nixosModules.home-manager
            {
              home-manager.users.arminveres = import ./home.nix;
              home-manager.useGlobalPkgs = true;
              home-manager.useUserPackages = true;
              home-manager.extraSpecialArgs = { inherit inputs pkgs-stable systemSettings userSettings split-monitor-workspaces; };
            }
          ];
        };
        desktop = lib.nixosSystem {
          system = systemSettings.system;
          specialArgs = { inherit pkgs inputs; };
          modules = [
            ./hosts/desktop-hw.nix
            ./configuration.nix
            home-manager.nixosModules.home-manager
            {
              home-manager.users.arminveres = import ./home.nix;
              home-manager.useGlobalPkgs = true;
              home-manager.useUserPackages = true;
              home-manager.extraSpecialArgs = {
                inherit inputs pkgs-stable systemSettings
                  userSettings split-monitor-workspaces colloid-gtk-theme;
              };
            }
          ];
        };
      };
    };
}
