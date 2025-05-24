{ pkgs, lib, config, systemSettings, ... }: {
  options = {
    docker.enable = lib.mkEnableOption "enables Nix Docker module";
  };

  config = lib.mkIf config.docker.enable {
    environment.systemPackages = with pkgs; [
      lazydocker
      docker-compose
    ];

    virtualisation.docker = {
      enable = true;
    };

    users.users.${systemSettings.username}.extraGroups = lib.mkAfter [ "docker" ];
  };
}
