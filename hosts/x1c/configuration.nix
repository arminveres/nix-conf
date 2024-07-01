{ userSettings, ... }: {
  imports = [ ../../modules ];
  printing.enable = true;
  fm.enable = true;

  home-manager.users.${userSettings.username} = {
    neovim.enable = true;
    gaming.enable = false;
    hyprlandwm = {
      enable = true;
      hostConfig = {
        monitor = [ ",preferred,auto,1.0" ];
        decoration = {
          blur.enabled = false;
          drop_shadow = false;
        };
      };
    };
    latex.enable = true;
    services.blueman-applet.enable = true;
  };
  services.blueman.enable = true;
}
