{ config, pkgs, ... }:
{
  home.packages = with pkgs; [
    sl
    nixpkgs-fmt
    bat
    ripgrep
    fd
    duf
    deno
    gitflow
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
    ];
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
    history = {
      extended = true;
      size = 10000;
      path = "${config.xdg.stateHome}/zsh/history";
    };
  };

  programs.direnv = {
    enable = true;
    nix-direnv.enable = true;
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
    extraLuaConfig = builtins.readFile ../dotfiles/nvim/init.lua;
    extraPackages = with pkgs; [
      # denops
      deno
      # tree-sitter
      gcc
      # nix
      nil
      # lua
      lua-language-server
      stylua
      # toml
      taplo
    ];
  };

  programs.eza = {
    enable = true;
    git = true;
    icons = true;
  };
}
