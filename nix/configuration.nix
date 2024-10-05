# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ inputs, pkgs, ... }:


{
  system.stateVersion = "24.05";
  nix.settings.experimental-features = [ "nix-command" "flakes" ];

  imports = [
    ./hardware-configuration.nix
  ];

  # Bootloader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  networking = {
    firewall = {
      enable = true;
      allowedTCPPorts = [];
      allowedUDPPorts = [];
    };
    hostName = "Nixos";
    networkmanager.enable = true;
  };

  # Set your time zone.
  time.timeZone = "Europe/Madrid";

  # Select internationalisation properties.
  i18n.defaultLocale = "en_US.UTF-8";

  i18n.extraLocaleSettings = {
    LC_ADDRESS = "es_ES.UTF-8";
    LC_IDENTIFICATION = "es_ES.UTF-8";
    LC_MEASUREMENT = "es_ES.UTF-8";
    LC_MONETARY = "es_ES.UTF-8";
    LC_NAME = "es_ES.UTF-8";
    LC_NUMERIC = "es_ES.UTF-8";
    LC_PAPER = "es_ES.UTF-8";
    LC_TELEPHONE = "es_ES.UTF-8";
    LC_TIME = "es_ES.UTF-8";
  };

  services = {
    gnome = {
      gnome-keyring.enable = true;
    };
    gvfs.enable = true;
    blueman.enable = true;
    pipewire = {
      enable = true;
      alsa = {
        enable = true;
        support32Bit = true;
      };
      pulse.enable = true;
      jack.enable = true;
    };
    greetd = {
      enable = true;
      settings = rec {
        initial_session = {
          command = "Hyprland";
          user = "saul";
        };
        default_session = initial_session;
      };
    };
  };

  virtualisation.docker = {
    enable = true;
    rootless.enable = true;
  };

  programs = {
    git = {
      enable = true;
      lfs.enable = true;
    };
    fish = {
      enable = true;
    };
    bash = {
      interactiveShellInit = ''
        if [[ $(${pkgs.procps}/bin/ps --no-header --pid=$PPID --format=comm) != "fish" && -z ''${BASH_EXECUTION_STRING} ]]
          then
            shopt -q login_shell && LOGIN_OPTION='--login' || LOGIN_OPTION=""
            exec ${pkgs.fish}/bin/fish $LOGIN_OPTION
            fi
            '';
    };
    hyprland = {
      enable = true;
      xwayland.enable = true;

    };
    appimage = {
      enable = true;
      binfmt = true;
    };
    thunar.enable = true;
    dconf.enable = true;
  };

  xdg.portal.enable = true;
  xdg.portal.extraPortals = [ pkgs.xdg-desktop-portal-gtk ];

  users.users.saul = {
    isNormalUser = true;
    description = "Saul Marquez";
    extraGroups = [ "networkmanager" "wheel" "docker" ];
    packages = [];
  };

  documentation.man.generateCaches = false;

  stylix = {
    enable = true;
    base16Scheme = "${pkgs.base16-schemes}/share/themes/classic-dark.yaml";
    image = ./tiles.jpg;
  };

  environment.sessionVariables = {
    FLAKE = "/home/saul/dotfiles";
    NIXOS_OZONE_WL = "1";
    GTK_THEME = "Adwaita:dark";
    GTK2_RC_FILES = "${pkgs.gnome-themes-extra}/share/themes/Adwaita/gtk-2.0/gtkrc";
  };

  nixpkgs = {
    config = {
      allowUnfree = true;
      pulseaudio = true;
    };
  };

  fonts.packages = with pkgs; [
    font-awesome
    (nerdfonts.override { fonts = ["NerdFontsSymbolsOnly"];})
  ];

  environment.systemPackages = with pkgs; [
    # X
    steam-run
    dmenu
    xclip
    gnome-keyring
    networkmanagerapplet
    pasystray
    picom
    polkit_gnome
    xss-lock
    rofi-wayland
    alsa-utils
    pulseaudioFull
    kitty
    pavucontrol
    glib
    gnome-themes-extra
    hyprshot

    waybar
    (pkgs.waybar.overrideAttrs (
      oldAttrs: {
        mesonFlags = oldAttrs.mesonFlags ++ [ "-Dexperimental=true" ];
      })
    )
    dunst
    libnotify
    swww

    brave
    inputs.zen-browser.packages.${pkgs.system}.default

    # Basics
    # alacritty
    # fish
    vim
    nh
    inputs.neovim-nightly-overlay.packages.${pkgs.system}.default

    # archives
    zip
    xz
    unzip
    p7zip
    unrar

    # Monitor
    btop  # replacement of htop/nmon
    iotop # io monitoring
    iftop # network monitoring
    strace # system call monitoring
    ltrace # library call monitoring
    lsof # list open files
    sysstat
    lm_sensors # for `sensors` command
    ethtool
    pciutils # lspci
    usbutils # lsusb

    # utils
    killall
    bat
    zoxide
    ripgrep # recursively searches directories for a regex pattern
    jq # A lightweight and flexible command-line JSON processor
    yq-go # yaml processor https://github.com/mikefarah/yq
    eza # A modern replacement for ‘ls’
    fzf # A command-line fuzzy finder
    glow # markdown previewer in terminal
    lnav
    # atuin

    # development tools
    git-lfs
    gh
    docker
    kubectl
    (azure-cli.withExtensions [
     azure-cli-extensions.azure-devops
    ])
    azure-functions-core-tools
    gcc
    cmake
    postman
    bruno
    redisinsight
    sqlcmd

     # Python
    python311Full
    python311Packages.zipp
    python311Packages.wrapt
    # python312Full
    poetry
    ruff
    fastapi-cli


    # JS
    nodejs

    # Dotnet
    (with dotnetCorePackages; combinePackages [
      sdk_6_0
      sdk_8_0
    ])

    # Lua
    lua51Packages.lua
    sumneko-lua-language-server

    # Pulumi
    pulumi
    pulumiPackages.pulumi-language-nodejs

    # Rust
    rustc
    cargo
  ];

  security = {
    polkit.enable = true;
    rtkit.enable = true;
  };

  systemd = {
    user.services.polkit-gnome-authentication-agent-1 = {
      description = "polkit-gnome-authentication-agent-1";
      wantedBy = [ "graphical-session.target" ];
      wants = [ "graphical-session.target" ];
      after = [ "graphical-session.target" ];
      serviceConfig = {
        Type = "simple";
        ExecStart =
          "${pkgs.polkit_gnome}/libexec/polkit-gnome-authentication-agent-1";
        Restart = "on-failure";
        RestartSec = 1;
        TimeoutStopSec = 10;
      };
    };
  };

  hardware = {
    bluetooth.enable = true;
  };
}
