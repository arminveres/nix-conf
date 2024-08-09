{ userSettings, pkgs, ... }: {
  imports = [ ../../modules/core ];

  gaming.enable = true;
  fm.enable = true;
  bluetooth.enable = true;

  home-manager.users.${userSettings.username} = {
    neovim.enable = true;
    gaming.enable = true;
    hyprlandwm = {
      enable = true;
      hostConfig = {
        monitor = [
          # "HDMI-A-2,    3840x2160@120,  0x0,    1.25"
          # "HDMI-A-1,    3840x2160@120,  0x0,    1.25"
          "DP-1,        3440x1440@160,  0x0,    1,  bitdepth,   10"
          "DP-2,        1920x1200@60,   3440x0, 1,  transform,  3"
        ];
        decoration = {
          blur.enabled = true;
          drop_shadow = true;
        };
        workspace = [
          # code
          "1,   monitor:DP-1, default:true"
          # web
          "2,   monitor:DP-1"
          # mail + research
          "3,   monitor:DP-1"
          # steam
          "4,   monitor:DP-1"
          "5,   monitor:DP-1"
          # messages
          "6,   monitor:DP-2, layoutopt:orientation:top, default:true"
          # sound + bluetooth
          "7,   monitor:DP-2, layoutopt:orientation:top"
          "8,   monitor:DP-2, layoutopt:orientation:top"
          "9,   monitor:DP-2, layoutopt:orientation:top"
          "10,  monitor:DP-2, layoutopt:orientation:top"
        ];

        windowrulev2 = [
          "workspace 3 silent,  class:^easyeffects$"
          "workspace 3 silent,  class:^thunderbird$"
          "workspace 3 silent,  class:^ch.proton.bridge-gui$"

          "workspace 4 silent,  class:^steam$"
          # add steam games to ws 6
          "workspace 5 silent,  class:^steam_app_\d*$"
          "monitor 1,           class:^steam_app_\d*$"
          "fullscreen,          class:^steam_app_\d*$"

          "workspace 6 silent,  class:^signal$"
          "workspace 6 silent,  class:^Signal$"
          "workspace 6 silent,  class:^discord$"
          "workspace 6 silent,  class:^Discord$"
          "workspace 6 silent,  class:^WebCord$"
          "workspace 6 silent,  title:^Microsoft Teams*$"
          "tile,                title:^Microsoft Teams*$"

          "workspace 7 silent,  class:^Spotify$"
          "workspace 7 silent,  class:^blueman-manager$"

          "float, class:^org.gnome.Calculator$"
        ];
      };
    };
    latex.enable = true;
  };

  # NOTE(aver): possibly superfluous, as achieved by nixos-hardware
  hardware.graphics = {
    # WARN(aver): option deprecated, ord broken?
    # driSupport = true;
    extraPackages = with pkgs;[
      amdvlk
      # add OpenCL support, or just rely on the amgpu module from `nixos-hardware`
      # rocmPackages.clr.icd
      # clinfo
    ];
    extraPackages32 = with pkgs;[ driversi686Linux.amdvlk ];
    enable32Bit = true;
  };

  environment.systemPackages = with pkgs; [
    ddcui
  ];

}
