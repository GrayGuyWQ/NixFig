# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, ... }:

{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix

      #Imports da Home Manager module.
      #<home-manager/nixos>
    ];

  
  #Home Manager user confg
  #home-manager.users.gray = {

    #Sets the current NixOS channel
   # home.stateVersion = "25.05";

    #Imports config sturf from the home.nix file
    #imports = [./home.nix];

  #};

  #labs
  #networking.extraHosts = 
  #"10.10.200.53 wpscan.thm"
  #;


  # Bootloader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;  

  #GRUB stuff
  #boot.loader.grub.enable = true;
  #boot.loader.grub.device = "nodev";
  #boot.loader.grub.useOSProber = true;
  #boot.loader.grub.efiSupport = true;
  #boot.loader.grub.extraEntries = "GRUB_DISABLE_OS_PROBER = false";
# useOSProber = true;

  networking.hostName = "nix"; # Define your hostname.
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  # Enable networking
  networking.networkmanager.enable = true;

  # Set your time zone.
  time.timeZone = "America/Los_Angeles";

  # Select internationalisation properties.
  i18n.defaultLocale = "en_US.UTF-8";

  i18n.extraLocaleSettings = {
    LC_ADDRESS = "en_US.UTF-8";
    LC_IDENTIFICATION = "en_US.UTF-8";
    LC_MEASUREMENT = "en_US.UTF-8";
    LC_MONETARY = "en_US.UTF-8";
    LC_NAME = "en_US.UTF-8";
    LC_NUMERIC = "en_US.UTF-8";
    LC_PAPER = "en_US.UTF-8";
    LC_TELEPHONE = "en_US.UTF-8";
    LC_TIME = "en_US.UTF-8";
  };

  # i915.force_probe=7d55
  boot.kernelParams = [ "i915.force_probe=7d55" ]; 
  boot.kernelModules = [ "i915" ];
  

  #THIS WORKED
  boot.kernelPackages = pkgs.linuxPackages_latest;

 # nixpkgs.config.firefox.enablePlasmaBrowserIntegration = true;  

  # Enable the X11 windowing system.
  # You can disable this if you're only using the Wayland session.
  services.xserver.enable = true; 
  
  services.xserver.videoDrivers = [ "modesetting" ];   

  # Enable the KDE Plasma Desktop Environsment.
  services.displayManager.sddm.enable = true;
  services.desktopManager.plasma6.enable = true;

  # Configure keymap in X11
   services.xserver.xkb = {
    layout = "us";
    variant = "";
  };


  #Enable home.nix <--This was me
#  programs.home-manager.enable = true;
 # home-manager.users.gray = import ./home.nix;


  # Enable CUPS to print documents.
  services.printing.enable = true;

  # Enable sound with pipewire.
  hardware.pulseaudio.enable = false;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    # If you want to use JACK applications, uncomment this
    #jack.enable = true;

    # use the example session manager (no others are packaged yet so this is enabled by default,
    # no need to redefine it in your config for now)
    #media-session.enable = true;
  };
  hardware.bluetooth.enable = true;
  hardware.bluetooth.powerOnBoot = true;

  # Enable touchpad support (enabled default in most desktopManager).
  # services.xserver.libinput.enable = true;

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.gray = {
    isNormalUser = true;
    description = "Gray";
    extraGroups = [ "networkmanager" "wheel" "libvirtd" "docker" ];
    packages = with pkgs; [
      kdePackages.kate
    #  thunderbird
    ];
  };


  hardware.graphics = { 
      enable = true;    
        extraPackages = with pkgs; [
        intel-media-driver
        vpl-gpu-rt
        intel-compute-runtime
        mesa
    ];  
  };


  # Steam setup
  programs.steam = {
	enable = true;
	gamescopeSession.enable = true;
  };

  # Neovim
  programs.neovim = {
  	enable = true;
	defaultEditor = true;
	
	#plugins = [
	#	pkgs.vimPlugins.nvim-tree-lua
	#	];
	};


	#configure = {
	#packages.myVimPackage = with pkgs.vimPlugins; {
		#nvim-lspconfig
		#ctrlp
	#	};
  #	};  
  
  # Allow unfree packages
 # nixpkgs.config.allowUnfree = true;

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
  
  # Tools
  bind
  htop
  wget
  curl
  flameshot
  # CPU shit
  mesa
  pciutils
  mesa-demos
  vulkan-tools

  # Software libraries
  jdk17
  

  smartmontools
  # Apps
  git
  github-desktop
  obsidian
  neovim
  brave
  firefox
  openvpn
  vscodium  
  rpi-imager
  ferium
  discord
  discordo
  # Never used
  tmux
  fish
  starship
  efibootmgr
  os-prober
  
  #Test
 # plasma-browser-integration 

  # Docker
  docker
  docker-compose

  # AI
  llama-cpp

  # Virtual Machine Shit
  virt-manager
  libvirt-glib
  OVMF
  virtio-win
  spice
  spice-gtk
  win-virtio
  qemu
 
 #CyberSecurity
  exiftool
  mimikatz
  nikto
  wpscan
  sqlmap
  wapiti
  theharvester
  airgorah
  ubertooth
  burpsuite
  maltego
  frida-tools
  trufflehog
  medusa
  cewl
  #hydra
  thc-hydra
  putty
  nmap	
  zap
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

  networking.nameservers = ["1.1.1.1" "8.8.8.8"];
  #Enable Expermental features/the command for it
  nix.settings.experimental-features = ["nix-command" "flakes"];
  #--extra-experimental-features nix-command
  
  # Open ports in the firewall.
  networking.firewall.allowedTCPPorts = [ 25565 ];
  networking.firewall.allowedUDPPorts = [ 25565 ];
  # Or disable the firewall altogether.
  networking.firewall.enable = false;

  #Docker settings/apps
#  virtualisation.docker.enable = true;


  #Virt-manager settings/apps
  programs.virt-manager.enable = true;
  virtualisation.libvirtd.enable = true;
  virtualisation.spiceUSBRedirection.enable = true;

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "25.05"; # Did you read the comment?

}

