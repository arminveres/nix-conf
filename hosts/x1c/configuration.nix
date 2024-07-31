{ userSettings, ... }: {
  imports = [ ../../modules/core ];
  printing.enable = true;
  fm.enable = true;

  home-manager.users.${userSettings.username} = {
    neovim.enable = true;
    gaming.enable = false;
    hyprlandwm = {
      enable = true;
      hostConfig = {
        monitor = [ ",preferred,auto,1.0" ];
        decoration = {
          blur.enabled = false;
          drop_shadow = false;
        };
          workspace = [
            "1, monitor:eDP-1, default:true"
            "2, monitor:eDP-1"
            "3, monitor:eDP-1"
            "4, monitor:eDP-1"
            "5, monitor:eDP-1"
            "6, monitor:eDP-1"
            "7, monitor:eDP-1"
            "8, monitor:eDP-1"
            "9, monitor:eDP-1"
            # use this as a kind of scratchpad
            "10, monitor:DP-2, default:true"
          ];
      };
    };
    latex.enable = true;
    services.blueman-applet.enable = true;
  };
  services.blueman.enable = true;
}
