# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ inputs, config, pkgs, ... }:

let
  # unstable = import <nixos-unstable> { config = { allowUnfree = true; }; };
in
{
  nix.settings.experimental-features = [ "nix-command" "flakes" ];

  imports =
    [ # Include the results of the hardware scan.
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

  nixpkgs = {
    config = {
      allowUnfree = true;
      pulseaudio = true;
    };
  };

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.saul = {
    isNormalUser = true;
    description = "Saul Marquez";
    extraGroups = [ "networkmanager" "wheel" ];
    packages = with pkgs; [];
  };

  fonts.packages = with pkgs; [
    font-awesome
    fira-code-nerdfont
    (nerdfonts.override { fonts = ["NerdFontsSymbolsOnly"];})
  ];

  environment.systemPackages = with pkgs; [
    alacritty
    fish
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
    alsa-utils
    pulseaudioFull
    rofi
    git
    gh
    vim
    btop
    lsof
    bat
    unrar
    unzip
    lnav
    inputs.neovim-nightly-overlay.packages.${pkgs.system}.default
    firefox
    firefoxpwa
    pinta
    teams-for-linux
    zoxide
    fzf
    ripgrep
    docker
    kubectl
    azure-cli
    azure-functions-core-tools
    gcc
    lua51Packages.lua
    lua-language-server
    (with dotnetCorePackages; combinePackages [
      sdk_6_0
      sdk_8_0
    ])
    python311Full
    poetry
    nodejs
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
    system.stateVersion = "23.11";
}
