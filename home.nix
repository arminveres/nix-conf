{ inputs
, config
, pkgs
, userSettings
, split-monitor-workspaces
, ...
}:

{
  programs = {
    home-manager.enable = true;
  };

  home.packages = with pkgs; [
    dconf
    (
      colloid-gtk-theme.override {
        themeVariants = [ "orange" ];
        colorVariants = [ "dark" ];
        tweaks = [ "black" "rimless" "normal" ];
      }
    )
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
    nextcloud-client
    spotify
    gnome.nautilus
    # TODO(aver): move games into separate dir
    gamemode
    mangohud
    qmk
  ];

  home.username = userSettings.username;
  home.homeDirectory = "/home/" + userSettings.username;
  home.stateVersion = "23.11";

  xdg = {
    enable = true;
    portal = {
      enable = true;
      extraPortals = [
        pkgs.xdg-desktop-portal-gtk
        pkgs.xdg-desktop-portal-hyprland
      ];
    };
    userDirs = {
      enable = true;
      createDirectories = true;
    };
    mime.enable = true;
    mimeApps.enable = true;
    mimeApps.defaultApplications = {
      "x-scheme-handler/mailto" = "userapp-Thunderbird-MLTWL2.desktop";
      "message/rfc822" = "userapp-Thunderbird-MLTWL2.desktop";
      "x-scheme-handler/mid" = "userapp-Thunderbird-MLTWL2.desktop";
    };
    mimeApps.associations.added = {
      "x-scheme-handler/mailto" = "userapp-Thunderbird-MLTWL2.desktop";
      "x-scheme-handler/mid" = "userapp-Thunderbird-MLTWL2.desktop";
    };
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
      name = "Colloid-Orange-Dark";
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
  home.sessionVariables = { GTK_THEME = "Colloid-Orange-Dark"; };


  wayland.windowManager.hyprland = {
    enable = true;
    systemd.enable = true;
    xwayland.enable = true;
    package = inputs.hyprland.packages.${pkgs.system}.hyprland;
    plugins = [
      split-monitor-workspaces.packages.${pkgs.system}.split-monitor-workspaces
    ];
    extraConfig = builtins.readFile ./hyprland.conf;
  };
}
