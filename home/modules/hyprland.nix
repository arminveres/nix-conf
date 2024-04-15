{ pkgs, lib, config, inputs, split-monitor-workspaces, ... }:
{
  options = {
    hyprlandwm.enable = lib.mkEnableOption "enables Home-Manager Hyprland module";
  };

  config = lib.mkIf config.hyprlandwm.enable {
    home.packages = with pkgs; [
      playerctl
      kanshi
      wlogout
      pulseaudio
      pavucontrol
      wdisplays
      hyprlock
      hypridle
      hyprland-protocols
      hyprpaper
      hyprshot
      hyprpicker
      wofi
      waybar
      swaynotificationcenter
      swaylock
      swayosd
    ];

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
