{ pkgs, systemSettings, ... }: {
  imports = [ ../../modules/core ];

  gaming.enable = true;
  fm.enable = true;
  bluetooth.enable = true;
  docker.enable = true;

  # enable hyprlock pam authentication
  security.pam.services.hyprlock = { };

  home-manager.users.${systemSettings.username} = {
    neovim.enable = true;
    gaming.enable = true;
    latex.enable = true;

    services.blueman-applet.enable = true;

    hyprlandwm = {
      enable = true;
      hostConfig = {
        monitor = [
          # Bitdepth 10 provides some compability issues with screensharing.
          # "DP-1,      3840x2160@240,  0x0,        1.5,  bitdepth, 10"
          "DP-1,      3840x2160@240,  0x0,        1.5"
          "DP-2,      1920x1200@60,   auto-left,  1.25"
          # "DP-2,      1920x1200@60,   auto-right, 1,    transform, 3"
          # "HDMI-A-2,  3840x2160@120,  auto-right, 1.25"
        ];

        input = {
          kb_layout = "eu";
          repeat_rate = 30;
          repeat_delay = 250;

          follow_mouse = 1;
          sensitivity = 0; # -1.0 - 1.0, 0 means no modification.
          touchpad.natural_scroll = true;
        };

        device = {
          name = "logitech-g-pro--1";
          # name = "logitech-usb-receiver";
          accel_profile = "flat";
        };

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
          # "6,   monitor:DP-2, layoutopt:orientation:top, default:true"
          # messages
          "6,   monitor:DP-2, default:true"
          # mail
          "7,   monitor:DP-2"
          # sound + bluetooth
          "8,   monitor:DP-2"
          "9,   monitor:DP-2"
          "10,  monitor:DP-2"
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
