{ config, pkgs, ... }:

{
  imports = [ ./hardware-configuration.nix ];

  # Bootloader
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.kernelParams = [ "elevator=none" ];

  # Réseau
  networking.hostName = "nixos";
  networking.networkmanager.enable = true;

  # Timezone / Locale
  time.timeZone = "Europe/Paris";
  i18n.defaultLocale = "en_US.UTF-8";
  i18n.extraLocaleSettings = {
    LC_ADDRESS = "fr_FR.UTF-8";
    LC_IDENTIFICATION = "fr_FR.UTF-8";
    LC_MEASUREMENT = "fr_FR.UTF-8";
    LC_MONETARY = "fr_FR.UTF-8";
    LC_NAME = "fr_FR.UTF-8";
    LC_NUMERIC = "fr_FR.UTF-8";
    LC_PAPER = "fr_FR.UTF-8";
    LC_TELEPHONE = "fr_FR.UTF-8";
    LC_TIME = "fr_FR.UTF-8";
  };

  # Display
  services.xserver.enable = true;
  services.xserver.videoDrivers = [ "virtualbox" ];
  services.xserver.xkb = { layout = "us"; variant = ""; };
  services.displayManager.gdm.enable = true;
  services.desktopManager.gnome.enable = true;

  # GNOME extensions activées
  environment.gnome.excludePackages = [];

  # Son
  services.pulseaudio.enable = false;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
  };

  # Utilisateur
  users.users.throbert = {
    isNormalUser = true;
    description = "throbert";
    extraGroups = [ "networkmanager" "wheel" "docker" ];
    shell = pkgs.zsh;
  };

  # Programmes
  programs.zsh.enable = true;
  programs.firefox.enable = true;
  nixpkgs.config.allowUnfree = true;

  # Virtualisation
  virtualisation.virtualbox.guest.enable = true;
  virtualisation.docker.enable = true;

  # Packages
  environment.systemPackages = with pkgs; [
    # Editeurs
    vscode vim nano gnome-tweaks

    # Dev
    git gnumake cmake gcc gdb valgrind clang llvm

    gnomeExtensions.arcmenu
    
    gnome-terminal 
    # Docker
    docker docker-compose

    # Réseau
    curl wget tcpdump nmap nettools

    # Système
    htop btop tree unzip zip file lsof strace

    gnomeExtensions.desktop-icons-ng-ding
    
    python3
    python3Packages.pip

    # Shell
    zsh tmux fzf ripgrep bat eza

    # GNOME
    gnomeExtensions.dash-to-dock
  ];

  system.stateVersion = "25.11";
}