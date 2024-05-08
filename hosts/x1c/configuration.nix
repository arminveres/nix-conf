{ userSettings, ... }: {
  imports = [ ../../modules ];
  printing.enable = true;
  home-manager.users.${userSettings.username} = {
    gaming.enable = false;
    hyprlandwm = {
      enable = true;
      displayConfig = {
        monitor = [ ",preferred,auto,1.0" ];
      };
    };
    latex.enable = true;
    services.blueman-applet.enable = true;
  };
  services.blueman.enable = true;
}
