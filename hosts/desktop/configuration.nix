{ userSettings, pkgs, ... }: {
  imports = [ ../../modules ];
  gaming.enable = true;
  fm.enable = true;

  home-manager.users.${userSettings.username} = {
    neovim.enable = true;
    gaming.enable = true;
    hyprlandwm = {
      enable = true;
      displayConfig = {
        monitor = [
          "DP-1, 3440x1440@160, 0x0, 1"
          "DP-2, 1920x1200@60,  3440x0, 1, transform, 3"
        ];
      };
    };
    latex.enable = true;
  };

  # NOTE(aver): possibly superfluous, as achieved by nixos-hardware
  hardware.opengl = {
    driSupport = true;
    extraPackages = with pkgs;[
      amdvlk
      # add OpenCL support
      # rocmPackages.clr.icd
      # clinfo
    ];
    driSupport32Bit = true;
    extraPackages32 = with pkgs;[ driversi686Linux.amdvlk ];
  };
}
