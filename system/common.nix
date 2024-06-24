{ pkgs, username, ... }:
{
  users.users."${username}"= {
    name = username;
    home = builtins.getEnv "HOME";
  };

  nix = {
    settings = {
      auto-optimise-store = true;
      experimental-features = [ "nix-command" "flakes" ];
    };
    gc = {
      automatic = true;
      dates = "weekly";
      options = "--delete-older-than 7d";
    };
    package = pkgs.nix;
  };

  virtualisation = {
    docker = {
      enable = true;
      rootless = {
        enable = true;
        setSocketVariable = true; # Set $DOCKER_HOST
      };
    };
  };
}
