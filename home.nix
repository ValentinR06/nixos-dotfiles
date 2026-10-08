{ config, pkgs, ... }:

{
  home.username = "valentin";
  home.homeDirectory = "/home/valentin";
  home.stateVersion = "26.05";
  
  home.packages = with pkgs; [
    grc
    fzf
    fastfetch
  ];
  
  programs.fish = {
    enable = true;
    shellAliases = {
      btw = "echo i use hyprland btw";
      rebuild = "sudo nixos-rebuild switch --flake ~/nixos-dotfiles#hyprland-btw";
      update = "nix flake update --flake ~/nixos-dotfiles && sudo nixos-rebuild switch --flake ~/nixos-dotfiles#hyprland-btw";
      
      ls = "eza --icons=always --color=always";
      ll = "eza -lh --icons=always --color=always";
      la = "eza -lah --icons=always --color=always";
      tree = "eza --tree --icons=always --color=always";
    };

    interactiveShellInit = ''
      # Standard-Begrüßung deaktivieren
      set -g fish_greeting ""
      
      # Optional: System-Infos beim Start im Terminal anzeigen
      # fastfetch
    '';

    loginShellInit = ''
      if test -z "$WAYLAND_DISPLAY"; and test "$XDG_VTNR" = 1
        exec start-hyprland
      end
    '';

    plugins = [
      {
        name = "grc";
        src = pkgs.fishPlugins.grc.src;
      }
      {
        name = "fzf-fish";
        src = pkgs.fishPlugins.fzf-fish.src;
      }
    ];
  };

  programs.starship = {
    enable = true;
    enableFishIntegration = true;
    settings = {
      add_newline = true;
      character = {
        success_symbol = "[➜](bold green)";
        error_symbol = "[✗](bold red)";
      };
    };
  };

  programs.eza = {
    enable = true;
    enableFishIntegration = true;
  };

  home.pointerCursor = {
    enable = true;
    gtk.enable = true;
    x11.enable = true;
    name = "Bibata-Modern-Ice";
    package = pkgs.bibata-cursors;
    size = 24;
  };

  programs.git = {
    enable = true;
    settings = {
      user = {
        name  = "ValentinRoegl";
        email = "valentin091106@gmail.com";
      };

      init.defaultBranch = "main";
      pull.rebase = true;
      core.editor = "nvim";
    };
  };

  xdg.configFile."hypr" = {
    source = ./config/hypr;
    recursive = true; 
  };
  
  xdg.configFile."quickshell" = {
    source = ./config/quickshell;
    recursive = true;
  };

  xdg.configFile."kitty" = {
    source = ./config/kitty;
    recursive = true;
  };

  xdg.configFile."hypr/colors.lua".source = 
    config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/.cache/theme/hypr/colors.lua";

  xdg.configFile."quickshell/Colors.qml".source = 
    config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/.cache/theme/quickshell/Colors.qml";
  
  xdg.configFile."kitty/colors.conf".source = 
    config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/.cache/theme/kitty/colors.conf";
}