{ inputs, config, lib, pkgs, ... }:
let
  username = "neo";
  hostname = "Narukami";
in
  {
    imports = [
      <nixos-wsl/modules>
      ../common.nix
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

    networking = {
      hostName = hostname;
    };

    programs.zsh.enable = true;

    boot.kernelPackages = pkgs.linuxKernel.packages.linux_zen;

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
      gc = {
        automatic = true;
        dates = "weekly";
        options = "--delete-older-than 7d";
      };
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
