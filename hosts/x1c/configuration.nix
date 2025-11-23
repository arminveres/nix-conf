{ inputs, systemSettings, pkgs, ... }: {
  imports = [ ../../modules/core ];

  printing.enable = true;
  fm.enable = true;
  power-management.enable = true;
  fingerprint.enable = false;
  bluetooth.enable = true;
  docker.enable = true;

  # enable hyprlock pam authentication
  # security.pam.services.hyprlock = { fprintAuth = false; enableGnomeKeyring = true; };

  environment.systemPackages = with pkgs; [ intel-undervolt ];

  home-manager.users.${systemSettings.username} = {

    services.easyeffects.enable = true;

    neovim.enable = true;
    gaming.enable = false;
    latex.enable = true;
    services.blueman-applet.enable = true;

    hyprlandwm = {
      enable = true;
      hostConfig = {
        monitor = [ ",preferred,auto,1.0" ];

        # only swap keys for the builtin laptop keyboard
        device = {
          name = "at-translated-set-2-keyboard";
          kb_options = "ctrl:swapcaps,altwin:swap_lalt_lwin";
        };

        env = [
          "XCURSOR_SIZE,24"
          "HYPRCURSOR_SIZE,24"
          "HYPRCURSOR_THEME,Adwaita"
          "QT_QPA_PLATFORM,wayland"
        ];

        decoration = {
          blur.enabled = false;
          shadow.enabled = false;
        };
        workspace = [ "1, monitor:eDP-1, default:true" ];

        windowrule = [
          "workspace 4 silent, match:class ^Spotify$"
          "workspace 4 silent, match:class ^blueman-manager$"
          "workspace 4 silent, match:class ^easyeffects$"

          "workspace 5 silent, match:class ^steam$"
          # add steam games to ws 6
          "workspace 5 silent, match:class ^steam_app_d*$"
          "monitor 1,          match:class ^steam_app_d*$"
          "fullscreen,         match:class ^steam_app_d*$"

          "workspace 7 silent, match:class ^thunderbird$"
          "workspace 7 silent, match:class ^ch.proton.bridge-gui$"

          "workspace 6 silent, match:class ^signal$"
          "workspace 6 silent, match:class ^Signal$"
          "workspace 6 silent, match:class ^discord$"
          "workspace 6 silent, match:class ^Discord$"
          "workspace 6 silent, match:class ^WebCord$"
          "workspace 6 silent, match:title ^Microsoft Teams*$"
          "tile on,            match:title ^Microsoft Teams*$"
          "float on,           match:class ^org.gnome.Calculator$"
        ];
      };
    };
  };
}
