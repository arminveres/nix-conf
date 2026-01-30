{ pkgs, lib, config, ... }:
{
  options.ave = {
    latex.enable = lib.mkEnableOption "enables Home-Manager Latex module";
  };

  config = lib.mkIf config.ave.latex.enable {

    home.packages = with pkgs; [
      pandoc
      inkscape
  texlive.combined.scheme-full
    ];

    # programs.texlive = {
    #   enable = true;
    # };
  };
}
