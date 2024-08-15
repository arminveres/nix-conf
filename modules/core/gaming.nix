{ pkgs, lib, config, systemSettings, ... }: {
  options = {
    gaming.enable = lib.mkEnableOption "enables Nix Gaming module";
  };

  config = lib.mkIf config.gaming.enable {
    environment.systemPackages = with pkgs; [
      linuxKernel.packages."linux_${systemSettings.kernelVersion}".xone
      # vkbasalt # A Vulkan post processing layer for Linux
      # this may be missing for some games on steam
      SDL2
    ];

    # systemd.packages = with pkgs; [ lact ];
    # systemd.services.lactd.wantedBy = [ "multi-user.target" ];

    programs = {
      steam = {
        enable = true;
        remotePlay.openFirewall = true;
        dedicatedServer.openFirewall = true;
        gamescopeSession.enable = true;
      };

      gamemode.enable = true;
      gamescope.enable = true;

      # TODO(aver): move to separate nix file
      corectrl = {
        enable = true;
        gpuOverclock.enable = true;
      };
    };
  };
}
