{ pkgs, lib, config, systemSettings, ... }: {
  imports = [
    ./gaming.nix
    ./printing.nix
    ./fm.nix
    ./power-management.nix
    ./fingerprint.nix
    ./bluetooth.nix
    ./docker.nix
  ];
  gaming.enable = lib.mkDefault false;
  printing.enable = lib.mkDefault false;
  fm.enable = lib.mkDefault false;
  power-management.enable = lib.mkDefault false;
  fingerprint.enable = lib.mkDefault false;
  bluetooth.enable = lib.mkDefault false;
  docker.enable = lib.mkDefault false;
}
