# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ inputs, pkgs, stylix, ... }:


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

  environment.sessionVariables = {
    FLAKE = "/home/saul/dotfiles";
  };

  services = {
    xserver = {
      xkb = {
        layout = "us,es";
        variant = "";
        options="grp:alt_shift_toggle";
      };
      enable = true;
      windowManager.i3 = {
        enable = true;
        extraPackages = with pkgs; [
          i3status
          i3lock
          i3status-rust
          kbdd
        ];
      };
      desktopManager = {
        xterm.enable = false;
        xfce = {
          enable = true;
          noDesktop = true;
          enableXfwm = false;
        };
      };
      displayManager = {
        lightdm.enable = true;
      };
    };
    displayManager = {
      defaultSession = "xfce+i3";
    };
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
  };

  users.users.saul = {
    isNormalUser = true;
    description = "Saul Marquez";
    extraGroups = [ "networkmanager" "wheel" "docker" ];
    packages = with pkgs; [];
  };

  stylix = {
    enable = true;
    base16Scheme = "${pkgs.base16-schemes}/share/themes/classic-dark.yaml";
    image = ./tiles.jpg;
  };

  nixpkgs = {
    config = {
      allowUnfree = true;
      pulseaudio = true;
    };
  };

  fonts.packages = with pkgs; [
    font-awesome
    fira-code-nerdfont
    (nerdfonts.override { fonts = ["NerdFontsSymbolsOnly"];})
  ];

  environment.systemPackages = with pkgs; [
    # X
    steam-run
    dmenu
    xclip
    gnome-keyring
    networkmanagerapplet
    nitrogen
    pasystray
    picom
    polkit_gnome
    xss-lock
    rofi
    alsa-utils
    pulseaudioFull

    # Basics
    # alacritty
    fish
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
    bat
    zoxide
    ripgrep # recursively searches directories for a regex pattern
    jq # A lightweight and flexible command-line JSON processor
    yq-go # yaml processor https://github.com/mikefarah/yq
    eza # A modern replacement for ‘ls’
    fzf # A command-line fuzzy finder
    glow # markdown previewer in terminal
    lnav

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

     # Python
    python311Full
    python312Full
    poetry


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
  programs = {
    thunar.enable = true;
    dconf.enable = true;
  };

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
