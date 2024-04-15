{ userSettings, ... }: {
  imports = [ ../../modules ];
  gaming.enable = true;
  home-manager.users.${userSettings.username} = {
    gaming.enable = true;
    hyprlandwm.enable = true;
  };
}
