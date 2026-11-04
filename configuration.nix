{ config, lib, pkgs, ... }:

{
  imports =
    [
      ./hardware-configuration.nix
    ];

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  networking.hostName = "hyprland-btw";
  networking.networkmanager.enable = true;

  hardware.bluetooth.enable = true;
  hardware.bluetooth.powerOnBoot = true;

  hardware.graphics = {
    enable = true;
    enable32Bit = true;
  };

  services.upower.enable = true;

  time.timeZone = "Europe/Vienna";

  services.getty.autologinUser = "valentin";

  programs.hyprland = {
    enable = true;
    xwayland.enable = true;
  };

  users.users.valentin = {
    isNormalUser = true;
    shell = pkgs.fish;
    extraGroups = [ "wheel" ];
  };

  nixpkgs.config.allowUnfree = true;

  programs.fish.enable = true;
  programs.firefox.enable = true;
  programs.helium.enable = true;

  programs.steam = {
    enable = true;
    remotePlay.openFirewall = true;
    dedicatedServer.openFirewall = true;
  };

  environment.systemPackages = with pkgs; [
    vim
    neovim
    wget
    git
    brightnessctl
  ];

  fonts.packages = with pkgs; [
    jetbrains-mono
  ]
  ++ builtins.filter lib.attrsets.isDerivation (builtins.attrValues pkgs.nerd-fonts);

  nix.settings.experimental-features = [ "nix-command" "flakes" ];

  system.stateVersion = "26.05";
}

