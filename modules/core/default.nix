{ pkgs, lib, config, ... }:
{
  imports = [
    ./gaming.nix
    ./printing.nix
    ./fm.nix
  ];
  gaming.enable = lib.mkDefault false;
  printing.enable = lib.mkDefault false;
  fm.enable = lib.mkDefault false;
}
