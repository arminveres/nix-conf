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
          "1, monitor:DP-1, default:true"
          "2, monitor:DP-1"
          "3, monitor:DP-1"
          "4, monitor:DP-1"
          "5, monitor:DP-1"
          "6, monitor:DP-1"
          "7, monitor:DP-1"
          "8, monitor:DP-1"
          "9, monitor:DP-1"
          # use this as a kind of scratchpad
          "10, monitor:DP-2, default:true"
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
