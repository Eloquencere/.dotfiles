{ config, pkgs, ... }:

# Thoughts over the Nix experience
# Cons
# A distrobox session needs to be started in the first due to nix's non standard file system
# Underwhelming hyprland experience as xilinx doesn't render well & the font is broken
# Defaulting to Gnome brings me back to ubuntu, but ubuntu's gnome is configured well, meaning more time to invest in nix to make it match
# Distrobox setup inherits tools from nix so stuff like rustup might break without warning
# Pros
# Boot is fast & everything is customizable, best for gaming
# config.nix is the best way to go about stuff

{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
    ];

# VM Stuff
    fileSystems."/mnt/shared" = {
    device = "share"; # must match the "Mount tag" you set in virt-manager
    fsType = "9p";
    options = [ "trans=virtio" "version=9p2000.L" "msize=104857600" ];
};

  nix.settings = {
	  auto-optimise-store = true;
	  max-jobs = "auto";
  };
  nixpkgs.config.allowUnfree = true;

  hardware = {
	cpu.amd.updateMicrocode = true;
	# enableAllFirmware = true;
        # nvidia = {
        #       modesetting.enable = true;
	#	powerManagement.enable = true;
	#       cuda.enable = true;
        #       open = false; # proprietory drivers
        #       nvidiaSettings = true;
        #       package = config.boot.kernelPackages.nvidiaPackages.stable;
	#	# Look into prime reverse sync when it gets stable on hyprland
        # };
  	# graphics = {
        # 	enable = true;
        # 	enable32Bit = true;
	#   	extraPackages = with pkgs; [
	#   	    nvidia-vaapi-driver   # Hardware video decode
	#   	];
        # };
  };
  # services = {
  #       auto-cpufreq.enable = true;
  #       xserver.videoDrivers = [ "nvidia" ];
  # };
  services.earlyoom.enable = true;

  # # Sound
  # security.rtkit.enable = true;
  # services.pipewire = {
  #   enable = true;
  #   alsa = {
  #   	enable = true;
  #       support32Bit = true;
  #   };
  #   pulse.enable = true;
  #   extraConfig.pipewire."92-gaming" = {
  #     "context.properties" = {
  #       "default.clock.rate" = 48000;
  #       "default.clock.quantum" = 64; # lower = less audio latency
  #       "default.clock.min-quantum" = 32;
  #       "default.clock.max-quantum" = 256;
  #     };
  #   };
  # };

  # Grub Bootloader
  boot.loader = {
	  grub = {
		enable = true;
		device = "/dev/vda";
		useOSProber = true;
	};
  };

  # # Systemd Bootloader
  # boot = {
  # 	loader = {
  #       	systemd-boot = {
  #       		enable = true;
  #       		consoleMode = "auto";
  #			configurationLimit = 10;
  #       	};
  #       	efi.canTouchEfiVariables = true;
  #       };
  # };

  # For plymouth
  boot = {
  	plymouth = {
		enable = true;
		theme = "bgrt";
	};
	consoleLogLevel = 0;
	initrd = {
		verbose = false;
		systemd.enable = true;
	};
  };
  systemd.settings.Manager.ShowStatus = "no";

  boot.kernelPackages = pkgs.linuxPackages_zen; # gaming-optimized kernel
  boot.kernelParams = [
   "quiet"
   "splash"
   "vt.global_cursor_default=0"
   "systemd.show_status=false"
   "rd.systemd.show_status=false"
   "rd.udev.log_level=3"
   "udev.log_priority=3"
   "amd_pstate=active"   # Uses CPPC for finer-grained freq control
   # "nvidia-drm.modeset=1"
   # "nvidia-drm.fbdev=1"
  ];

  networking = {
	hostName = "nixos";
  	networkmanager.enable = true;
	# wireless.enable = true;  # Enables wireless support via wpa_supplicant.
	nameservers = [ "1.1.1.1" "8.8.8.8" ];

	# uncomment when you install gufw
	# firewall.enable = false; # disable the default nftables firewall
  };
  services.openssh = {
	  enable = true;
	  settings.X11Forwarding = true;
  };

  services = {
    	desktopManager.gnome.enable = true;
	displayManager.gdm.enable = true;
  };

  time.timeZone = "America/New_York";

  users.users.eloquencer = {
    isNormalUser = true;
    description = "eloquencer";
    extraGroups = [ "networkmanager" "wheel" ];
    shell = pkgs.zsh;
  };
  programs.zsh.enable = true;

  # services.flatpak.enable = true;
  # run this as a command in the install script - flatpak remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo

  environment.systemPackages = with pkgs; [
	brave drawio qalculate-gtk notion-app
	
	starship kitty
	neovim zellij
	git wget curl btop
	distrobox
	croc

	# # Game stuff
  	# protonup-qt # manage Proton-GE versions
  	# lutris
  	# mangohud    # in-game overlay for FPS/latency monitoring
  	# wine
  ];

  virtualisation.podman = {
  	enable = true;
	dockerCompat = true;
  };

  # # Windows Compat
  # programs.wine = {
  #         enable = true;
  #         winePackage = pkgs.wineWowPackages.stable;
  #         ntsync = true;
  # };
  # # Gaming
  # programs = {
  #       steam = {
  #               enable = true;
  #               remotePlay.openFirewall = true;
  #               dedicatedServer.openFirewall = true;
  #               gamescopeSession.enable = true;
  #       };
  #       gamescope = {
  #               enable = true;
  #               capSysNice = true;  # allows gamescope to prioritize itself
  #       };
  #       gamemode.enable = true;
  # };
  # # Launch apps with - gamemoderun gamescope -- %command% or gamescope -f -W 1920 -H 1080 -- %command%

  i18n.defaultLocale = "en_US.UTF-8";

  system.stateVersion = "25.11"; # Read this before commiting - nixos.org/nixos/options.html



  # # Disappointing Hyprland stuff
  # # Hyprland pkgs
  # waybar rofi kitty swww wofi quickshell
  # libnotify dunst 
  # wl-clipboard
  # programs.hyprland = {
  #       enable = true;
  #       xwayland.enable = true;
  # 	# nvidiaPatches = true;
  # };
  # services.displayManager = {
  #   defaultSession = "hyprland";
  #   sddm = {
  #       enable = true;
  #       wayland.enable = true;
  #   };
  # };
  # xdg.portal = {
  # 	enable = true;
  #       extraPortals = [
  #       	pkgs.xdg-desktop-portal-hyprland
  #       	pkgs.xdg-desktop-portal-gtk
  #       ];
  # };
  # environment.sessionVariables = {
  # 	# Hint electron apps to use wayland
  # 	NIXOS_OZONE_WL = "1";
  # 	# if cursor becomes invisible
  # 	# WLR_NO_HARDWARE_CURSORS = "1";
  #       # LIBVA_DRIVER_NAME = "nvidia";
  #       # __GLX_VENDOR_LIBRARY_NAME = "nvidia";
  # };
}

