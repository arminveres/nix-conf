{ pkgs, lib, config, ... }: {
  options = {
    desktop.enable = lib.mkEnableOption
      "enables Home-Manager Desktop module, which includes basic tools to work with a GUI based system.";
  };

  config = lib.mkIf config.desktop.enable {
    home.packages = with pkgs; [
      firefox # browser
      alacritty # terminal
      # ghostty  # TODO(aver): 18-07-2025 seems to have some weird loading issues
      nautilus # filebrowser
      baobab # disk usage
      networkmanagerapplet # network tools
      pavucontrol # audio system tray
      solaar # logitech peripherals
      thunderbird # email client
      mission-center
    ];
  };
}
