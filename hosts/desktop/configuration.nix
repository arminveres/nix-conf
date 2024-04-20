{ userSettings, ... }: {
  imports = [ ../../modules ];
  gaming.enable = true;
  home-manager.users.${userSettings.username} = {
    gaming.enable = true;
    hyprlandwm = {
      enable = true;
      displayConfig = {
        monitor = [
          "DP-1,3440x1440@160,0x0,1.0"
          "DP-2,1920x1200@60,3440x0,1.0,transform,3"
        ];
      };
    };
  };
}
