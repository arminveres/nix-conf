{ pkgs, systemSettings, userSettings , ...}:

{
  home.username = userSettings.username;
  home.homeDirectory = "/home/" + userSettings.username;
  programs.home-manager.enable = true;
  home.stateVersion = "23.11";

  xdg.enable = true;
  xdg.userDirs = {
    enable = true;
    createDirectories = true;
  };
  xdg.mime.enable = true;
  xdg.mimeApps.enable = true;

}
