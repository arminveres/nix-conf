{ userSettings, ... }: {
  imports = [ ../../modules/core ];

  printing.enable = true;
  fm.enable = true;
  power-management.enable = true;
  fingerprint.enable = true;
  bluetooth.enable = true;

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

        windowrulev2 = [
          "workspace 4 silent,  class:^Spotify$"
          "workspace 4 silent,  class:^blueman-manager$"
          "workspace 4 silent,  class:^easyeffects$"

          "workspace 5 silent,  class:^steam$"
          # add steam games to ws 6
          "workspace 5 silent,  class:^steam_app_\d*$"
          "monitor 1,           class:^steam_app_\d*$"
          "fullscreen,          class:^steam_app_\d*$"

          "workspace 6 silent,  class:^thunderbird$"
          "workspace 6 silent,  class:^ch.proton.bridge-gui$"

          "workspace 9 silent,  class:^signal$"
          "workspace 9 silent,  class:^Signal$"
          "workspace 9 silent,  class:^discord$"
          "workspace 9 silent,  class:^Discord$"
          "workspace 9 silent,  class:^WebCord$"
          "workspace 9 silent,  title:^Microsoft Teams*$"
          "tile,                title:^Microsoft Teams*$"
          "float, class:^org.gnome.Calculator$"
        ];
      };
    };
    latex.enable = true;
    services.blueman-applet.enable = true;
  };
}
