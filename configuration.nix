{ config, pkgs, ... }:
{
  imports = [ ./hardware-configuration.nix ];
  # Bootloader
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.kernelParams = [ "elevator=none" ];
  boot.kernelModules = [ "kvm-intel" ];
  boot.extraModprobeConfig = "options kvm_intel nested=1";

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
    extraGroups = [ "networkmanager" "wheel" "docker" "libvirtd" "kvm" ];
    shell = pkgs.zsh;
  };

  # Programmes
  programs.zsh.enable = true;
  programs.firefox.enable = true;
  nixpkgs.config.allowUnfree = true;

  # Documentation / man pages
  documentation = {
    enable = true;
    man.enable = true;
    dev.enable = true;
  };

  # nix-ld pour exécuter des binaires dynamiques génériques (Claude Code, etc.)
  programs.nix-ld = {
    enable = true;
    libraries = with pkgs; [
      stdenv.cc.cc.lib
      zlib
      openssl
      glibc
      # utiles pour binaires précompilés courants
      libGL
      libxkbcommon
      fontconfig
      freetype
      xorg.libX11
      xorg.libXrandr
      xorg.libXi
      xorg.libXcursor
      xorg.libxcb
    ];
  };

  # SSH
  services.openssh = {
    enable = true;
    settings = {
      PasswordAuthentication = true;
      PermitRootLogin = "no";
    };
  };
  networking.firewall.allowedTCPPorts = [ 22 ];

  # Virtualisation
  virtualisation.virtualbox.guest.enable = true;
  virtualisation.docker.enable = true;
  virtualisation.libvirtd = {
    enable = true;
    qemu = {
      package = pkgs.qemu_kvm;
      runAsRoot = true;
      swtpm.enable = true;
    };
  };
  networking.firewall.trustedInterfaces = [ "virbr0" ];

  # Packages
  environment.systemPackages = with pkgs; [
    vagrant
    virt-manager      # GUI optionnelle
    qemu_kvm
    libvirt
    obs-studio
    ffmpeg-full   # ffmpeg avec tous les codecs
    mpv
    grub2
    xorriso
    binutils
    libreoffice-fresh
    pkgsi686Linux.glibc
    steam-run
    # Man pages
    man-pages
    man-pages-posix
    # Editeurs
    vscode vim nano gnome-tweaks
    # Dev
    git gnumake cmake gcc gdb valgrind clang llvm nasm yasm
    gnomeExtensions.arcmenu
    gnome-terminal
    # Docker
    docker docker-compose
    # Réseau
    curl wget tcpdump nmap net-tools
    (pkgs.writeShellScriptBin "pi" ''exec ${pkgs.inetutils}/bin/ping "$@"'')
    # Système
    htop btop tree unzip zip file lsof strace
    gnomeExtensions.desktop-icons-ng-ding
    (python3.withPackages (ps: with ps; [
      readline iputils
      requests
      nodejs
      beautifulsoup4
      lxml
      numpy
      scipy
      matplotlib
      pillow
      pandas
    ]))
    # Shell
    zsh tmux fzf ripgrep bat eza
    # GNOME
    gnomeExtensions.dash-to-dock
  ];

  system.stateVersion = "25.11";
}