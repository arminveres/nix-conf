{ userSettings, pkgs, ... }: {
  imports = [ ../../modules ];
  gaming.enable = true;
  fm.enable = true;

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
      };
    };
    latex.enable = true;
  };

  # NOTE(aver): possibly superfluous, as achieved by nixos-hardware
  hardware.opengl = {
    # WARN(aver): option deprecated, ord broken?
    # driSupport = true;
    extraPackages = with pkgs;[
      amdvlk
      # add OpenCL support, or just rely on the amgpu module from `nixos-hardware`
      # rocmPackages.clr.icd
      # clinfo
    ];
    driSupport32Bit = true;
    extraPackages32 = with pkgs;[ driversi686Linux.amdvlk ];
  };

  environment.systemPackages = with pkgs; [
    ddcui
  ];

}
