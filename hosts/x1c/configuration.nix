{ userSettings, ... }: {
  imports = [ ../../modules ];
  gaming.enable = true;
  printing.enable = true;
  home-manager.users.${userSettings.username} = {
    gaming.enable = false;
    hyprlandwm = {
      enable = true;
      displayConfig = {
        monitor = [ ",preferred,auto,1.0" ];
      };
    };
  };
}
