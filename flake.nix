{
  description = "A simple NixOS flake with Neovim nightly";

  inputs = {
    nixpkgs.url = "nixpkgs/nixos-unstable";
    nixpkgs-stable.url = "nixpkgs/nixos-23.11";
    neovim-nightly-overlay.url = "github:nix-community/neovim-nightly-overlay";
  };

  outputs = { self, nixpkgs, nixpkgs-stable, neovim-nightly-overlay, ... }:
      let
        system = "x86_64-linux";

        pkgs = import nixpkgs {
          inherit system;
          overlays = [ neovim-nightly-overlay.overlay ];
          config = {
            allowUnfree = true;
          };
        };

        pkgs-stable = import nixpkgs-stable {
          inherit system;
          overlays = [ neovim-nightly-overlay.overlay ];
          config = {
            allowUnfree = true;
          };
        };

      in {
        nixosConfigurations = {
          myNixos = nixpkgs.lib.nixosSystem {
            specialArgs = { 
              inherit system;
              inherit pkgs;
            };
            modules = [./nixos/configuration.nix];
          };
        };
      };
}
