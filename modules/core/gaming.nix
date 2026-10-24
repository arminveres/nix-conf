{
  inputs,
  pkgs,
  lib,
  config,
  systemSettings,
  ...
}:
{

  options = {
    gaming.enable = lib.mkEnableOption "enables Nix Gaming module";
  };

  config = lib.mkIf config.gaming.enable {
    environment.systemPackages = with pkgs; [
      # vkbasalt # A Vulkan post processing layer for Linux
      # this may be missing for some games on steam
      SDL2
      # BUG(AVE): reenable
      # inputs.dzgui-nix.packages.${systemSettings.system}.default
      # NOTE: not sure it is needed anymore.
      # linuxKernel.packages."linux_${systemSettings.kernelVersion}".xone
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

      corectrl.enable = true;
    };

    # TODO(aver): There should be a group called corectrl and if we add the users to that group, we
    # don't need this snipped here, see: https://github.com/NixOS/nixpkgs/blob/master/nixos/modules/hardware/corectrl.nix
    security.polkit.extraConfig = ''
      polkit.addRule(function(action, subject) {
          if ((action.id == "org.corectrl.helper.init" ||
               action.id == "org.corectrl.helperkiller.init") &&
              subject.local == true &&
              subject.active == true &&
              subject.isInGroup("users")) {
                  return polkit.Result.YES;
          }
      });
    '';

    # Enable XBOX controller firmware
    hardware.xone.enable = true;
    # TODO: reenable once 10.22 is merged to unstable nixpkgs
    hardware.xpad-noone.enable = false;
  };
}
