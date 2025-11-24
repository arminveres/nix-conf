{ pkgs, lib, config, ... }: {
  options.rustenv.enable =
    lib.mkEnableOption "enables Home-Manager RustEnv module";

  config = lib.mkIf config.rustenv.enable {
    home.packages = with pkgs; [
      rustup
      cargo-cache
      cargo-binstall
      cargo-update
    ];
  };
}
