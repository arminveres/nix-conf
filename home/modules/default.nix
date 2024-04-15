{ pkgs, lib, config, inputs, split-monitor-workspaces, ... }:
{
  imports = [
    ./gaming.nix
    ./hyprland.nix
  ];
  gaming.enable = lib.mkDefault false;
  hyprlandwm.enable = lib.mkDefault false;
}
