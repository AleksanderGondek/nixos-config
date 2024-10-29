{
  description = "Aleksander Gondek hosts configurations";

  inputs = {
    # Nixpkgs channels
    nixpkgs.url = "github:nixos/nixpkgs/nixos-24.05";
    latest-nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";

    home-manager = {
      url = "github:nix-community/home-manager/release-24.05";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    sops-nix = {
      url = "github:Mic92/sops-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    flake-utils-plus.url = "github:gytis-ivaskevicius/flake-utils-plus";

    # Optional stuff to add later
    #
    # Package to nix declaration
    # forgit-git = {
    #   url = github:wfxr/forgit;
    #   flake = false;
    # };
    #
    # nixpkgs-wayland = {
    #   url = github:colemickens/nixpkgs-wayland;
    #   inputs.nixpkgs.follows = "nixpkgs";
    #   inputs.unstableSmall.follows = "nixpkgs";
    # };
    #
    # nur.url = github:nix-community/NUR;
    #
    # nvfetcher = {
    #   url = "github:berberman/nvfetcher";
    #   inputs.nixpkgs.follows = "nixpkgs";
    # };
  };

  outputs = {
    self,
    nixpkgs,
    latest-nixpkgs,
    home-manager,
    sops-nix,
    flake-utils-plus,
    ...
  } @ inputs: let
    gen-extra-args = system: {
      latest-nixpkgs = import latest-nixpkgs {
        inherit system;
        config = {
          allowUnfree = true;
        };
      };
    };
  in
    flake-utils-plus.lib.mkFlake {
      inherit self inputs;

      supportedSystems = [
        "aarch64-linux"
        "x86_64-linux"
      ];

      channelsConfig = {
        allowUnfree = true;
      };

      # Host defaults
      hostDefaults = {
        system = "x86_64-linux";
        channelName = "nixpkgs";
        extraArgs = gen-extra-args "x86_64-linux";
        modules = [
          home-manager.nixosModules.home-manager
          sops-nix.nixosModules.sops
        ];
      };

      hosts.nixos-flake-test = {
        modules = [
          ./hosts/nixos-flake-test
          ./cfg
          {
            agondek-cfg = {
              audio.pulseaudio.enable = true;
              users.drone = {
                enable = true;
              };
            };
          }
        ];
      };

      hosts.blackwood = {
        modules = [
          ./hosts/blackwood
          ./cfg
          {
            agondek-cfg = {
              audio.pipewire.enable = true;
              desktop = {
                enable = true;
                flavor = "nvidia";
              };
              dnsmasq = {
                enable = true;
                customAddresses = [
                  "/api.morrigna.rules-nix.build/192.168.66.1"
                  "/api.morrigna.rules-nix.build/192.168.66.2"
                  "/api.morrigna.rules-nix.build/192.168.66.3"
                ];
              };
              k8s-single-node = {
                enable = true;
              };
              users.agondek = {
                enable = true;
              };
            };
          }
        ];
      };

      hosts.pasithea = {
        modules = [
          ./hosts/pasithea
          ./cfg
          {
            agondek-cfg = {
              audio.pulseaudio.enable = true;
              users = {
                agondek = {enable = true;};
                viewer = {enable = true;};
              };
            };
          }
        ];
      };

      hosts.plutus = {
        modules = [
          ./hosts/plutus
          ./cfg
          {
            agondek-cfg = {
              audio = {
                bluetooth.enable = true;
                pulseaudio.enable = true;
              };
              desktop = {
                enable = true;
                windowsManager = "hyprland";
              };
              dnsmasq = {
                enable = true;
                customAddresses = [
                  "/api.morrigna.rules-nix.build/192.168.66.1"
                  "/api.morrigna.rules-nix.build/192.168.66.2"
                  "/api.morrigna.rules-nix.build/192.168.66.3"
                ];
              };
              users.agondek = {
                enable = true;
              };
            };
          }
        ];
      };

      hosts.vm-utility-drone = {
        modules = [
          ./hosts/vm-utility-drone
          ./cfg
          {
            agondek-cfg.users = {
              drone = {enable = true;};
              agondek = {enable = true;};
            };
          }
        ];
      };
    };
}
