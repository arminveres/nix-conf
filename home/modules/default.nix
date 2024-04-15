{ pkgs, lib, config, inputs, split-monitor-workspaces, ... }:
{
  imports = [
    ./gaming.nix
    ./hyprland.nix
    ./neovim.nix
  ];
  gaming.enable = lib.mkDefault false;
  hyprlandwm.enable = lib.mkDefault false;
  neovim.enable = lib.mkDefault false;
}
