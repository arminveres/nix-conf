{ pkgs, lib, config, ... }:
{
  options = {
    fm.enable = lib.mkEnableOption "enables Nix File Manager module";
  };

  config = lib.mkIf config.fm.enable {
    environment.systemPackages = with pkgs; [
      xfce.exo
    ];
    programs.thunar = {
      enable = true;
      plugins = with pkgs.xfce; [ thunar-archive-plugin thunar-volman ];
    };
    services.gvfs.enable = true; # Mount, trash, and other functionalities
    services.tumbler.enable = true; # Thumbnail support for images
    services.samba.enable = true;
    programs.xfconf.enable = true; # enable saving changed
  };
}
