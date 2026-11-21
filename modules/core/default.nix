{ pkgs, lib, config, systemSettings, ... }: {
  imports = [
    ./gaming.nix
    ./printing.nix
    ./fm.nix
    ./fingerprint.nix
    ./bluetooth.nix
    ./docker.nix
    ./desktop.nix
  ];
  gaming.enable = lib.mkDefault false;
  printing.enable = lib.mkDefault false;
  fm.enable = lib.mkDefault false;
  fingerprint.enable = lib.mkDefault false;
  bluetooth.enable = lib.mkDefault false;
  docker.enable = lib.mkDefault false;
  desktop.enable = lib.mkDefault false;
}
