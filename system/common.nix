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
    package = pkgs.nix;
  };
}
