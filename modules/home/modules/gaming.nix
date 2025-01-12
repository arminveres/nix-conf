{ pkgs, lib, config, ... }: {
  options = { gaming.enable = lib.mkEnableOption "enables Home-Manager Gaming module"; };

  config = lib.mkIf config.gaming.enable {
    home.packages = with pkgs; [
      # TODO(aver): move games into separate dir
      mangohud
      heroic # heroic game launcher
      protonup-qt
    ];
  };
}
