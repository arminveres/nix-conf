{ pkgs, lib, config, inputs, split-monitor-workspaces, ... }:
{
  options = {
    hyprlandwm.enable = lib.mkEnableOption "enables Home-Manager Hyprland module";
  };

  config = lib.mkIf config.hyprlandwm.enable {

    wayland.windowManager.hyprland = {
      enable = true;
      systemd.enable = true;
      xwayland.enable = true;
      package = inputs.hyprland.packages.${pkgs.system}.hyprland;
      plugins = [
        split-monitor-workspaces.packages.${pkgs.system}.split-monitor-workspaces
      ];
      extraConfig = (builtins.readFile ./hyprland.conf);
    };
  };
}
