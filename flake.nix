{
  description = "A simple NixOS flake with Neovim nightly";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    neovim-nightly-overlay.url = "github:nix-community/neovim-nightly-overlay";
  };

  outputs = { self, nixpkgs, neovim-nightly-overlay, ... }:
      let
        system = "x86_64-linux";

        pkgs = import nixpkgs {
          inherit system;
          overlays = [ neovim-nightly-overlay.overlay ];
          config = {
            allowUnfree = true;
          };
        };
      in {
        nixosConfigurations = {
          myNixos = nixpkgs.lib.nixosSystem {
            specialArgs = { inherit system; };
            modules = [
              ./nixos/configuration.nix
              { programs.neovim = { enable = true; package = pkgs.neovim-nightly;}; }
            ];
          };
        };
      };
}
