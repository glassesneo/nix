{
  description = "Neo's nix configuration";

  nixConfig = {
    substituters = [
      # Query the mirror of USTC first, and then the official cache.
      "https://mirrors.ustc.edu.cn/nix-channels/store"
      "https://cache.nixos.org"
    ];
  };

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nixos-hardware.url = "github:NixOS/nixos-hardware/master";
    nix-darwin = {
      url = "github:LnL7/nix-darwin";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nix-on-droid = {
      url = "github:nix-community/nix-on-droid/release-24.05";
      inputs.nixpkgs.follows = "nixpkgs";
      # inputs.home-manager.follows = "home-manager";
    };
  };

  outputs = inputs@{ self, nixpkgs, nixos-hardware, nix-darwin, nix-on-droid, home-manager }:
    let
      username = builtins.getEnv "USER";
      useremail = "glassesneo@protonmail.com";
      system = builtins.currentSystem;
      pkgs = import inputs.nixpkgs {
        system = "${system}";
        config.allowUnfree = true;
      };
      specialArgs = inputs // {
        inherit username useremail;
      };

      commonNixOSConfigurations = {
        inherit specialArgs;
        system = "x86_64-linux";
        modules = [
          ./system/nixos/configuration.nix
          home-manager.nixosModules.home-manager
          {
            home-manager = {
              useGlobalPkgs = true;
              useUserPackages = true;
              extraSpecialArgs = specialArgs;
              verbose = true;
              users."${username}" = import ./home/hosts/Narukami.nix;
            };
          }
        ];
      };

      commonDarwinConfigurations = {
        inherit specialArgs;
        system = "aarch64-darwin";
        modules = [
          ./system/darwin/configuration.nix
          home-manager.darwinModules.home-manager
          {
            home-manager = {
              useGlobalPkgs = true;
              useUserPackages = true;
              extraSpecialArgs = specialArgs;
              verbose = true;
              users."${username}" = import ./home/hosts/Oboro.nix;
            };
          }
        ];
      };

      commonNixOnDroidConfigurations = {
        pkgs = import nixpkgs { system = "aarch64-linux"; };
        modules = [
          ./system/android/configuration.nix
          { nix.registry.nixpkgs.flake = nixpkgs; }
          {
            home-manager = {
              useGlobalPkgs = true;
              useUserPackages = true;
              extraSpecialArgs = specialArgs;
              config = ./home/hosts/localhost.nix;
            };
          }
        ];
        extraSpecialArgs = specialArgs;
        home-manager-path = home-manager.outPath;
      };

    in
      {
        nixosConfigurations = {
          "Narukami" = inputs.nixpkgs.lib.nixosSystem commonNixOSConfigurations;
        };
        darwinConfigurations = {
          "Oboro" = nix-darwin.lib.darwinSystem commonDarwinConfigurations;
        };
        nixOnDroidConfigurations = {
          default = nix-on-droid.lib.nixOnDroidConfiguration commonNixOnDroidConfigurations;
        };
        homeConfigurations = {
          "${username}@Narukami" = home-manager.lib.homeManagerConfiguration {
            inherit pkgs;
            modules = [ ./home/hosts/Narukami.nix ];
            extraSpecialArgs = specialArgs;
          };
          "${username}@Oboro" = home-manager.lib.homeManagerConfiguration {
            inherit pkgs;
            modules = [ ./home/hosts/Oboro.nix ];
            extraSpecialArgs = specialArgs;
          };
          "nix-on-droid" = home-manager.lib.homeManagerConfiguration {
            pkgs = import nixpkgs {
              system = "aarch64-linux";
            };
            modules = [ ./home/hosts/localhost.nix ];
            extraSpecialArgs = specialArgs;
          };
        };
      };
}
