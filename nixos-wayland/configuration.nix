# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, overlays, ... }:

let
# bash script to let dbus know about important env variables and
# propagate them to relevent services run at the end of sway config
# see
# https://github.com/emersion/xdg-desktop-portal-wlr/wiki/"It-doesn't-work"-Troubleshooting-Checklist
# note: this is pretty much the same as  /etc/sway/config.d/nixos.conf but also restarts
# some user services to make sure they have the correct environment variables
dbus-sway-environment = pkgs.writeTextFile {
    name = "dbus-sway-environment";
    destination = "/bin/dbus-sway-environment";
    executable = true;

    text = ''
        dbus-update-activation-environment --systemd WAYLAND_DISPLAY XDG_CURRENT_DESKTOP=sway
        systemctl --user stop pipewire pipewire-media-session xdg-desktop-portal xdg-desktop-portal-wlr
        systemctl --user start pipewire pipewire-media-session xdg-desktop-portal xdg-desktop-portal-wlr
        '';
};

# currently, there is some friction between sway and gtk:
# https://github.com/swaywm/sway/wiki/GTK-3-settings-on-Wayland
# the suggested way to set gtk settings is with gsettings
# for gsettings to work, we need to tell it where the schemas are
# using the XDG_DATA_DIR environment variable
# run at the end of sway config
configure-gtk = pkgs.writeTextFile {
    name = "configure-gtk";
    destination = "/bin/configure-gtk";
    executable = true;
    text = let
        schema = pkgs.gsettings-desktop-schemas;
    datadir = "${schema}/share/gsettings-schemas/${schema.name}";
    in ''
        export XDG_DATA_DIRS=${datadir}:$XDG_DATA_DIRS
        gnome_schema=org.gnome.desktop.interface
        gsettings set $gnome_schema gtk-theme 'Dracula'
        '';
};
in
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
            foot
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
            dbus-sway-environment
            configure-gtk
            wayland
            xdgutils
            swaylock
            swayidle
            wl-clipboard
            bemenu
            ];
    services.dbus.enable = true;
    xdg.portal = {
        enable = true;
        wlr.enable = true;
# gtk portal needed to make gtk apps happy
        extraPortals = [ pkgs.xdg-desktop-portal-gtk ];
    };

# enable sway window manager
    programs.sway = {
        enable = true;
        wrapperFeatures.gtk = true;
    };

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
