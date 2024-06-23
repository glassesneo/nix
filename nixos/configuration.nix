{ inputs, config, lib, pkgs, ... }:
let
  username = "neo";
  hostname = "Narukami";
  commonConfig = import ../common.nix {
    inherit pkgs username hostname;
  };
in
  lib.recursiveUpdate
  commonConfig
  {
    imports = [
      <nixos-wsl/modules>
    ];

    wsl.enable = true;
    wsl.defaultUser = username;

    users.users = {
      "${username}" = {
        isNormalUser = true;
        home = "/home/${username}";
        extraGroups = [ "wheel" "networkmanager" ];
        shell = pkgs.zsh;
      };
    };


    programs.zsh.enable = true;

    boot.kernelPackages = pkgs.linuxKernel.packages.linux_zen;

    networking.hostName = hostname;

    system.stateVersion = "23.11";

    services.tailscale.enable = true;
    networking.firewall = {
      enable = true;
      trustedInterfaces = ["tailscale0"];
      allowedUDPPorts = [config.services.tailscale.port];
    };

    nix = {
      settings = {
        trusted-users = [ username ];
      };
    };
  }
