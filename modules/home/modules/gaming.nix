{ pkgs, lib, config, ... }:
let getXDpi = scalingFactor: toString (builtins.floor (96 * scalingFactor));
in {
  options.ave = {
    gaming.enable = lib.mkEnableOption "enables Home-Manager Gaming module";
  };

  config = lib.mkIf config.ave.gaming.enable {
    home.packages = with pkgs; [
      # TODO(aver): move games into separate dir
      mangohud
      heroic # heroic game launcher
      # protonup-qt
      protonplus
      xorg.xrdb
    ];
    # ensure that steam is scaled. Base is 96, multiply with whatever scaling
    xresources.extraConfig = "Xft.dpi: ${getXDpi 1.5}";
  };
}
