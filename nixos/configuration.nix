# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, overlays, ... }:

{
#  nixpkgs.overlays = [
#    (import ./st-overlay.nix)
#  ];

    imports =
        [ # Include the results of the hardware scan.
        ./hardware-configuration.nix
            <home-manager/nixos>
        ];

# Bootloader.
    boot.loader.systemd-boot.enable = true;
    boot.loader.efi.canTouchEfiVariables = true;
    boot.supportedFilesystems = [ "ntfs" ];
    time.hardwareClockInLocalTime = true;

    fileSystems."/media/NewVolume" = {
        device = "/dev/nvme0n1p1";
        fsType = "ntfs-3g";
        options = [ "defaults" "nofail" "rw" "uid=1000" ];
    };

    # Make sure opengl is enabled
  hardware.opengl = {
    enable = true;
    driSupport = true;
    driSupport32Bit = true;
  };

    networking.hostName = "nixos"; # Define your hostname.
# networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.

# Configure network proxy if necessary
# networking.proxy.default = "http://user:password@proxy:port/";
# networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

# Enable networking
        networking.networkmanager.enable = true;
    nix.settings.experimental-features = "nix-command flakes";
# Set your time zone.
    time.timeZone = "Asia/Kolkata";

# Select internationalisation properties.
    i18n.defaultLocale = "en_US.UTF-8";

    i18n.extraLocaleSettings = {
        LC_ADDRESS = "en_IN";
        LC_IDENTIFICATION = "en_IN";
        LC_MEASUREMENT = "en_IN";
        LC_MONETARY = "en_IN";
        LC_NAME = "en_IN";
        LC_NUMERIC = "en_IN";
        LC_PAPER = "en_IN";
        LC_TELEPHONE = "en_IN";
        LC_TIME = "en_IN";
    };

# Configure keymap in X11
    services.xserver = {
        enable = true;
        layout = "us";
        xkbVariant = "";

        desktopManager = {
            xterm.enable = false;
        };

        displayManager = {
            defaultSession = "none+i3";
        };

        windowManager.i3 = {
            enable = true;
            extraPackages = with pkgs; [
                dmenu
                    i3status
                    i3lock
                    i3blocks
                    networkmanagerapplet
            ];
        };
    };

# rtkit is optional but recommended
    security.rtkit.enable = true;
    services.pipewire = {
        enable = true;
        alsa.enable = true;
        alsa.support32Bit = true;
        pulse.enable = true;
# If you want to use JACK applications, uncomment this
#jack.enable = true;
    };

# Define a user account. Don't forget to set a password with ‘passwd’.

    home-manager = {
        useGlobalPkgs = true;
        useUserPackages = true;
    };

    programs.zsh.enable = true;
    users.defaultUserShell = pkgs.zsh;
    environment.shells = with pkgs; [ zsh ];

    home-manager.users.omkar = { pkgs, osConfig, ... }: {
        home.packages = [ ];
        home.stateVersion = "23.05";
        programs.zsh = {
            enable = true;
            shellAliases = {
                ll = "ls -l";
                update = "sudo nixos-rebuild switch";
                ftp = "sudo curlftpfs -o allow_other";
            };
# Your zsh config
            oh-my-zsh = {
                enable = true;
                plugins = [ "git" ];
                theme = "robbyrussell";
            };
        };
    };

    users.users.omkar = {
        isNormalUser = true;
        description = "Omkar Nandan";
        extraGroups = [ "networkmanager" "wheel" "video" "root" "fuse" ];
        packages = with pkgs; [];
    };

# Allow unfree packages
    nixpkgs.config.allowUnfree = true;
    fonts.fonts = with pkgs; [
        noto-fonts
            noto-fonts-emoji
            liberation_ttf
            mplus-outline-fonts.githubRelease
            dina-font
            proggyfonts
            (nerdfonts.override { fonts = [ "FiraCode" ]; })
    ];
# List packages installed in system profile. To search, run:
# $ nix search wget
    environment.systemPackages = with pkgs; [
        acpi
            ansible
            brightnessctl
            cmake
            cmus
            curlftpfs
            dbus
            evince
            firefox
            gcc
            git
            glibc
            glibc.static
            gnome.nautilus
            gnumake
            htop
            jupyter
            libreoffice-fresh
            lxappearance
            moc
            mpv
            neovim
            nodejs
            ntfs3g
            obsidian
            playerctl
            python3Full
            python310Packages.pip
            R
            rstudioWrapper
            stdenv
            stow
            tmux
            ubuntu-themes
            unzip
            vlc
            xclip
            xfce.ristretto
            xfce.thunar
            xfce.tumbler
            xfce.thunar-archive-plugin
            xfce.thunar-volman
            (st.overrideAttrs (oldAttrs: rec {
                               src = fetchFromGitHub {
                               owner = "LukeSmithxyz";
                               repo = "st";
                               rev = "8ab3d03681479263a11b05f7f1b53157f61e8c3b";
                               sha256 = "1brwnyi1hr56840cdx0qw2y19hpr0haw4la9n0rqdn0r2chl8vag";
                               };
# Make sure you include whatever dependencies the fork needs to build properly!
                               buildInputs = oldAttrs.buildInputs ++ [ harfbuzz ];
# If you want it to be always up to date use fetchTarball instead of fetchFromGitHub
# src = builtins.fetchTarball {
#   url = "https://github.com/lukesmithxyz/st/archive/master.tar.gz";
# };
                               }))
    ];
# Some programs need SUID wrappers, can be configured further or are
# started in user sessions.
# programs.mtr.enable = true;
# programs.gnupg.agent = {
#   enable = true;
#   enableSSHSupport = true;
# };

# List services that you want to enable:

# Enable the OpenSSH daemon.
# services.openssh.enable = true;

# Open ports in the firewall.
# networking.firewall.allowedTCPPorts = [ ... ];
# networking.firewall.allowedUDPPorts = [ ... ];
# Or disable the firewall altogether.
# networking.firewall.enable = false;

# This value determines the NixOS release from which the default
# settings for stateful data, like file locations and database versions
# on your system were taken. It‘s perfectly fine and recommended to leave
# this value at the release version of the first install of this system.
# Before changing this value read the documentation for this option
# (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
    system.stateVersion = "23.05"; # Did you read the comment?

}
