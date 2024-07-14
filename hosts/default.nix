/*
  Different host profiles when building NixOS
*/

{ inputs
, nixpkgs
, pkgs
, pkgs-stable
, nixos-hardware
, systemSettings
, userSettings
, home-manager
, ...
}:
let
  lib = nixpkgs.lib;
  system = systemSettings.system;
in
{
  nixos-desktop = lib.nixosSystem {
    inherit system;
    specialArgs = { inherit inputs pkgs systemSettings userSettings; };
    modules = [
      home-manager.nixosModules.home-manager
      ./configuration.nix
      ./desktop/hardware-configuration.nix
      ./desktop/configuration.nix
      nixos-hardware.nixosModules.common-cpu-intel-cpu-only
      nixos-hardware.nixosModules.common-gpu-amd
    ];
  };

  nixos-x1c = lib.nixosSystem {
    inherit system;
    specialArgs = { inherit inputs pkgs systemSettings userSettings; };
    modules = [
      home-manager.nixosModules.home-manager
      ./configuration.nix
      ./x1c/hardware-configuration.nix
      ./x1c/configuration.nix
      nixos-hardware.nixosModules.lenovo-thinkpad-x1-9th-gen
    ];
  };
}
