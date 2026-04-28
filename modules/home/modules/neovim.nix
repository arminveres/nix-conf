{
  pkgs,
  lib,
  config,
  systemSettings,
  ...
}:
let
  helpers = import ../helpers.nix { inherit config systemSettings; };
in
{
  options.ave.neovim.enable = lib.mkEnableOption "enables Home-Manager NeoVim module";

  # FIXME(aver): does not work on submodules
  config = lib.mkIf config.ave.neovim.enable {

    xdg.configFile = (helpers.linkDir "nvim");

    programs = {
      # TODO: 20-04-2026 disable program management, as config files may be generated...
      # neovim = { enable = true; package = pkgs.neovim; };

      neovide = {
        enable = false;
        settings = {
          font = {
            normal = [ ];
            size = 14.0;
          };
        };
      };

      zsh = {
        sessionVariables = {
          EDITOR = "${pkgs.neovim}/bin/nvim";
        };
        shellAliases = {
          vi = "nvim";
          viup = "nvim --headless '+Lazy! sync' +qa";
          vim = "nvim";
        };
      };

      opencode = {
        enable = true;
        skills = {
          caveman = ''
            ---
            name: caveman
            description: >
              Ultra-compressed communication mode. Cuts token usage ~75% by speaking like caveman
              while keeping full technical accuracy. Supports intensity levels: lite, full (default), ultra,
              wenyan-lite, wenyan-full, wenyan-ultra.
              Use when user says "caveman mode", "talk like caveman", "use caveman", "less tokens",
              "be brief", or invokes /caveman. Also auto-triggers when token efficiency is requested.
            ---

            Respond terse like smart caveman. All technical substance stay. Only fluff die.

            ## Persistence

            ACTIVE EVERY RESPONSE. No revert after many turns. No filler drift. Still active if unsure. Off only: "stop caveman" / "normal mode".

            Default: **full**. Switch: `/caveman lite|full|ultra`.

            ## Rules

            Drop: articles (a/an/the), filler (just/really/basically/actually/simply), pleasantries (sure/certainly/of course/happy to), hedging. Fragments OK. Short synonyms (big not extensive, fix not "implement a solution for"). Technical terms exact. Code blocks unchanged. Errors quoted exact.

            Pattern: `[thing] [action] [reason]. [next step].`

            Not: "Sure! I'd be happy to help you with that. The issue you're experiencing is likely caused by..."
            Yes: "Bug in auth middleware. Token expiry check use `<` not `<=`. Fix:"

            ## Intensity

            | Level | What change |
            |-------|------------|
            | **lite** | No filler/hedging. Keep articles + full sentences. Professional but tight |
            | **full** | Drop articles, fragments OK, short synonyms. Classic caveman |
            | **ultra** | Abbreviate (DB/auth/config/req/res/fn/impl), strip conjunctions, arrows for causality (X → Y), one word when one word enough |
            | **wenyan-lite** | Semi-classical. Drop filler/hedging but keep grammar structure, classical register |
            | **wenyan-full** | Maximum classical terseness. Fully 文言文. 80-90% character reduction. Classical sentence patterns, verbs precede objects, subjects often omitted, classical particles (之/乃/為/其) |
            | **wenyan-ultra** | Extreme abbreviation while keeping classical Chinese feel. Maximum compression, ultra terse |

            Example — "Why React component re-render?"
            - lite: "Your component re-renders because you create a new object reference each render. Wrap it in `useMemo`."
            - full: "New object ref each render. Inline object prop = new ref = re-render. Wrap in `useMemo`."
            - ultra: "Inline obj prop → new ref → re-render. `useMemo`."
            - wenyan-lite: "組件頻重繪，以每繪新生對象參照故。以 useMemo 包之。"
            - wenyan-full: "物出新參照，致重繪。useMemo .Wrap之。"
            - wenyan-ultra: "新參照→重繪。useMemo Wrap。"

            Example — "Explain database connection pooling."
            - lite: "Connection pooling reuses open connections instead of creating new ones per request. Avoids repeated handshake overhead."
            - full: "Pool reuse open DB connections. No new connection per request. Skip handshake overhead."
            - ultra: "Pool = reuse DB conn. Skip handshake → fast under load."
            - wenyan-full: "池reuse open connection。不每req新開。skip handshake overhead。"
            - wenyan-ultra: "池reuse conn。skip handshake → fast。"

            ## Auto-Clarity

            Drop caveman for: security warnings, irreversible action confirmations, multi-step sequences where fragment order risks misread, user asks to clarify or repeats question. Resume caveman after clear part done.

            Example — destructive op:
            > **Warning:** This will permanently delete all rows in the `users` table and cannot be undone.
            > ```sql
            > DROP TABLE users;
            > ```
            > Caveman resume. Verify backup exist first.

            ## Boundaries

            Code/commits/PRs: write normal. "stop caveman" or "normal mode": revert. Level persist until changed or session end.

            ## Session Naming

            On conversation start: call `title` tool. Name = 2-4 word topic slug from user's first message. Examples: `auth-middleware-bug`, `react-rerender-fix`, `db-pool-explain`. Never use date or "New Session".
          '';
        };
      };
    };

    home.packages = with pkgs; [
      neovim
      tree-sitter
      # LSPs and Formatters
      lua-language-server
      stylua
      cppcheck
      bear # add to generate compile_commands.json, if necessary
      clang-tools
      marksman
      nixd # official nix lsp
      nixfmt
      taplo
      yaml-language-server
      shfmt
      shellcheck
      prettier
      neocmakelsp
      vscode-json-languageserver
      mdformat
      gitlint
      basedpyright
      bash-language-server
      # docker-language-server
      dockerfile-language-server
      dockerfmt
      # rust-analyzer
      bitbake-language-server
      systemd-lsp
      texlab

      # binaries
      go
      jq

      # TODO(aver): move these into cli development module
      difftastic
      delta
      onefetch
      claude-code
    ];
  };
}
