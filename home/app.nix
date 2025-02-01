{ config, pkgs, ... }:
{
  home.packages = with pkgs; [
    devbox
    sl
    bat
    jq
    ripgrep
    fd
    duf
    gitflow
    ffmpeg
    silicon
    unrar
    lua5_4
    zoxide
    uv
    imagemagick
    vim-startuptime
    zenn-cli
    btop
    mactop
  ];

  programs.git = {
    enable = true;
    userName = "glassesneo";
    userEmail = "glassesneo@protonmail.com";
    delta.enable = true;
    extraConfig = {
      commit = {
        template = "${config.xdg.configHome}/git/.gitmsg";
      };
      core = {
        editor = "nvim";
      };
      init = {
        defaultBranch = "main";
      };
    };
    ignores = [
      "*~"
      "*.swp"
      ".DS_Store"
      ".direnv"
      ".envrc"
    ];
  };

  programs.git-cliff = {
    enable = true;
    settings = {
      changelog = {
        header = ''
          # Change Log
          All notable changes to this project will be documented in this file.
        '';
      };
      git = {
        conventional_commits = true;
        filter_unconventional = true;
        commit_parsers = [
          {
            message = "^feat";
            group = "Features";
          }
          {
            message = "^fix";
            group = "Bug Fixes";
          }
          {
            message = "^doc";
            group = "Documentation";
          }
          {
            message = "^perf";
            group = "Performance";
          }
          {
            message = "^refactor";
            group = "Refactor";
          }
          {
            message = "^style";
            group = "Styling";
          }
          {
            message = "^test";
            group = "Testing";
          }
        ];
        tag_pattern = "[0-9].*";
      };
    };
  };

  programs.gh = {
    enable = true;
    extensions = with pkgs; [ gh-markdown-preview ];
    settings = {
      git_protocol = "https";
      prompt = "enabled";
    };
  };

  programs.zsh = {
    enable = true;
    dotDir = ".config/zsh";
    enableCompletion = true;
    syntaxHighlighting.enable = true;
    autosuggestion.enable = true;
    autocd = true;
    shellAliases = {
      ls = "eza";
      bd = "cd ..";
      tree = "eza --tree";
    };
    shellGlobalAliases = {
      projectroot = "`git rev-parse --show-toplevel`";
    };
    initExtra = ''
      # 組み込みコマンドを使うためのpath
      PATH=/bin:/usr/bin:/usr/local/bin:$PATH

      # nix
      export PATH=/nix/var/nix/profiles/default/bin:~/.nix-profile/bin:$PATH

      setopt +o nomatch

      eval "$(starship init zsh)"
    '';
    envExtra = ''
      export XDG_DATA_HOME=$HOME/.local/share/
      export XDG_CONFIG_HOME=$HOME/.config/
      export XDG_STATE_HOME=$HOME/.local/state/
      export XDG_CACHE_HOME=$HOME/.cache/

      export NIX_PATH=$HOME/.nix-defexpr/channels

      if [ -e '/nix/var/nix/profiles/default/etc/profile.d/nix-daemon.sh' ]; then
        . '/nix/var/nix/profiles/default/etc/profile.d/nix-daemon.sh'
      fi
    '';
    history = {
      extended = true;
      size = 10000;
      path = "${config.xdg.stateHome}/zsh/history";
    };
  };

  programs.direnv = {
    enable = true;
  };

  programs.starship = {
    enable = true;
    settings = {
      "$schema" = "https://starship.rs/config-schema.json";
      scan_timeout = 10;
      format = ''
        [┌⦘](bold green)$all
        [│](bold green)$character $directory
        [└────>](bold green) 
      '';
      add_newline = true;
      character = {
        error_symbol = "[:\\(](bold red)";
        success_symbol = "[:D](bold green)";
      };
      directory = {
        truncation_length = 0;
        truncate_to_repo = false;
      };
      line_break = {
        disabled = true;
      };
      username = {
        style_user = "pink bold";
        style_root = "black bold";
        format = "[$user⚜️ ]($style) ";
        disabled = false;
        show_always = true;
      };
      cmd_duration = {
        show_notifications = true;
      };
    };
  };

  programs.neovim = {
    enable = true;
    extraLuaConfig = builtins.readFile ../dotfiles/nvim/init.lua;
    extraPackages = with pkgs; [
      # lsp
      efm-langserver
      vim-language-server
      #typescript
      biome
      typescript-language-server
      svelte-language-server
      tailwindcss-language-server
      # tree-sitter
      tree-sitter
      # denops
      deno
      # tree-sitter
      gcc
      # nim
      nimlangserver
      # nix
      nil
      nixfmt-rfc-style
      # scala
      scalafmt
      metals
      # lua
      lua-language-server
      stylua
      # toml
      taplo
      # markdown
      marksman
      # python
      pylyzer
      ruff
      # kotlin
      kotlin-language-server
      ktfmt
      # zig
      zls
    ];
    withNodeJs = false;
    withPython3 = false;
    withRuby = false;
  };

  programs.eza = {
    enable = true;
    git = true;
    icons = true;
  };
}
