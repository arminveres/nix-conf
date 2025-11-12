{ pkgs, lib, config, ... }:
{
  options = {
    latex.enable = lib.mkEnableOption "enables Home-Manager Latex module";
  };

  config = lib.mkIf config.latex.enable {

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
