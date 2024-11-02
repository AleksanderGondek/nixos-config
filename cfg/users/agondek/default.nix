{
  config,
  lib,
  pkgs,
  latest-nixpkgs,
  ...
}: let
  # Not hiding under cfg, leads to infinite recursion
  cfg = config.agondek-cfg;
  secrets = config.sops.secrets;
in {
  # TODO(agondek): Please split me into more modules :)
  imports = [];

  options.agondek-cfg.users.agondek = {
    enable = lib.mkOption {
      type = lib.types.bool;
      default = false;
      description = ''
        If enabled, default agondek user will be defined on the host.
      '';
    };
  };

  config = lib.mkIf cfg.users.agondek.enable {
    users.users.agondek = {
      description = "Aleksander Gondek";
      uid = 6666;
      isNormalUser = true;
      group = "nogroup";
      extraGroups =
        [
          "wheel"
        ]
        ++ (
          if cfg.desktop.enable
          then [
            "audio"
            "networkmanager"
            "pulse"
            "sound"
          ]
          else []
        );
      home = "/home/agondek";
      shell = pkgs.bashInteractive;
      createHome = true;
      hashedPasswordFile = secrets.agondek_password.path;
    };

    nix.settings.trusted-users = ["agondek"];

    home-manager.users.agondek = {
      home.stateVersion = cfg.nix.channel;

      home.packages = with pkgs;
        [
          bat
          coreutils-full
          curlFull
          eza
          fastfetch
          fd
          fx
          fzf
          gnupg
          gnutar
          helix
          htop
          jq
          keepassxc
          kubectl
          less
          ncurses
          nix
          niv
          ranger
          ripgrep
          unzip
          weechat
          wget
          vim
          zellij
        ]
        ++ (
          if cfg.desktop.enable
          then
            (with pkgs; [
              blueman
              discord
              evince
              gnome3.gnome-screenshot
              halloy
              notepadqq
              spotify
              (vivaldi.override {
                proprietaryCodecs = true;
                enableWidevine = true;
                widevine-cdm = widevine-cdm;
                vivaldi-ffmpeg-codecs = vivaldi-ffmpeg-codecs;
              })
              vlc
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
            ])
          else []
        );

      home.sessionVariables = {
        EDITOR = "hx";
        FZF_DEFAULT_COMMAND = "fd --type f --hidden";
        TERM = "xterm-256color";
      };

      programs.bash = {
        enable = true;
        enableCompletion = true;
        bashrcExtra = ''
          # My generated bashrc!

          # https://github.com/nix-community/home-manager/issues/1011
          # https://github.com/NixOS/nixpkgs/pull/187620#issuecomment-1891078183
          if [[ $XDG_SESSION_TYPE == "wayland" ]]; then
            if [ -f /etc/profiles/per-user/agondek/etc/profile.d/hm-session-vars.sh ]; then
              . "/etc/profiles/per-user/agondek/etc/profile.d/hm-session-vars.sh"
            fi;
          fi
        '';
      };

      programs.direnv = {
        enable = true;
      };

      programs.git = {
        enable = true;
        userEmail = "gondekaleksander@protonmail.com";
        userName = "Aleksander Gondek";
        extraConfig = {
          init = {
            defaultBranch = "master";
          };
          core = {
            editor = "hx";
          };
        };
        signing = {
          key = "65CCE6BBC241FF3F30CC531D816D9CCE02C7F649";
          signByDefault = true;
        };
      };

      programs.starship = {
        enable = true;
        enableBashIntegration = true;
      };

      home.file =
        {
          ".config/alacritty/alacritty.toml".source = ./config-files/.config/alacritty/alacritty.toml;
          ".config/htop/htoprc".source = ./config-files/.config/htop/htoprc;
          ".config/starship.toml".source = ./config-files/.config/starship.toml;
        }
        // (
          if cfg.desktop.enable
          then {
            ".Xresources".source = ./config-files/.Xresources;
            ".fehbg".source = ./config-files/.fehbg;
            ".gtkrc-2.0".source = ./config-files/.gtkrc-2.0;
            ".screenlayout/setup-monitor.layout.sh".source = ./config-files/.screenlayout/setup-monitor.layout.sh;
            ".config/wallpapers/klontalersee-glarus-switzerland.jpg".source = ./config-files/.config/wallpapers/klontalersee-glarus-switzerland.jpg;
            ".config/wallpapers/nix-glow.png".source = ./config-files/.config/wallpapers/nix-glow.png;
            ".config/gtk-3.0/settings.ini".source = ./config-files/.config/gtk-3.0/settings.ini;
            ".config/i3/config".source = ./config-files/.config/i3/config;
            ".config/polybar/config.ini".source = ./config-files/.config/polybar/config.ini;
            ".config/polybar/run-polybar.sh".source = ./config-files/.config/polybar/run-polybar.sh;
            ".config/rofi/config.rasi".source = ./config-files/.config/rofi/config.rasi;
            ".config/rofi/monokai.rasi".source = ./config-files/.config/rofi/monokai.rasi;
            ".config/hypr/hyprland.conf".source = ./config-files/.config/hypr/hyprland.conf;
            ".config/hypr/hyprlock.conf".source = ./config-files/.config/hypr/hyprlock.conf;
            ".config/hypr/me-welcome.png".source = ./config-files/.config/hypr/me-welcome.png;
            ".config/waybar/config.jsonc".source = ./config-files/.config/waybar/config.jsonc;
            ".config/waybar/style.css".source = ./config-files/.config/waybar/style.css;
          }
          else {}
        );

      services.dunst = {
        enable = cfg.desktop.enable;
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
            font = "Berkeley Mono 8";
            markup = "full";
            format = "<b>%s</b>\\n%b";
            alignment = "left";
            vertical_alignment = "center";
            word_wrap = "yes";
            ignore_newline = "no";
            stack_duplicates = true;
            # Icons
            icon_position = "left";
            max_icon_size = 32;
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
    };
  };
}
