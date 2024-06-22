{ inputs, config, lib, pkgs, ... }:
{
  imports = [
    <nixos-wsl/modules>
  ];

  wsl.enable = true;
  wsl.defaultUser = "neo";

  users.users."neo" = {
    isNormalUser = true;
    home = "/home/neo";
    extraGroups = [ "wheel" "networkmanager" ];
  };

  boot.kernelPackages = pkgs.linuxKernel.packages.linux_zen;

  networking.hostName = "Aotsuyu";

  system.stateVersion = "23.11";

  services.tailscale.enable = true;
  networking.firewall = {
    enable = true;
    trustedInterfaces = ["tailscale0"];
    allowedUDPPorts = [config.services.tailscale.port];
  };

  nix = {
    settings = {
      trusted-users = [ "neo" ];
      auto-optimise-store = true;
      experimental-features = [ "nix-command" "flakes" ];
    };
  };
}
