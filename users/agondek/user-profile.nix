{ config, pkgs, latest-nixpkgs, ... }:

let
  preConfiguredVscode = import ../../programs/vscode.nix { 
    inherit config pkgs;
  };
in
{
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
      ".config/wallpapers/klontalersee-glarus-switzerland.jpg".source = ./config-files/.config/wallpapers/klontalersee-glarus-switzerland.jpg;
      ".config/wallpapers/nix-glow.png".source = ./config-files/.config/wallpapers/nix-glow.png;
      ".config/gtk-3.0/settings.ini".source = ./config-files/.config/gtk-3.0/settings.ini;
      ".config/alacritty/alacritty.yml".source = ./config-files/.config/alacritty/alacritty.yml;
      ".config/htop/htoprc".source = ./config-files/.config/htop/htoprc;
      ".config/i3/config".source = ./config-files/.config/i3/config;
      ".config/polybar/config".source = ./config-files/.config/polybar/config;
      ".config/polybar/run-polybar.sh".source = ./config-files/.config/polybar/run-polybar.sh;
      ".config/rofi/config.rasi".source = ./config-files/.config/rofi/config.rasi;
      ".config/rofi/monokai.rasi".source = ./config-files/.config/rofi/monokai.rasi;
      ".config/Code/User/settings.json".source = pkgs.writeText "setting.json" ''
      {
        "editor.fontFamily": "'Hack Regular', 'Droid Sans Mono', 'monospace', monospace, 'Droid Sans Fallback'",
        "editor.fontSize": 12,
        "editor.tabSize": 2,
        "terminal.integrated.fontSize": 12,
        "terminal.integrated.detectLocale": "on",
        "terminal.integrated.fontFamily": "Hack",
        "terminal.explorerKind": "integrated",
        "update.mode": "none",
        "update.showReleaseNotes": false,
        "workbench.colorTheme": "Monokai Pro",
        "workbench.iconTheme": "Monokai Pro Icons",
        // Implementation-specific workaround - rust-analyzer is really hellbent on using everything global
        // I really do not want't to have anything globally set
        // Impl: https://github.com/rust-analyzer/rust-analyzer/blob/d0f2bc3b878d1c1d8eaf081e6f670ebb928b7a5f/editors/code/src/toolchain.ts#L149
        "rust-analyzer.server.extraEnv": {
          "CARGO": "${pkgs.cargo}/bin/cargo",
          "RUSTC": "${pkgs.rustc}/bin/rustc",
        }
      }
      '';
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
      cntr
      asciinema
      blueman  # Bluetooth
      cachix
      evince  #  Pdf reader
      firefox
      gnome3.gnome-screenshot
      gnome.gnome-sound-recorder
      kazam
      keepassxc
      krita
      obs-studio
      nixops
      neofetch
      notepadqq
      preConfiguredVscode
      remmina
      signal-desktop
      slack-dark
      spotify
      (vivaldi.override {proprietaryCodecs = true; enableWidevine = true;})
      vlc
      latest-nixpkgs.discord
      latest-nixpkgs.joplin
      latest-nixpkgs.joplin-desktop
      latest-nixpkgs.zoom-us
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
