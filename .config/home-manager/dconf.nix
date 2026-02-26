{ config, pkgs, lib, ... }:
let
    gv = lib.hm.gvariant;

    # id -> <{ position: <uint32 N> }>
    mkEntry = id: pos:
    gv.mkDictionaryEntry [
        id
        (gv.mkVariant [
        (gv.mkDictionaryEntry [ "position" (gv.mkVariant (gv.mkUint32 pos)) ])
        ])
    ];

    # Turn a list of IDs into one "page" (positions 0..n-1)
    mkPage = ids:
    builtins.genList(i: mkEntry (builtins.elemAt ids i) i)(builtins.length ids);
in
{
    dconf = {
        enable = true;
        settings = {
            "org/gnome/desktop/session" = {
                idle-delay = 0;
            };
            "org/gnome/desktop/screensaver" = {
                lock-enabled = false;
            };

            "org/gnome/TextEditor" = {
                style-scheme = "classic-dark";
                restore-session = false;
                show-line-numbers = true;
                highlight-current-line = true;
                highlight-matching-brackets = true;
                tab-width = 4;
            };

            "org/gnome/nautilus/icon-view" = {
                default-zoom-level = "small-plus";
            };

            "org/gnome/mutter" = {
               center-new-windows = true; 
            };
            "org/gnome/desktop/interface" = {
                show-battery-percentage = true;
                cursor-size             = 29;
                text-scaling-factor     = 1.25;
                color-scheme            = "prefer-dark";
                gtk-theme               = "Yaru-blue-dark";
                icon-theme              = "Yaru-blue";
                clock-show-weekday      = true;
                clock-format            = "24h";
            };

            "org/gnome/settings-daemon/plugins/color" = {
                night-light-enabled = true;
                night-light-temperature = lib.gvariant.mkUint32 3249;
                night-light-schedule-automatic = false;
                night-light-schedule-from = 0.0; # Always enabled
                night-light-schedule-to = 0.0;
            };

            "org/gnome/shell/extensions/ding" = {
                show-home = false;
                start-corner = "top-left";
            };

            "org/gnome/shell/extensions/dash-to-dock" = {
               multi-monitor = true;
               dash-max-icon-size = 50;
               dock-fixed = false;
               autohide-in-fullscreen = true;
               extend-height = false;
               show-mounts-only-mounted = true;
               always-center-icons = true;
               dock-position = "BOTTOM";
               click-action = "minimize-or-previews";
            };

            "org/gnome/shell/extensions/Bluetooth-Battery-Meter" = {
                popup-in-quick-settings = false;
                enable-battery-level-icon = false;
                enable-battery-level-text = true;
                indicator-type = 0;
            };

            "org/gnome/shell/extensions/custom-hot-corners-extended/misc" = {
                panel-menu-enable=false;
                show-osd-monitor-indexes=false;
            };

            "org/gnome/shell/extensions/custom-hot-corners-extended/monitor-0-top-left-0" = {
                action="toggle-applications";
            };

            "org/gnome/shell/extensions/just-perfection" = {
                keyboard-layout = false;
                accessibility-menu = false;
                quick-settings-dark-mode = false;
                quick-settings-airplane-mode = false;
                show-apps-button = false;
                workspace-popup = false;
                dash-separator = true;
                switcher-popup-delay = false;
            };

            "org/gnome/shell/extensions/blur-my-shell/dash-to-dock" = {
                blur=false;
            };
            "org/gnome/shell/extensions/blur-my-shell/panel" = {
                blur=false;
            };

            "com/github/stunkymonkey/nautilus-open-any-terminal" = {
                terminal = "wezterm";
            };
            
            "org/gnome/settings-daemon/plugins/media-keys" = {
                custom-keybindings = [
                    "/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom0/"
                    "/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom1/"
                ];
            };
            "org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom0" = {
                name="Qalculate Calculator";
                command="qalculate";
                binding="Calculator";
            };

            "org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom1" = {
                name="Wezterm";
                command="wezterm";
                binding="<Alt><Shift>w";
            };

            "org/gnome/desktop/search-providers" = {
                sort-order = [
                    "org.gnome.Documents.desktop"
                    "org.gnome.Nautilus.desktop"
                ];
                disabled = [
                    "org.gnome.Nautilus.desktop"
                    "org.gnome.Characters.desktop"
                    "org.gnome.clocks.desktop"
                    "org.gnome.Software.desktop"
                    "org.gnome.Contacts.desktop"
                ];
            };
            "org/gnome/desktop/app-folders" = {
                folder-children = [ 
                    "office"
                    "project-management"
                    "programming"
                    "kicad"
                    "games"
                    "software-management"
                    "bleachbit"
                    "disk"
                    "network"
                    "kde-connect"
                    "drivers"
                    "language-support"
                ];
            };

            "org/gnome/desktop/app-folders/folders/office" = {
                name = "Office";
                translate = false;
                apps = [
                    "libreoffice-writer.desktop"
                    "libreoffice-impress.desktop"
                    "libreoffice-calc.desktop"
                    "libreoffice-math.desktop"
                    "libreoffice-draw.desktop"
                    "libreoffice-startcenter.desktop"
                    "drawio_drawio.desktop"
                    "simple-scan.desktop" # Document scanner
                    "org.kde.okular.desktop"
                    "qalculate_qalculate.desktop"
                    "org.gnome.eog.desktop" # Image Viewer
                ];
            };
            "org/gnome/desktop/app-folders/folders/project-management" = {
                name = "Project Management";
                translate = false;
                apps = [
                    "org.jitsi.jitsi-meet.desktop"
                    "signal-desktop.desktop"
                    "com.rustdesk.RustDesk.desktop"
                ];
            };
            "org/gnome/desktop/app-folders/folders/programming" = {
                name = "Programming";
                translate = false;
                apps = [
                    "org.ghidra_sre.Ghidra.desktop"
                    "code.desktop"
                    "com.github.reds.LogisimEvolution.desktop"
                ];
            };
            "org/gnome/desktop/app-folders/folders/kicad" = {
                name = "KiCAD";
                translate = false;
                apps = [
                    "org.kicad.kicad.desktop"
                    "org.kicad.gerbview.desktop"
                    "org.kicad.bitmap2component.desktop"
                    "org.kicad.pcbcalculator.desktop"
                    "org.kicad.pcbnew.desktop"
                    "org.kicad.eeschema.desktop"
                ];
            };
            "org/gnome/desktop/app-folders/folders/games" = {
                name = "Games";
                translate = false;
                apps = [
                    "steam_steam.desktop"
                    "com.heroicgameslauncher.hgl.desktop"
                    "com.discordapp.Discord.desktop"
                    "org.gnome.Crosswords.desktop"
                    "org.gnome.Chess.desktop"
                    "org.gnome.Mahjongg.desktop"
                    "app.drey.MultiplicationPuzzle.desktop"
                    "org.gnome.Sudoku.desktop"
                    "org.gnome.Mines.desktop"
                ];
            };
            "org/gnome/desktop/app-folders/folders/software-management" = {
                name = "Software Management";
                translate = false;
                apps = [
                    "org.gnome.Software.desktop"
                    "snap-store_snap-store.desktop"
                    "com.mattjakeman.ExtensionManager.desktop"
                    "software-properties-gtk.desktop" # Software & Updates
                    "update-manager.desktop" # WARN: depricated in Ubuntu 26.04LTS
                ];
            };
            "org/gnome/desktop/app-folders/folders/bleachbit" = {
                name = "Bleachbit";
                translate = false;
                apps = [
                    "org.bleachbit.BleachBit.desktop"
                    "bleachbit-root.desktop"
                ];
            };
            "org/gnome/desktop/app-folders/folders/drivers" = {
                name = "Drivers";
                translate = false;
                apps = [
                    "software-properties-drivers.desktop"
                    "firmware-updater_firmware-updater.desktop"
                    "nvidia-settings.desktop"
                ];
            };
            "org/gnome/desktop/app-folders/folders/disk" = {
                name = "Disk Utilities";
                translate = false;
                apps = [
                    "org.gnome.baobab.desktop" # Disk Usage Analyser
                    "org.gnome.DiskUtility.desktop"
                    "usb-creator-gtk.desktop"  # Starup Disk Creator
                    "org.gnome.FileRoller.desktop"
                ];
            };
            "org/gnome/desktop/app-folders/folders/network" = {
                name = "Network Utilities";
                translate = false;
                apps = [
                    "org.remmina.Remmina.desktop"
                    "remote-viewer.desktop"
                    "nm-connection-editor.desktop" # Advanced network configuration
                ];
            };
            "org/gnome/desktop/app-folders/folders/kde-connect" = {
                name = "KDE Connect";
                translate = false;
                apps = [
                    "org.kde.kdeconnect.nonplasma.desktop"
                    "org.kde.kdeconnect-settings.desktop"
                    "org.kde.kdeconnect.sms.desktop"
                ];
            };
            "org/gnome/desktop/app-folders/folders/language-support" = {
                name = "Language Support";
                translate = false;
                apps = [
                    "org.gnome.font-viewer.desktop"
                    "org.gnome.Characters.desktop"
                    "gnome-language-selector.desktop"
                ];
            };

            "org/gnome/shell" = {
                favorite-apps = [
                    "org.gnome.TextEditor.desktop"
                    "notion-desktop_notion-desktop.desktop"
                    "obsidian_obsidian.desktop"
                    "brave-browser.desktop"
                    "org.wezfurlong.wezterm.desktop"
                    "org.gnome.Nautilus.desktop"
                ];

                app-picker-layout = with lib; [
                    (mkPage[
                        "office"
                        "project-management"
                        "programming"
                        "kicad"
                        "games"
                        "virt-manager.desktop"
                        "anki.desktop"
                        "io.github.giantpinkrobots.varia.desktop" # flatpak name
                        # "varia_varia.desktop" # snap name
                        "net.epson.epsonscan2.desktop"
                        "timeshift-gtk.desktop"
                        "org.kde.kdeconnect.app.desktop"
                        "surfshark_surfshark.desktop"
                        "net.nokyan.Resources.desktop"
                    ])
                    (mkPage[
                        "gnome-session-properties.desktop" # startup applications
                        "gufw.desktop"
                        "software-management"
                        "bleachbit"
                        "drivers"
                        "disk"
                        "network"
                        "language-support"
                        "kde-connect"
                        "firefox_firefox.desktop"
                        "org.videolan.VLC.desktop"
                        "org.gnome.Calendar.desktop"
                        "org.gnome.Settings.desktop"
                        "org.gnome.clocks.desktop"
                        "org.videolan.VLC.desktop"
                    ])
                ];
            };
        };
    };
}

