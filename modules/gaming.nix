{ pkgs, lib, config, ... }:
{
  options = {
    gaming.enable = lib.mkEnableOption "enables Nix Gaming module";
  };

  config = lib.mkIf config.gaming.enable {
    environment.systemPackages = with pkgs; [
      linuxKernel.packages.linux_6_6.xone
      lact
    ];
    systemd.packages = with pkgs; [
      lact
    ];
    systemd.services.lactd.wantedBy = [ "multi-user.target" ];

    programs = {
      steam = {
        enable = true;
        remotePlay.openFirewall = true;
        dedicatedServer.openFirewall = true;
        gamescopeSession.enable = true;
      };

      gamemode.enable = true;

      # TODO(aver): move to separate nix file
      corectrl = {
        enable = true;
        gpuOverclock.enable = true;
      };
    };
  };
}
