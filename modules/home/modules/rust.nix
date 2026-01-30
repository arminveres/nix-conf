{ pkgs, lib, config, ... }: {
  options.ave.rustenv.enable =
    lib.mkEnableOption "enables Home-Manager RustEnv module";

  config = lib.mkIf config.ave.rustenv.enable {
    home.packages = with pkgs; [
      rustup
      cargo-cache
      cargo-binstall
      cargo-update
    ];
  };
}
