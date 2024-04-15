{ pkgs, lib, config, ... }:
{
  imports = [ ./gaming.nix ];
  gaming.enable = lib.mkDefault false;
}
