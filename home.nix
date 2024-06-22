{ config, lib, pkgs, username, hostname, ... }:
let respectiveConfig = import ./hosts/${hostname}.nix;
in
  lib.recursiveUpdate
  {
    # this is internal compatibility configuration 
    # for home-manager, don't change this!
    xdg.enable = true;

    home.stateVersion = "24.11";
    # Let home-manager install and manage itself.
    programs.home-manager.enable = true;

    home.sessionVariables = {
      EDITOR = "nvim";
    };

    home.packages = [
      pkgs.sl
      pkgs.bat
      pkgs.ripgrep
      pkgs.fd
      pkgs.duf
      pkgs.tree
      pkgs.deno
      pkgs.nim2
      pkgs.nimble
    ];

    programs.git = {
      enable = true;
      userName = "glassesneo";
      userEmail = "glassesneo@protonmail.com";
      extraConfig = {
        commit = {
          template = "/Users/neo/.config/git/.gitmsg";
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
      ];
    };

    programs.gh = {
      enable = true;
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
      initExtra = ''
# 組み込みコマンドを使うためのpath
  PATH=/bin:/usr/bin:/usr/local/bin:$PATH

# nix
  export PATH=/nix/var/nix/profiles/default/bin:~/.nix-profile/bin:$PATH

# zsh-completions 設定
  if [ -e /usr/local/share/zsh-completions ]; then
      fpath=(/usr/local/share/zsh-completions $fpath)
  fi

# prompt
  PROMPT='%F{yellow}%n:%m%f %F{cyan}%c%f %F{red}|>%f '

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
      profileExtra = ''
  eval $(/opt/homebrew/bin/brew shellenv)
  '';
      history = {
        extended = true;
        size = 10000;
        path = "${config.xdg.stateHome}/zsh/history";
      };
    };

    programs.starship = {
      enable = true;
      settings = {
        "$schema" = "https://starship.rs/config-schema.json";
        scan_timeout = 10;
        format = ''
  $all$character$directory
  '';
        add_newline = false;
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
      };
    };

    programs.neovim = {
      enable = true;
      extraLuaConfig = builtins.readFile ./dotfiles/nvim/init.lua;
      extraPackages = [
        # nix
        pkgs.nil
        pkgs.nixpkgs-fmt
        # lua
        pkgs.lua-language-server
        pkgs.stylua
        # toml
        pkgs.taplo
      ];
    };

    programs.eza = {
      enable = true;
      git = true;
      icons = true;
    };

    xdg.configFile = {
      ".gitmsg" = {
        text = ''
# ==== Emojis ====
# 🎉  :tada: Initial Commit
# ✨  :sparkles: New Feature
# 🐛  :bug: Bugfix
# ♼  :recycle: Refactor
# 👕 :shirt: Style
# 📖  :books: Docs
# ⚡️  :zap: Performance
# ✅  :white_check_mark: Test
# 🍰  :cake: Chore
# 💥  :boom: Breaking Changes
# 🔖  :bookmark: Release / Version Tag
        '';
      };
      "nvim" = {
        source = ./dotfiles/nvim;
        recursive = true;
      };
    };

    home.shellAliases = {
      ls = "eza";
      bd = "cd ..";
    };
  } respectiveConfig
