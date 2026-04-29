{
  inputs,
  lib,
  overlays,
  pkgs,
  systemSettings,
  ...
}:
{
  nixpkgs.overlays = overlays;

  home = {
    # ensure that external GUIs also inherit this path, e.g., neovide
    sessionPath = [
      "$HOME/.nix-profile/bin"
      "/nix/var/nix/profiles/default/bin"
    ];

    packages =
      with pkgs;
      [
        devbox
      ]
      ++ [
        inputs.pwndbg.packages.${systemSettings.system}.pwndbg
      ];
  };

  ave = {
    zsh.enable = true;
    neovim.enable = true;
    terminal-tools.enable = true;
  };

  programs = {
    nh.homeFlake = "${systemSettings.homeDirectory}/nix-conf?submodules=1";
    zsh = {
      shellAliases = {
        # hswitch = "home-manager switch -b backup --flake \"${systemSettings.homeDirectory}/nix-conf?submodules=1#ubuntu-cli\" --verbose";
        hswitch = "nh home switch --configuration ubuntu-cli";
      };
      sessionVariables = {
        # In WSL we do not have this variable set, resulting in wrong colors.
        COLORTERM = "truecolor";
      };

      # ensure that even without system wide zsh installation we include completions
      completionInit = lib.mkBefore ''
        fpath+=(
          /usr/share/zsh/site-functions
          /usr/share/zsh/vendor-completions
        )
      '';
    };
    keychain.keys = [
      "id_rsa"
      "gh"
    ];
  };

}
