{ self
, inputs
, nixpkgs
, pkgs
, pkgs-stable
, nix-darwin
, systemSettings
, userSettings
, home-manager
, split-monitor-workspaces
, ...
}:
let
  lib = nixpkgs.lib;
  system = "aarch64_darwin";
in
{
  armins-macbook = nix-darwin.lib.darwinSystem {
    inherit system;
    modules = [ ./configuration.nix ./hardware-configuration.nix ];
    specialArgs = { inherit inputs pkgs; };
  };
  darwinPackages = self.darwinConfigurations.armins-macbook.pkgs;
}
