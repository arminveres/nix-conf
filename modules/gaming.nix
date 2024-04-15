{ pkgs, lib, config, ... }:
{
  options = {
    gaming.enable = lib.mkEnableOption "enables Nix Gaming module";
  };

  config = lib.mkIf config.gaming.enable {
    environment.systemPackages = with pkgs; [
      linuxKernel.packages.linux_6_6.xone
    ];

    programs.steam = {
      enable = true;
      remotePlay.openFirewall = true;
      dedicatedServer.openFirewall = true;
    };

    # TODO(aver): move to separate nix file
    programs.corectrl.enable = true;
    programs.corectrl.gpuOverclock.enable = true;
  };
}
