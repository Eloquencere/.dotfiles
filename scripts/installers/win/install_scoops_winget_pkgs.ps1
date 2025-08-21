winget install --id 7zip.7zip
winget install --id schollz.croc
winget install --id Brave.Brave
winget install "WhatsApp" --source msstore
winget install "Discord" --source msstore
winget install --id Piriform.Recuva
winget install --id geeksoftwareGmbH.PDF24Creator
winget install --id RustDesk.RustDesk
winget install --id Notion.Notion
winget install --id Surfshark.Surfshark
winget install "Cover - Comic reader" --source msstore
winget install --id JackieLiu.NotepadsApp
winget install --id Microsoft.Office
# Get Rufus from the website

# Duplicates
winget install --id VideoLAN.VLC
winget install --id SoftDeluxe.FreeDownloadManager
winget install --id ArduinoSA.IDE.stable
winget install --id Microsoft.VisualStudioCode
winget install --id OpenWhisperSystems.Signal
winget install --id JGraph.Draw
winget install --id Anysphere.Cursor
winget install --id Jitsi.Meet

winget upgrade --all --include-unknown

Invoke-RestMethod -Uri https://get.scoop.sh | Invoke-Expression
scoop install git
scoop bucket add extras
scoop install extras/okular
scoop install extras/teraterm

# Duplicates
# scoop install extras/kanata
# scoop install extras/wezterm
# scoop install extras/kicad
# scoop bucket add java
# scoop install java/openjdk
# scoop install extras/logisim-evolution

scoop update --all

# Optional
# winget install "Focus 10" --source msstore
# winget install --id dorssel.usbipd-win
# winget install "Microsoft Whiteboard"
# winget install "Microsoft Journal"
# winget install --id Typst.Typst
# winget install --id BlenderFoundation.Blender
# winget install --id Microsoft.PowerToys --source winget
# winget install --id JackieLiu.NotepadsApp
# winget install --id Anki.Anki
## Games ##
# winget install --id GOG.Galaxy
# winget install --id Valve.Steam
# winget install --id BlueStack.BlueStacks
# scoop install extras/parsec

## Kanata ##
# reg add "HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\Run" /v "Kanata" /t REG_SZ /d "C:\Windows\System32\conhost.exe --headless %USERPROFILE%\scoop\apps\kanata\current\kanata.exe --nodelay --cfg %XDG_CONFIG_HOME%\Kanata\config.kbd"





