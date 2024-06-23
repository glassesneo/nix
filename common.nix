{ pkgs, username, hostname, ... }:
{
  users.users."${username}"= {
    name = username;
    home = builtins.getEnv "HOME";
  };

  networking = {
    hostName = hostname;
    computerName = hostname;
  };

  system.defaults.smb.NetBIOSName = hostname;

  nix = {
    settings = {
      auto-optimise-store = true;
      experimental-features = [ "nix-command" "flakes" ];
    };
    package = pkgs.nix;
  };

  services.nix-daemon.enable = true;
}
