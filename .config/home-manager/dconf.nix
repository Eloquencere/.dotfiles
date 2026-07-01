{ config, pkgs, lib, ... }:
let
    gv = lib.hm.gvariant;

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
            "org/gnome/settings-daemon/plugins/media-keys" = {
                custom-keybindings = [
                    "/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom0/"
                    "/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom1/"
                    "/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom2/" # & this
                    "/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom3/" # WARN: & this
                ];
            };
            "org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom0" = {
                name="Qalculate Calculator";
                command="flatpak run io.github.Qalculate";
                binding="XF86Calculator";
            };
            "org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom1" = {
                name="Ulauncher";
                command="ulauncher";
                binding="<Alt>space";
            };
            # WARN: Remove this
            "org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom2" = {
                name="ghostty";
                command="ghostty";
                binding="<Alt><Shift>g";
            };
            # WARN: Remove this
            "org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom3" = {
                name="wezterm";
                command="wezterm";
                binding="<Alt><Shift>w";
            };

            "org/gnome/settings-daemon/plugins/color" = {
                night-light-enabled = true;
                night-light-temperature = lib.gvariant.mkUint32 3249;
                night-light-schedule-automatic = false;
                night-light-schedule-from = 0.0; # Always enabled
                night-light-schedule-to = 0.0;
            };

            "org/gnome/settings-daemon/plugins/power" = {
                idle-dim = false;
            };
            "org/gnome/desktop/session" = {
                idle-delay = lib.gvariant.mkUint32 0;
            };

            "org/gnome/desktop/datetime" = {
                automatic-timezone = true;
            };
            "org/gnome/desktop/sound" = {
                event-sounds = false;
            };

            # TODO: Enable variable refresh rate
            "org/gnome/desktop/interface" = {
                ## Dark Mode
                color-scheme            = "prefer-dark";
                # accent-color            = "blue"; # WARN: only in 26.04
                icon-theme              = "Yaru-blue-dark";
                gtk-theme               = "Yaru-blue-dark";
                ## Dark Mode

                text-scaling-factor     = 1.25; # WARN: try with 1.25-1.28 range
                cursor-size             = 30;

                show-battery-percentage = true;
                clock-show-weekday      = true;
                clock-format            = "24h"; # Default
            };

            # WARN: Default in 26
            "org/gnome/mutter" = {
                center-new-windows = true; 
            };

            "org/gnome/TextEditor" = {
                style-scheme = "classic-dark";
                restore-session = false;
                show-line-numbers = true;
                highlight-current-line = true;
                tab-width = 4;
            };

            "org/gnome/nautilus/icon-view" = {
                default-zoom-level = "small-plus";
                captions = [ "size" "none" "none" ];
            };
            "org/gnome/nautilus/preferences" = {
                click-policy = "single";
            };

            "org/gnome/shell/extensions/ding" = {
                show-home = false;
                start-corner = "top-left";
            };

            "org/gnome/shell/extensions/dash-to-dock" = {
                dash-max-icon-size = 50;
                dock-position = "BOTTOM";
                click-action = "minimize-or-previews";
                dock-fixed = false;
                extend-height = false;
                show-mounts-only-mounted = true;
                multi-monitor = true;
                isolate-monitors = true;

                # WARN: Absent in GUI, prob not needed
                always-center-icons = true;
                autohide-in-fullscreen = true;
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
                activities-button = false;
                keyboard-layout = false;
                accessibility-menu = false;
                quick-settings-dark-mode = false;
                quick-settings-airplane-mode = false;
                workspace-popup = false;
                switcher-popup-delay = false;
                events-button = false;
                startup-status = 1;
                search = false;
                workspace = false; # not sure
                workspaces-in-app-grid = false; # WARN: Set to true in 26.04 else it looks weird
            };

            "org/gnome/shell/extensions/blur-my-shell/dash-to-dock" = {
                blur=false;
            };
            "org/gnome/shell/extensions/blur-my-shell/panel" = {
                blur=false;
            };

            "org/gnome/shell/extensions/space-bar/behavior/always-show-numbers" = {
                always-show-numbers = true;
                smart-workspace-names = false;
                enable-activate-workspace-shortcuts = false;
                enable-move-to-workspace-shortcuts = true;
                open-menu = "@as []";
            };

            "org/gnome/shell/extensions/quick-settings-tweaks" = {
                dnd-quick-toggle-enabled = false;
                # toggles-layout-order = "[{'hide': <<false>>, 'isSystem': <<true>>, 'constructorName': <<'NMWiredToggle'>>}, {'hide': <<false>>, 'isSystem': <<true>>, 'constructorName': <<'NMWirelessToggle'>>}, {'hide': <<false>>, 'isSystem': <<true>>, 'constructorName': <<'NMModemToggle'>>}, {'hide': <<false>>, 'isSystem': <<true>>, 'constructorName': <<'NMBluetoothToggle'>>}, {'hide': <<false>>, 'isSystem': <<true>>, 'constructorName': <<'NMVpnToggle'>>}, {'hide': <<false>>, 'isSystem': <<true>>, 'constructorName': <<'BluetoothToggle'>>}, {'nonOrdered': <<true>>, 'hide': <<false>>}, {'hide': <<false>>, 'isSystem': <<true>>, 'constructorName': <<'PowerProfilesToggle'>>}, {'hide': <<false>>, 'isSystem': <<true>>, 'constructorName': <<'NightLightToggle'>>}, {'hide': <<false>>, 'isSystem': <<true>>, 'constructorName': <<'DarkModeToggle'>>}, {'hide': <<false>>, 'isSystem': <<true>>, 'constructorName': <<'KeyboardBrightnessToggle'>>}, {'hide': <<false>>, 'isSystem': <<true>>, 'constructorName': <<'RfkillToggle'>>}, {'hide': <<false>>, 'isSystem': <<true>>, 'constructorName': <<'RotationToggle'>>}, {'hide': <<false>>, 'isSystem': <<true>>, 'constructorName': <<'DndQuickToggle'>>}, {'hide': <<false>>, 'isSystem': <<true>>, 'constructorName': <<'UnsafeQuickToggle'>>}]";
            };

            "org/gnome/shell/extensions/advanced-alt-tab-window-switcher" = {
                switcher-popup-monitor = 3;
            };

            "org/gnome/shell/extensions/copyous" = {
                show-indicator = false;
            };

            # WARN: uncomment in 26.04
            # "org/gnome/desktop/break-reminders" = {
            #     selected-breaks = ["eyesight"];
            # }

            "org/gnome/desktop/search-providers" = {
                sort-order = [
                    # "brave-browser.desktop" # WARN: uncomment in 26.04
                    "org.gnome.Nautilus.desktop"
                    "org.gnome.Settings.desktop"
                    "io.github.Qalculate.desktop"
                ];
                disabled = [
                    "org.gnome.Contacts.desktop"
                    "org.gnome.clocks.desktop"
                    "org.gnome.Characters.desktop"
                    "org.gnome.Calendar.desktop"
                    "org.gnome.Documents.desktop" # NOTE: idk what this is
                    "org.gnome.Software.desktop"
                    # "snap-store_snap-store.desktop" # WARN: un in 26.04
                ];
            };
            "org/gnome/desktop/app-folders" = {
                folder-children = [ 
                    "office"
                    "project-management"
                    "coding"
                    "kicad"
                    "virtualisation"
                    "games"
                    "security"
                    "software-management"
                    "system-tools"
                    "disk-utilities"
                    "network-utilities"
                    "language-support"
                    "libreoffice"
                ];
            };

            "org/gnome/desktop/app-folders/folders/office" = {
                name = "Office";
                translate = false;
                apps = [
                    "libreoffice-startcenter.desktop"
                    "onlyoffice-desktopeditors_onlyoffice-desktopeditors.desktop"
                    "com.jgraph.drawio.desktop.desktop"
                    "org.kde.drawy.desktop"
                    "zotero.desktop"
                    "com.github.tenderowl.frog.desktop"
                    "net.epson.epsonscan2.desktop"
                    "io.github.Qalculate.desktop"
                    "org.gnome.Papers.desktop"
                    "org.gnome.eog.desktop" # WARN: Not in 26
                    # "org.gnome.Loupe.desktop" # WARN: enable in 26
                    "simple-scan.desktop" # WARN: might not be in 26 
                ];
            };
            "org/gnome/desktop/app-folders/folders/libreoffice" = {
                name = "LibreOffice";
                translate = false;
                apps = [
                    "libreoffice-calc.desktop"
                    "libreoffice-writer.desktop"
                    "libreoffice-impress.desktop"
                    "libreoffice-math.desktop"
                    "libreoffice-draw.desktop"
                ];
            };
            "org/gnome/desktop/app-folders/folders/project-management" = {
                name = "Project Management";
                translate = false;
                apps = [
                    "org.jitsi.jitsi-meet.desktop"
                    "com.rustdesk.RustDesk.desktop"
                    "signal-desktop.desktop"
                ];
            };
            "org/gnome/desktop/app-folders/folders/coding" = {
                name = "Coding";
                translate = false;
                apps = [
                    "org.ghidra_sre.Ghidra.desktop"
                    "code.desktop"
                    "com.github.reds.LogisimEvolution.desktop"
                    # WARN: Add antigravity here
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
            "org/gnome/desktop/app-folders/folders/virtualisation" = {
                name = "Virtualisation";
                translate = false;
                apps = [
                    "virt-manager.desktop"
                    "winboat.desktop"
                ];
            };
            "org/gnome/desktop/app-folders/folders/games" = {
                name = "Games";
                translate = false;
                apps = [
                    "steam.desktop"
                    "com.heroicgameslauncher.hgl.desktop"
                    "io.github.ryubing.Ryujinx.desktop"
                    "com.discordapp.Discord.desktop"
                    "org.gnome.Crosswords.desktop"
                    "org.gnome.Chess.desktop"
                    "org.gnome.Mahjongg.desktop"
                    "app.drey.MultiplicationPuzzle.desktop"
                    "org.gnome.Sudoku.desktop"
                    "org.gnome.Mines.desktop"
                ];
            };
            "org/gnome/desktop/app-folders/folders/security" = {
                name = "Security";
                translate = false;
                apps = [
                    "desktop-security-center_desktop-security-center.desktop"
                    "gufw.desktop"
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
                    "update-manager.desktop" # WARN: not in 26
                    "it.mijorus.gearlever.desktop"
                ];
            };
            "org/gnome/desktop/app-folders/folders/system-tools" = {
                name = "System Tools";
                translate = false;
                apps = [
                    "firmware-updater_firmware-updater.desktop"
                    "nvidia-settings.desktop"
                    "org.gnome.Sysprof.desktop"
                    "software-properties-drivers.desktop" # Not in 26
                ];
            };
            "org/gnome/desktop/app-folders/folders/disk-utilities" = {
                name = "Disk Utilities";
                translate = false;
                apps = [
                    "org.gnome.baobab.desktop" # Disk Usage Analyser
                    "org.gnome.DiskUtility.desktop"
                    "usb-creator-gtk.desktop"  # Starup Disk Creator
                    "org.bleachbit.BleachBit.desktop"
                    "bleachbit-root.desktop"
                    "org.gnome.FileRoller.desktop"
                ];
            };
            "org/gnome/desktop/app-folders/folders/network-utilities" = {
                name = "Network Utilities";
                translate = false;
                apps = [
                    "org.remmina.Remmina.desktop"
                    "nm-connection-editor.desktop" # Advanced network configuration
                    "remote-viewer.desktop" # WARN: Not in 26
                    "io.github.totoshko88.RustConn.desktop"
                    "xfreerdp.desktop"
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
                    "org.wezfurlong.wezterm.desktop" # WARN: depricated
                    "com.mitchellh.ghostty.desktop"
                    "org.gnome.Nautilus.desktop"
                ];

                app-picker-layout = with lib; [
                    (mkPage[
                        "office"
                        "project-management"
                        "coding"
                        "kicad"
                        "virtualisation"
                        "games"
                        "lmstudio.desktop"
                        "anki.desktop"
                        "surfshark_surfshark.desktop"
                        "io.github.giantpinkrobots.varia.desktop" # flatpak name
                        "timeshift-gtk.desktop"
                        "tv.kodi.Kodi.desktop"
                        "net.nokyan.Resources.desktop"
                    ])
                    (mkPage[
                        "gnome-session-properties.desktop" # WARN: not in 26
                        "security"
                        "system-tools"
                        "disk-utilities"
                        "network-utilities"
                        "software-management"
                        "libreoffice"
                        "language-support"
                        "io.github.diegopvlk.Cine.desktop"
                        "org.gnome.Calendar.desktop"
                        "org.gnome.Settings.desktop"
                        "org.gnome.clocks.desktop"
                    ])
                ];
            };
        };
    };
}

