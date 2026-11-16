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
  # link dotfiles/<pkg>/.local/bin/<name> to ~/.local/bin/<name>
  linkBin = pkg: name: {
    ".local/bin/${name}".source =
      config.lib.file.mkOutOfStoreSymlink "${systemSettings.homeDirectory}/nix-conf/dotfiles/${pkg}/.local/bin/${name}";
  };
in
{
  inherit
    link
    linkSubDir
    linkFile
    linkDir
    linkBin
    ;
}
