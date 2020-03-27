{ config, pkgs, ... }:

let
  userSecrets = import ./user-secrets.nix {};
  preConfiguredVscode = import ./programs/vscode.nix { 
    inherit config pkgs userSecrets;
  };
  ffAddons = import ./programs/firefox-addons.nix {
    inherit config pkgs;
  };
in {
  environment.systemPackages = with pkgs; [
    exa
    fd
    ripgrep # Grep written in rust
    openconnect
  ];

  users.users.agondek = {
    description = "Aleksander Gondek";
    uid = 6666;
    isNormalUser = true;
    group = "nogroup";
    extraGroups = [
      "wheel"
      "networkmanager"
      "docker"
    ];
    home = "/home/agondek";
    shell = pkgs.zsh;
    createHome = true;
    useDefaultShell = false;
    hashedPassword = userSecrets.hashedPassword;
  };

  home-manager.users.agondek = {
    home.file = {
      ".Xresources".source = ./config-files/.Xresources;
      ".fehbg".source = ./config-files/.fehbg;
      ".gtkrc-2.0".source = ./config-files/.gtkrc-2.0;
      ".screenlayout/setup-monitor.layout.sh".source = ./config-files/.screenlayout/setup-monitor.layout.sh;
      ".screenlayout/work-laptop-docked.layout.sh".source = ./config-files/.screenlayout/work-laptop-docked.layout.sh;
      ".screenlayout/work-laptop.layout.sh".source = ./config-files/.screenlayout/work-laptop.layout.sh; 
      ".config/gtk-3.0/settings.ini".source = ./config-files/.config/gtk-3.0/settings.ini;
      ".config/alacritty/alacritty.yml".source = ./config-files/.config/alacritty/alacritty.yml;
      ".config/htop/htoprc".source = ./config-files/.config/htop/htoprc;
      ".config/i3/config".source = ./config-files/.config/i3/config;
      ".config/i3/status.toml".source = ./config-files/.config/i3/status.toml;
      ".config/polybar/config".source = ./config-files/.config/polybar/config;
      ".config/polybar/run-polybar.sh".source = ./config-files/.config/polybar/run-polybar.sh;
      ".config/rofi/config".source = ./config-files/.config/rofi/config;
      ".config/rofi/Monokai.rasi".source = ./config-files/.config/rofi/Monokai.rasi;
      ".config/Code/User/settings.json".source = ./config-files/.config/Code/User/settings.json;
      ".config/wallpapers/01.jpg".source = ./config-files/.config/wallpapers/01.jpg;
      ".gpvpn/fix" = {
        executable = true;
        text = ''
          #!/run/current-system/sw/bin/sh

          echo -n "Fixing invalid resolv.conf ..."
          sed -i 's/domain/search/g' /etc/resolv.conf
          sed -i '/nameserver 192.168.2.1/d' /etc/resolv.conf
          sed -i '/nameserver 9.9.9.9/d' /etc/resolv.conf
          echo "done"

          echo -n "Removing default route over tun0... "
          ip route del default dev tun0
          echo "done"
 
          echo -n "Setting routes for internal networks... "
          ip route add 192.168.87.0/24 scope link dev tun0
          ip route add 10.0.0.0/8 scope link dev tun0
          ip route add 34.198.80.33 scope link dev tun0
          ip route add 52.20.83.100 scope link dev tun0
          ip route add 54.164.6.77 scope link dev tun0
          echo "done"
        '';
      };
    };
    home.packages = with pkgs; [
      evince # pdf reader
      vivaldi # Preferred Browser
      spotify # music
      git-crypt
      kubectl
      # Passwords
      keepassxc
      # Emails
      thunderbird
      # IDEs
      preConfiguredVscode
      # Taking notes
      zim
      notepadqq
      # Staying in touch
      slack-dark
      zoom-us
      # Developing in Scala
      jdk
      sbt
      # Developing in Python
      pypi2nix
      (python37.withPackages(ps : with ps; [ 
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
      rustc
      cargo
    ];
    home.sessionVariables = {
      NIXOS_CONFIG = /home/agondek/Projects/nixos-config;
      EDITOR = "vim";
    };
    services.dunst = {
      enable = true;
      settings = {
        global = {
          startup_notification = true;
          follow = "mouse";
          geometry = "300x6-10+30";
          transparency = 0;
          font = "Hack Regular 8";
          markup = "full";
          format = "<b>%s</b>\n%b";
          padding = 8;
          horizontal_padding = 8;
          frame_width = 2;
          frame_color = "#788388";
          sort = "yes";
          browser = "firefox";
          icon_position = "left";
          max_icon_size=32;
        };
      };
    };
    programs.firefox = {
      enable = true;
      extensions = with ffAddons; [
        dark-night-mode
        facebook-container
        ghostery
        multi-account-containers
        octotree
        ublock-origin        
      ];
    };
    programs.git = {
      enable = true;
      userEmail = userSecrets.gitUserEmail;
      userName = "Aleksander Gondek";
      extraConfig = {
        core = {
          editor = "vim";
        };
      };
      signing = {
        key = userSecrets.gitGpgSigningKey;
        signByDefault = true;
      };
    };
    programs.zsh = {
      enable = true;
      enableAutosuggestions = true;

      shellAliases = {
        vpn-on = ''sudo openconnect \
          --protocol=gp \
          --usergroup=portal \
          --authgroup=Gdansk \
          --user=${userSecrets.gitUserEmail} \
          --pid-file=/tmp/openconnect.pid \
          --csd-wrapper=${pkgs.openconnect}/libexec/openconnect/hipreport.sh \
          ${userSecrets.workVpnIngress}
        '';
        vpn-fix = "sudo /home/agondek/.gpvpn/fix";
        vpn-off = "sudo kill $(cat /tmp/openconnect.pid)";
      };

      oh-my-zsh = {
        enable = true;
        plugins = [];
        theme = "agnoster";
      };
    };
  };

  nix.trustedUsers = [ "root" "agondek" ];
}
