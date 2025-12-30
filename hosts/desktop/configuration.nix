{ pkgs, systemSettings, ... }: {
  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "23.11"; # Did you read the comment?

  imports = [ ../../modules/core ];

  gaming.enable = true;
  fm.enable = true;
  bluetooth.enable = true;
  docker.enable = true;
  desktop.enable = true;

  # enable hyprlock pam authentication
  security.pam.services.hyprlock = { };

  home-manager.users.${systemSettings.username} = {
    neovim.enable = true;
    gaming.enable = true;
    latex.enable = true;
    desktop.enable = true;

    services = {
      blueman-applet.enable = true;
      hyprpaper = {
        settings = {
          preload = [
            "~/nix-conf/dotfiles/wallpapers/Pictures/wallpapers/selected/rim-231014.jpg"
            "~/nix-conf/dotfiles/wallpapers/Pictures/wallpapers/selected/desert-dunes-4k-bx.jpg"
          ];
          # set the default wallpaper(s) seen on initial workspace(s) --depending on the number of monitors used
          wallpaper = [
            "DP-1, ~/nix-conf/dotfiles/wallpapers/Pictures/wallpapers/selected/desert-dunes-4k-bx.jpg"
            "DP-2, ~/nix-conf/dotfiles/wallpapers/Pictures/wallpapers/selected/rim-231014.jpg"
          ];
        };
      };
    };

    hyprlandwm = {
      enable = true;
      hostConfig = {
        monitor = [
          # Bitdepth 10 provides some compability issues with screensharing.
          "DP-1,      3840x2160@240,  0x0,        1.5"
          "DP-2,      1920x1200@60,   auto-left,  1,  transform, 1"
        ];

        input = {
          kb_layout = "eu";
          repeat_rate = 30;
          repeat_delay = 250;

          follow_mouse = 1;
          sensitivity = 0; # -1.0 - 1.0, 0 means no modification.
          touchpad.natural_scroll = true;
        };

        device = [
          {
            name = "logitech-g-pro--1";
            accel_profile = "flat";
          }
          {
            name = "logitech-usb-receiver";
            accel_profile = "flat";
          }
        ];

        decoration = {
          blur.enabled = true;
          shadow = {
            enabled = true;
            range = 4;
            render_power = 3;
            color = "rgba(1a1a1aee)";
          };
        };
        workspace = [
          # code
          "1,   monitor:DP-1, default:true"
          # web
          "2,   monitor:DP-1"
          # games
          "3,   monitor:DP-1"
          # research
          "4,   monitor:DP-1"
          "5,   monitor:DP-1"
          # use layoutopt:orientation:top for master placement
          # messages
          "6,   monitor:DP-2, layoutopt:orientation:top, default:true"
          # mail
          "7,   monitor:DP-2, layoutopt:orientation:top"
          # sound + bluetooth
          "8,   monitor:DP-2, layoutopt:orientation:top"
          "9,   monitor:DP-2, layoutopt:orientation:top"
          "10,  monitor:DP-2, layoutopt:orientation:top"
        ];

        windowrule = [
          "workspace 3 silent, match:class ^steam$"
          "workspace 3 silent, match:class ^heroic$"
          # add steam games to ws 6
          "workspace 5 silent, match:class (steam_app_*)"
          "monitor 0,          match:class (steam_app_*)"
          # "fullscreen,          class:(steam_app_*)"

          "workspace 6 silent, match:class ^signal$"
          "workspace 6 silent, match:class ^Signal$"
          "workspace 6 silent, match:class ^discord$"
          "workspace 6 silent, match:class ^Discord$"
          "workspace 6 silent, match:class ^WebCord$"
          "workspace 6 silent, match:class ^vesktop$"
          "workspace 6 silent, match:title ^Microsoft Teams*$"
          "tile on,            match:title ^Microsoft Teams*$"

          "workspace 7 silent, match:class ^ch.proton.bridge-gui$"
          "workspace 7 silent, match:class ^thunderbird$"

          "workspace 8 silent, match:class ^Spotify$"
          "workspace 8 silent, match:class ^blueman-manager$"
          "workspace 8 silent, match:class ^easyeffects$"

          "workspace 9 silent, match:class ^org.corectrl.CoreCtrl$"

          "float on, match:class ^org.gnome.Calculator$"
          "float on, match:title ^Friends List$"
        ];

        env = [
          "XCURSOR_SIZE,24"
          "HYPRCURSOR_SIZE,24"
          "HYPRCURSOR_THEME,Adwaita"
          "QT_QPA_PLATFORM,wayland"
          "GDK_SCALE,1.25"
          "QT_SCALE,1.25"
        ];
      };
    };
  };

  hardware.graphics = {
    extraPackages = with pkgs;
      [
        # amdvlk # NOTE: superseded mainly by radv, https://www.phoronix.com/news/AMDVLK-Four-Months-Go
        # add OpenCL support, or just rely on the amgpu module from `nixos-hardware`
        # rocmPackages.clr.icd
        # clinfo
      ];
    extraPackages32 = with pkgs;
      [
        # driversi686Linux.amdvlk # NOTE: superseded mainly by radv, https://www.phoronix.com/news/AMDVLK-Four-Months-Go
      ];
    enable32Bit = true;
  };
  hardware.probe-rs.enable = true;

  environment.systemPackages = with pkgs; [
    vulkan-tools
    ddcui
    nvtopPackages.amd
    radeontop

    prusa-slicer
  ];

  # define default driver
  environment.variables.AMD_VULKAN_ICD = "RADV";

}
