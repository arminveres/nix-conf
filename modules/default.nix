{ pkgs, lib, config, ... }:
{
  imports = [
    ./gaming.nix
    ./printing.nix
  ];
  gaming.enable = lib.mkDefault false;
  printing.enable = lib.mkDefault false;
}
