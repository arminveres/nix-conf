{ inputs
, nix-darwin
, nixpkgs
, userSettings
, home-manager
, neovim-nightly-overlay
, ...
}:
let
  system = "aarch64-darwin";
  pkgs = import nixpkgs {
    system = system;
    overlays = [ neovim-nightly-overlay.overlay ];
    config = { allowUnfree = true; };
  };
in
{
  armins-macbook = nix-darwin.lib.darwinSystem {
    inherit system;
    modules = [
      ./configuration.nix
      # ./hardware-configuration.nix
    ];
    specialArgs = { inherit inputs pkgs nix-darwin; };
  };
  darwinPackages = nix-darwin.darwinConfigurations.armins-macbook.pkgs;
}
