{ config, pkgs, ... }:

let
  secrets = import ../../secrets.nix {};
  preConfiguredVscode = import ../../programs/vscode.nix { 
    inherit config pkgs secrets;
  };
in
{
  imports = [
    ./user-profile-slim.nix
  ];

  environment.systemPackages = with pkgs; [
    openconnect
    openvpn                # For home VPN setup
    networkmanager-openvpn # For home VPN setup
  ];

  users.users.agondek = {
    extraGroups = [
      "networkmanager"
    ];
    shell = pkgs.lib.mkForce pkgs.zsh;
  };

  home-manager.users.agondek = {
    home.file = {
      ".Xresources".source = ./config-files/.Xresources;
      ".fehbg".source = ./config-files/.fehbg;
      ".gtkrc-2.0".source = ./config-files/.gtkrc-2.0;
      ".screenlayout/setup-monitor.layout.sh".source = ./config-files/.screenlayout/setup-monitor.layout.sh;
      ".screenlayout/ravenrock-laptop.layout.sh".source = ./config-files/.screenlayout/ravenrock-laptop.layout.sh;
      ".config/gtk-3.0/settings.ini".source = ./config-files/.config/gtk-3.0/settings.ini;
      ".config/alacritty/alacritty.yml".source = ./config-files/.config/alacritty/alacritty.yml;
      ".config/htop/htoprc".source = ./config-files/.config/htop/htoprc;
      ".config/i3/config".source = ./config-files/.config/i3/config;
      ".config/polybar/config".source = ./config-files/.config/polybar/config;
      ".config/polybar/run-polybar.sh".source = ./config-files/.config/polybar/run-polybar.sh;
      ".config/rofi/config".source = ./config-files/.config/rofi/config;
      ".config/rofi/Monokai.rasi".source = ./config-files/.config/rofi/Monokai.rasi;
      ".config/Code/User/settings.json".source = ./config-files/.config/Code/User/settings.json;
      ".config/Code/User/rlsWrapper.sh" = {
        executable = true;
        text = ''
          #!/usr/bin/env bash
          # This helps in wierd OPENSSL issues while compiling rust
          RLS=rls
          export LD_LIBRARY_PATH=''$(rustc --print sysroot)/lib
          export RUST_BACKTRACE=full
          export OPENSSL_LIB_DIR="${pkgs.openssl.out}/lib";
          export OPENSSL_INCLUDE_DIR="${pkgs.openssl.dev}/include";
          ''$RLS "''$@"
        '';
      };
      ".config/wallpapers/klontalersee-glarus-switzerland.jpg".source = ./config-files/.config/wallpapers/klontalersee-glarus-switzerland.jpg;
      ".libvirtd/createStoragePool" = {
        executable = true;
        text = ''
          #!/run/current-system/sw/bin/sh

          images=/var/lib/libvirt/images
          sudo mkdir $images
          sudo chgrp libvirtd $images
          sudo chmod g+w $images
          
          sudo virsh pool-define-as default dir --target $images
          sudo virsh pool-autostart default
          sudo virsh pool-start default
        '';
      };
    };
    home.packages = with pkgs; [
      nixops
      cachix
      evince #  Pdf reader
      (vivaldi.override {proprietaryCodecs = true; enableWidevine = true;})
      spotify # Music
      gnome3.gnome-screenshot # Screenshot
      remmina
      neofetch
      # Video ops
      kazam
      vlc
      obs-studio
      # Passwords
      keepassxc
      # Emails
      # IDEs
      preConfiguredVscode
      # Taking notes
      unstable.joplin
      unstable.joplin-desktop
      notepadqq
      zim
      # Memes
      krita
      # Staying in touch
      unstable.discord
      signal-desktop
      slack-dark
      unstable.zoom-us
      # Bluetooth
      blueman
      # Developing in Scala
      jdk
      sbt
      # Developing in Python
      (python38.withPackages(ps : with ps; [ 
          ipython
          flake8
          pycodestyle
          pylint
          setuptools
          virtualenv
        ]
      ))
      # Developiong in Rust
      binutils
      gcc
      gnumake
      openssl
      pkgconfig
      # Factory of factory of factory..
      # Only for IDE integration (sigh)
      rustup
      rust-analyzer
      # Bazel 
      bazel-buildtools
      # Work?
      azure-cli
      vagrant
      jetbrains.pycharm-community
    ];
    services.dunst = {
      enable = true;
      iconTheme = {
        package = pkgs.gnome3.adwaita-icon-theme;
        name = "Adwaita";
        size = "32x32";
      };
      settings = {
        global = {
          # Display
          follow = "mouse";
          geometry = "300x6-10+30";
          indicate_hidden = "yes";
          transparency = 40;
          padding = 8;
          horizontal_padding = 8;
          frame_width = 2;
          frame_color = "#f9f8f5";
          separator_color = "frame";
          sort = "yes";
          idle_threshold = 360;
          # Text
          font = "Hack Regular 8";
          markup = "full";
          format = "<b>%s</b>\\n%b";
          alignment = "left";
          vertical_alignment = "center";
          word_wrap = "yes";
          ignore_newline = "no";      
          stack_duplicates = true;
          # Icons
          icon_position = "left";
          max_icon_size=32;
          # Misc/Advanced
          browser = "Vivaldi";
          startup_notification = true;
          corner_radius = 0;
        };
        urgency_low = {
          background = "#272822";
          foreground = "#f8f8f2";
          frame_color = "#66d9ef";
        };
        urgency_normal = {
          background = "#272822";
          foreground = "#f8f8f2";
          frame_color = "#f4bf75";
        };
        urgency_critical = {
          background = "#272822";
          foreground = "#f8f8f2";
          frame_color = "#f92672";
        };
      };
    };
    programs.zsh = {
      enable = true;
      enableAutosuggestions = true;

      shellAliases = {};

      oh-my-zsh = {
        enable = true;
        plugins = [
          "docker"
          "fd"
          "git"
          "kubectl"
          "ripgrep"
        ];
        theme = "agnoster";
      };
    };
    xdg.mimeApps = {
      enable = true;
      defaultApplications = {
        "text/html" = ["vivaldi-stable.desktop"];
        "text/htm" = ["vivaldi-stable.desktop"];
        "x-scheme-handler/http" = ["vivaldi-stable.desktop"];
        "x-scheme-handler/https" = ["vivaldi-stable.desktop"];
        "x-scheme-handler/about" = ["vivaldi-stable.desktop"];
        "x-scheme-handler/unknown" = ["vivaldi-stable.desktop"];
      };
    };
  };
}
