{ username, hostname, ... }:

#############################################################
#
#  Host & Users configuration
#
#############################################################

{
  networking.hostName = hostname;
  networking.computerName = hostname;
  system.defaults.smb.NetBIOSName = hostname;

  users.users."${username}"= {
    name = username;
    home = builtins.getEnv "HOME";
    description = username;
  };

  nix.settings.trusted-users = [ username ];
}
