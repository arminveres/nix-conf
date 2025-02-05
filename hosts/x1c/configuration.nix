{ inputs, systemSettings, pkgs, ... }: {
  imports = [ ../../modules/core ];

  printing.enable = true;
  fm.enable = true;
  power-management.enable = true;
  fingerprint.enable = true;
  bluetooth.enable = true;
  docker.enable = true;

  # enable hyprlock pam authentication
  security.pam.services.hyprlock = {
    fprintAuth = true;
    enableGnomeKeyring = true;
  };

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
          "SSH_AUTH_SOCK,$XDG_RUNTIME_DIR/keyring/ssh"
          "QT_QPA_PLATFORM,wayland"
        ];

        decoration = {
          blur.enabled = false;
          shadow.enabled = false;
        };
        workspace = [ "1, monitor:eDP-1, default:true" ];

        windowrulev2 = [
          "workspace 4 silent,  class:^Spotify$"
          "workspace 4 silent,  class:^blueman-manager$"
          "workspace 4 silent,  class:^easyeffects$"

          "workspace 5 silent,  class:^steam$"
          # add steam games to ws 6
          "workspace 5 silent,  class:^steam_app_d*$"
          "monitor 1,           class:^steam_app_d*$"
          "fullscreen,          class:^steam_app_d*$"

          "workspace 7 silent,  class:^thunderbird$"
          "workspace 7 silent,  class:^ch.proton.bridge-gui$"

          "workspace 6 silent,  class:^signal$"
          "workspace 6 silent,  class:^Signal$"
          "workspace 6 silent,  class:^discord$"
          "workspace 6 silent,  class:^Discord$"
          "workspace 6 silent,  class:^WebCord$"
          "workspace 6 silent,  title:^Microsoft Teams*$"
          "tile,                title:^Microsoft Teams*$"
          "float, class:^org.gnome.Calculator$"
        ];
      };
    };
  };
}
