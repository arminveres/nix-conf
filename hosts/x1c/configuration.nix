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

  programs.zsh.shellAliases = { ptop = "sudo powertop"; };

  home-manager.users.${systemSettings.username} = {
    # my modules
    neovim.enable = true;
    gaming.enable = false;
    latex.enable = true;

    services = {
      blueman-applet.enable = true;
      easyeffects.enable = true;
      hyprpaper = {
        settings = {
          preload = [
            "~/nix-conf/dotfiles/wallpapers/Pictures/wallpapers/selected/desert-dunes-4k-bx.jpg"
            # "~/nix-conf/dotfiles/wallpapers/Pictures/wallpapers/selected/rim-231014.jpg"
          ];
          # set the default wallpaper(s) seen on initial workspace(s) --depending on the number of monitors used
          wallpaper = [
            "eDP-1, ~/nix-conf/dotfiles/wallpapers/Pictures/wallpapers/selected/desert-dunes-4k-bx.jpg"
            # "DP-2, ~/nix-conf/dotfiles/wallpapers/Pictures/wallpapers/selected/rim-231014.jpg"
          ];
        };
      };
    };

    hyprlandwm = {
      enable = true;
      hostConfig = {
        monitor = [ ",preferred,auto,1.0" ];

        input = {
          kb_layout = "eu";
          repeat_rate = 30;
          repeat_delay = 250;

          follow_mouse = 1;
          sensitivity = 0; # -1.0 - 1.0, 0 means no modification.
          touchpad.natural_scroll = true;

          force_no_accel = false;
          accel_profile = "adaptive"; # flat
        };

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
          "fullscreen on,      match:class ^steam_app_d*$"

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

        gesture = [ "3, horizontal, workspace" ];
      };
    };
  };
}
