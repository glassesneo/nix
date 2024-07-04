{ config, ... }:
{
  imports = [
    ./app.nix
  ];

  xdg.enable = true;

  home = {
    username = builtins.getEnv "USER";
    homeDirectory = builtins.getEnv "HOME";
    stateVersion = "24.11";
    sessionVariables = {
      EDITOR = "nvim";
    };
  };

  programs.home-manager.enable = true;

  xdg.configFile = {
    ".gitmsg" = {
      target = "${config.xdg.configHome}/git/.gitmsg";
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
      source = ../dotfiles/nvim;
      target = "${config.xdg.configHome}/nvim";
      recursive = true;
    };
  };
}
