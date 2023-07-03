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
        ];

# Bootloader.
    boot.loader.systemd-boot.enable = true;
    boot.loader.efi.canTouchEfiVariables = true;

    networking.hostName = "nixos"; # Define your hostname.
# networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.

# Configure network proxy if necessary
# networking.proxy.default = "http://user:password@proxy:port/";
# networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

# Enable networking
        networking.networkmanager.enable = true;

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
    users.users.omkar = {
        isNormalUser = true;
        description = "Omkar Nandan";
        extraGroups = [ "networkmanager" "wheel" "video" ];
        packages = with pkgs; [];
    };

# Allow unfree packages
    nixpkgs.config.allowUnfree = true;
    fonts.fonts = with pkgs; [
        noto-fonts
            noto-fonts-cjk
            noto-fonts-emoji
            liberation_ttf
            fira-code
            fira-code-symbols
            mplus-outline-fonts.githubRelease
            dina-font
            proggyfonts
            (nerdfonts.override { fonts = [ "JetBrainsMono" "DroidSansMono" ]; })
    ];
# List packages installed in system profile. To search, run:
# $ nix search wget
    environment.systemPackages = with pkgs; [
        acpi
        ansible
        brightnessctl
        firefox
        gcc
        glibc
        glibc.static
        git
        htop
        neovim
        nodejs
        ntfs3g
        stdenv
        stow
        tmux
        xclip
        xfce.thunar
        xfce.thunar-volman
        (st.overrideAttrs (oldAttrs: rec {
                           patches = [
                           ( fetchpatch {
                             url = "http://st.suckless.org/patches/xresources/st-xresources-20200604-9ba7ecf.diff";
                             sha256 = "0nsda5q8mkigc647p1m8f5jwqn3qi8194gjhys2icxji5c6v9sav";
                             })
                           ( fetchpatch {
                             url = "http://st.suckless.org/patches/bold-is-not-bright/st-bold-is-not-bright-20190127-3be4cf1.diff" ;
                             sha256 = "1cpap2jz80n90izhq5fdv2cvg29hj6bhhvjxk40zkskwmjn6k49j" ;
                             })
                           ( fetchpatch {
                             url = "http://st.suckless.org/patches/clipboard/st-clipboard-0.8.3.diff" ;
                             sha256 = "1h1nwilwws02h2lnxzmrzr69lyh6pwsym21hvalp9kmbacwy6p0g" ;
                             })
                           ( fetchpatch {
                             url = "http://st.suckless.org/patches/anysize/st-anysize-20220718-baa9357.diff" ;
                             sha256 = "1ym5d2f85l3avgwf9q93aymdg23aidprqwyh9s1fdpjvyh80rvvq" ;
                             })
                           ];
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
