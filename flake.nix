{
  description = "Aleksander Gondek hosts configurations";

  inputs = {
    # Nixpkgs channels
    nixpkgs.url = "github:nixos/nixpkgs/release-21.11";
    latest-nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";

    home-manager = {
      url = "github:nix-community/home-manager/release-21.11";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    sops-nix = {
      url = "github:Mic92/sops-nix";
      inputs.agenix.inputs.nixpkgs.follows = "nixpkgs";
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
  }@inputs:
  let
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
        # Common stuff
        ./modules/common-base.nix
        ./modules/secrets.nix
      ];
    };

    hosts.nixos-flake-test = {
      modules = [
        ./hosts/nixos-flake-test/hardware-configuration.nix
        ./hosts/nixos-flake-test/configuration.nix
        ./modules/zfs.nix
        ./modules/audio/pulseaudio.nix
        ./users/drone/user-profile.nix
      ];
    };

    hosts.blackwood = {
      modules = [
        ./hosts/blackwood/hardware-configuration.nix
        ./hosts/blackwood/configuration.nix
        ./modules/zfs.nix
        ./modules/audio/pulseaudio.nix
        ./modules/desktops/nvidia-desktop.nix
        ./modules/virtualisation/vbox.nix
        ./modules/virtualisation/containerd.nix
        ./modules/cluster/k8s-dev-single-node.nix
        ./users/agondek/user-profile-slim.nix
        ./users/agondek/user-profile.nix
        # TODO: Move to modules
        ./programs/steam.nix
      ];
    };

    hosts.plutus = {
      modules = [
        ./hosts/plutus/hardware-configuration.nix
        ./hosts/plutus/configuration.nix
        ./modules/zfs.nix
        ./modules/audio/pulseaudio.nix
        ./modules/audio/bluetooth.nix
        ./modules/desktops/default-desktop.nix
        ./modules/virtualisation/vbox.nix
        ./modules/virtualisation/containerd.nix
        #./modules/cluster/k8s-dev-single-node.nix
        ./users/agondek/user-profile-slim.nix
        ./users/agondek/user-profile.nix
      ];
    };

    hosts.ravenrock = {
      modules = [
        ./hosts/ravenrock/hardware-configuration.nix
        ./hosts/ravenrock/configuration.nix
        ./modules/zfs.nix
        ./modules/audio/pulseaudio.nix
        ./modules/audio/bluetooth.nix
        ./modules/desktops/default-desktop.nix
        ./modules/virtualisation/vbox.nix
        ./modules/virtualisation/containerd.nix
        #./modules/cluster/k8s-dev-single-node.nix
        ./users/agondek/user-profile-slim.nix
        ./users/agondek/user-profile.nix
      ];
    };

    hosts.vm-utility-drone = {
      modules = [
        ./hosts/vm-utility-drone/hardware-configuration.nix
        ./hosts/vm-utility-drone/configuration.nix
        ./modules/zfs.nix
        #./modules/cluster/k8s-dev-single-node.nix
        ./users/drone/user-profile.nix
        ./users/agondek/user-profile-slim.nix
      ];
    };

  };
}
