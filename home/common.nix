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
# 🎉 :tada: A new project
# ✨ :sparkles: New features
# 🐛 :bug: Bugfix
# ♼  :recycle: Refactor
# ⚡️ :zap: Performance
# 🔥 :fire: Remove code or files
# 💥 :boom: Breaking Changes
# 💬 :speech_balloon: Text
# 🎨 :art: Style
# ⚰️  :coffin: Remove dead code
# ✏️ :pencil: Fix typos
# 🔒 :lock: Fix security or privacy issues
# 🦺 :safety_vest: Validation code
# ✅ :white_check_mark: Test
# 💡 :bulb: Comments
# 📝 :memo: Docs
# 🛠️ :wrench: Config
# 📄 :page_facing_up: License
# 🔖 :bookmark: Release / Version Tag
      '';
    };
    "nvim" = {
      source = ../dotfiles/nvim;
      target = "${config.xdg.configHome}/nvim";
      recursive = true;
    };
  };
}
