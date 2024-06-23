{ lib, pkgs, username, ... }:
let
  hostname = "Oboro";
  commonConfig = import ../common.nix {
    inherit pkgs username hostname;
  };
in
  lib.recursiveUpdate
  commonConfig
  {
    nix.settings = {
      # substituers that will be considered before the official ones(https://cache.nixos.org)
      substituters = [
        "https://mirror.sjtu.edu.cn/nix-channels/store"
        "https://nix-community.cachix.org"
      ];
      trusted-users = [ username ];
      trusted-public-keys = [
        "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
      ];
      builders-use-substitutes = true;
    };
  }
