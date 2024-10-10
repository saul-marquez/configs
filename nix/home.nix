{ lib, config, pkgs, ... }:

{
  home.username = "saul";
  home.homeDirectory = "/home/saul";

  # link the configuration file in current directory to the specified location in home directory
  # home.file.".config/i3/wallpaper.jpg".source = ./wallpaper.jpg;

  # link all files in `./scripts` to `~/.config/i3/scripts`
  # home.file.".config/i3/scripts" = {
  #   source = ./scripts;
  #   recursive = true;   # link recursively
  #   executable = true;  # make all files executable
  # };

  # encode the file content in nix configuration file directly
  # home.file.".xxx".text = ''
  #     xxx
  # '';

  # Packages that should be installed to the user profile.
  home.packages = with pkgs; [
    # networking tools
    # mtr # A network diagnostic tool
    # iperf3
    # dnsutils  # `dig` + `nslookup`
    # ldns # replacement of `dig`, it provide the command `drill`
    # aria2 # A lightweight multi-protocol & multi-source command-line download utility
    # socat # replacement of openbsd-netcat
    # nmap # A utility for network discovery and security auditing
    # ipcalc  # it is a calculator for the IPv4/v6 addresses

    # logs

    pinta
    meld
    teams-for-linux
  ];

  programs.git = {
    enable = true;
    lfs.enable = true;
    userName = "Saul Marquez";
    userEmail = "saul.marquez@mdw-group.com";
    extraConfig.color.ui = true;
  };

  programs.alacritty = lib.mkForce {
    enable = true;
    # custom settings
    settings = {
      env.TERM = "xterm-256color";
      font = {
        size = 14;
        normal = {
          family = "FiraCode Nerd Font Mono";
          style = "Regular";
        };
      };
      shell.program = "/home/saul/.nix-profile/bin/fish";
      window.opacity = 0.97;
    };
  };

  programs.kitty = {
    enable = true;
    font = lib.mkForce {
      package = pkgs.fira-code-nerdfont;
      name = "FiraCode Nerd Font Mono";
      size = 15;
    };
    shellIntegration.enableFishIntegration = true;
  };

  # programs.tmux = {
  #   enable = true;
  #   clock24 = true;
  #   shell = "${pkgs.fish}/bin/fish";
  #   terminal = "xterm-256color";
  #   plugins = with pkgs;
  #     [
  #       {
  #         plugin = tmuxPlugins.resurrect;
  #         extraConfig = ''
  #         set -g @resurrect-strategy-vim 'session'
  #         set -g @resurrect-strategy-nvim 'session'
  #         set -g @resurrect-capture-pane-contents 'on'
  #         '';
  #       }
  #       {
  #         plugin = tmuxPlugins.continuum;
  #         extraConfig = ''
  #           set -g @continuum-restore 'on'
  #           set -g @continuum-boot 'on'
  #           set -g @continuum-save-interval '10'
  #           '';
  #       }
  #   ];
  # };

  # This value determines the home Manager release that your
  # configuration is compatible with. This helps avoid breakage
  # when a new home Manager release introduces backwards
  # incompatible changes.
  #
  # You can update home Manager without changing this value. See
  # the home Manager release notes for a list of state version
  # changes in each release.
  home.stateVersion = "24.05";

  # Let home Manager install and manage itself.
  programs.home-manager.enable = true;
}
