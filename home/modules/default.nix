{ inputs, nixpkgs, pkgs, lib, ... }:
{
  imports = [
    ./gaming.nix
    ./hyprland.nix
    ./neovim.nix
    ./latex.nix
  ];
  gaming.enable = lib.mkDefault false;
  hyprlandwm.enable = lib.mkDefault false;
  neovim.enable = lib.mkDefault false;
  latex.enable = lib.mkDefault false;
}
