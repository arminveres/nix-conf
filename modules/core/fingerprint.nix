{ pkgs, lib, config, ... }: {
  options = {
    fingerprint.enable = lib.mkEnableOption "enables Nix fingerprint module";
  };

  config = lib.mkIf config.fingerprint.enable {
    services.fprintd = {
      enable = true;
      tod.enable = true;
      tod.driver = pkgs.libfprint-2-tod1-elan;
    };
  };
}

