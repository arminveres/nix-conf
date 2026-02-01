{ config, systemSettings, ... }:
let
  toSrcFile = name: "${systemSettings.homeDirectory}/nix-conf/dotfiles/${name}/.config/${name}";
  link = name: config.lib.file.mkOutOfStoreSymlink (toSrcFile name);
  linkSubDir = name: subdir: config.lib.file.mkOutOfStoreSymlink "${toSrcFile name}/${subdir}";
  linkFile = name: { ${name}.source = link name; };
  linkDir = name: {
    ${name} = {
      source = link name;
      recursive = true;
    };
  };
in
{
  inherit
    link
    linkSubDir
    linkFile
    linkDir
    ;
}
