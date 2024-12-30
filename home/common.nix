{ config, ... }:
{
  imports = [ ./app.nix ];

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
        # Commit type
        # build: Changes that affect the build system or external dependencies
        # chore: Changes that doesn't affect the source code itself
        # ci: Changes to our CI configuration files and scripts (example scopes: Travis, Circle, BrowserStack, SauceLabs)
        # docs: Documentation only changes
        # feat: A new feature
        # fix: A bug fix
        # perf: A code change that improves performance
        # refactor: A code change that neither fixes a bug nor adds a feature
        # revert: A code change that reverts previous commits
        # style: Changes that do not affect the meaning of the code (white-space, formatting, missing semi-colons, etc)
        # test: Adding missing tests or correcting existing tests
      '';
    };
    "nvim" = {
      source = ../dotfiles/nvim;
      target = "${config.xdg.configHome}/nvim";
      recursive = true;
    };
  };
}
