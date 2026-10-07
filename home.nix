{ config, pkgs, ... }:

{
  home.username = "valentin";
  home.homeDirectory = "/home/valentin";
  home.stateVersion = "26.05";
  programs.bash = {
    enable = true;
    shellAliases = {
      btw = "echo i use hyprland btw";
      rebuild = "sudo nixos-rebuild switch --flake ~/nixos-dotfiles#hyprland-btw";
      update = "nix flake update --flake ~/nixos-dotfiles && sudo nixos-rebuild switch --flake ~/nixos-dotfiles#hyprland-btw";
    };
    profileExtra = ''
      if [ -z "$WAYLAND_DISPLAY" ] && [ "XDG_VTNR" = 1 ]; then
        exec start-hyprland
      fi
    '';
  };

  programs.git = {
    enable = true;
    settings.user.name  = "ValentinRoegl";
    settings.user.email = "valentin091106@gmail.com";

    extraConfig = {
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

