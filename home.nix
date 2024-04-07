{ config, pkgs, pkgs-stable, systemSettings, userSettings, split-monitor-workspaces, ... }:

{
  programs = {
    home-manager.enable = true;
  };


  home.packages = with pkgs; [
    dconf
    colloid-gtk-theme
    colloid-icon-theme
    gnome.adwaita-icon-theme
    signal-desktop
    beeper
    discord
    neovide
    kanshi
    wlogout
    pulseaudio
    pavucontrol
    wdisplays
    mission-center
    gh
    eza
    rustup
    tldr
  ];

  home.username = userSettings.username;
  home.homeDirectory = "/home/" + userSettings.username;
  home.stateVersion = "23.11";

  xdg.enable = true;
  xdg.userDirs = {
    enable = true;
    createDirectories = true;
  };
  xdg.mime.enable = true;
  xdg.mimeApps.enable = true;
  xdg.configFile = {
    "gtk-4.0/assets".source = "${config.gtk.theme.package}/share/themes/${config.gtk.theme.name}/gtk-4.0/assets";
    "gtk-4.0/gtk.css".source = "${config.gtk.theme.package}/share/themes/${config.gtk.theme.name}/gtk-4.0/gtk.css";
    "gtk-4.0/gtk-dark.css".source = "${config.gtk.theme.package}/share/themes/${config.gtk.theme.name}/gtk-4.0/gtk-dark.css";
  };

  dconf = {
    enable = true;
    settings = {
      "org/gnome/desktop/interface" = {
        color-scheme = "prefer-dark";
      };
    };
  };

  gtk = {
    enable = true;
    theme = {
      name = "Colloid-Dark";
      package = pkgs.colloid-gtk-theme;
    };
    iconTheme = {
      name = "Adwaita";
      package = pkgs.gnome.adwaita-icon-theme;
    };
    cursorTheme = {
      name = "Adwaita";
      package = pkgs.gnome.adwaita-icon-theme;
    };
  };
  home.sessionVariables = { GTK_THEME = "Colloid-Dark"; };

  services.gpg-agent = {
    enable = true;
    enableSshSupport = true;
  };

  wayland.windowManager.hyprland = {
    # ...
    plugins = [
      split-monitor-workspaces.packages.${pkgs.system}.split-monitor-workspaces
    ];
    # ...
  };
}
