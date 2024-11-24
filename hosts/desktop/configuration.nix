{ pkgs, systemSettings, ... }: {
  imports = [ ../../modules/core ];

  gaming.enable = true;
  fm.enable = true;
  bluetooth.enable = true;
  docker.enable = true;

  home-manager.users.${systemSettings.username} = {
    neovim.enable = true;
    gaming.enable = true;
    latex.enable = true;

    services.blueman-applet.enable = true;

    hyprlandwm = {
      enable = true;
      hostConfig = {
        monitor = [
          # NOTE(aver): since the scaling is 1.25 the transformation needs to be adjusted as well:
          # 3840/1.25=3072
          "DP-1,  3840x2160@240,  0x0,    1.25, bitdepth, 10"
          "DP-2,  1920x1200@60,   3072x0, 1,  transform,  3"
        ];

        device = {
          # name = "logitech-g-pro--1";
          name = "logitech-usb-receiver";
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
          # messages
          "6,   monitor:DP-2, layoutopt:orientation:top, default:true"
          # mail
          "7,   monitor:DP-2, layoutopt:orientation:top"
          # sound + bluetooth
          "8,   monitor:DP-2, layoutopt:orientation:top"
          "9,   monitor:DP-2, layoutopt:orientation:top"
          "10,  monitor:DP-2, layoutopt:orientation:top"
        ];

        windowrulev2 = [
          "workspace 3 silent,  class:^steam$"
          "workspace 3 silent,  class:^heroic$"
          # add steam games to ws 6
          "workspace 5 silent,  class:(steam_app_*)"
          "monitor 0,           class:(steam_app_*)"
          # "fullscreen,          class:(steam_app_*)"

          "workspace 6 silent,  class:^signal$"
          "workspace 6 silent,  class:^Signal$"
          "workspace 6 silent,  class:^discord$"
          "workspace 6 silent,  class:^Discord$"
          "workspace 6 silent,  class:^WebCord$"
          "workspace 6 silent,  class:^vesktop$"
          "workspace 6 silent,  title:^Microsoft Teams*$"
          "tile,                title:^Microsoft Teams*$"

          "workspace 7 silent,  class:^ch.proton.bridge-gui$"
          "workspace 7 silent,  class:^thunderbird$"

          "workspace 8 silent,  class:^Spotify$"
          "workspace 8 silent,  class:^blueman-manager$"
          "workspace 8 silent,  class:^easyeffects$"

          "workspace 9 silent,  class:^org.corectrl.CoreCtrl$"

          "float, class:^org.gnome.Calculator$"
          "float, title:^Friends List$"
        ];

        env = [
          "XCURSOR_SIZE,24"
          "HYPRCURSOR_SIZE,24"
          "HYPRCURSOR_THEME,Adwaita"
          "SSH_AUTH_SOCK,$XDG_RUNTIME_DIR/keyring/ssh"
          # "QT_QPA_PLATFORM,wayland"
          "GDK_SCALE,1.25"
          "QT_SCALE,1.25"
        ];
      };
    };
  };

  # NOTE(aver): possibly superfluous, as achieved by nixos-hardware
  hardware.graphics = {
    extraPackages = with pkgs;
      [
        amdvlk
        # add OpenCL support, or just rely on the amgpu module from `nixos-hardware`
        # rocmPackages.clr.icd
        # clinfo
      ];
    extraPackages32 = with pkgs; [ driversi686Linux.amdvlk ];
    enable32Bit = true;
  };

  environment.systemPackages = with pkgs; [
    vulkan-tools
    ddcui
    nvtopPackages.amd
    radeontop
  ];

  # define default driver
  environment.variables.AMD_VULKAN_ICD = "RADV";

}
