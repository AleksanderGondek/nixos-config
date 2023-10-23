{ config, pkgs, latest-nixpkgs, ... }:

let
  preConfiguredVscode = import ../../programs/vscode.nix { 
    inherit config pkgs latest-nixpkgs;
  };
  komau-vim-theme = latest-nixpkgs.callPackage ../../programs/komau-vim-theme.nix {};
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
      ".config/wallpapers/klontalersee-glarus-switzerland.jpg".source = ./config-files/.config/wallpapers/klontalersee-glarus-switzerland.jpg;
      ".config/wallpapers/nix-glow.png".source = ./config-files/.config/wallpapers/nix-glow.png;
      ".config/gtk-3.0/settings.ini".source = ./config-files/.config/gtk-3.0/settings.ini;
      ".config/alacritty/alacritty.yml".source = ./config-files/.config/alacritty/alacritty.yml;
      ".config/htop/htoprc".source = ./config-files/.config/htop/htoprc;
      ".config/i3/config".source = ./config-files/.config/i3/config;
      ".config/polybar/config.ini".source = ./config-files/.config/polybar/config.ini;
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
      discord
      evince  #  Pdf reader
      gnome3.gnome-screenshot
      gnome.gnome-sound-recorder
      kazam
      keepassxc
      krita
      obs-studio
      # nixops
      # Depends on old pyjwt: CVE-2022-29217
      niv
      neofetch
      notepadqq
      preConfiguredVscode
      remmina
      signal-desktop
      slack-dark
      spotify
      (vivaldi.override {
        proprietaryCodecs = true; 
        enableWidevine = true;
        widevine-cdm = widevine-cdm;
        vivaldi-ffmpeg-codecs = vivaldi-ffmpeg-codecs;
      })
      vlc
      # Sad panda
      # Have to manually enable on each host,
      # after manual action, welcom to eula world
      #citrix_workspace_21_08_0
      # Not sad
      # Override example, for future use
      #(latest-nixpkgs.discord.overrideAttrs (oldAttrs: {
      #  version = "0.0.21";
      #  src = latest-nixpkgs.fetchurl {
      #    url = "https://dl.discordapp.net/apps/linux/0.0.21/discord-0.0.21.tar.gz";
      #    sha256 = "sha256-KDKUssPRrs/D10s5GhJ23hctatQmyqd27xS9nU7iNaM=";
      #  };
      #}))
      latest-nixpkgs.firefox
      latest-nixpkgs.jetbrains.idea-ultimate
      latest-nixpkgs.joplin
      latest-nixpkgs.joplin-desktop
      latest-nixpkgs.zoom-us
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
    # Neovim configured for proper, writting
    programs.neovim = {
      enable = true;
      plugins = [
        komau-vim-theme
        pkgs.vimPlugins.goyo-vim
        pkgs.vimPlugins.limelight-vim
      ];
      extraConfig = ''
      :colorscheme komau
      :set background=light
      '';
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
