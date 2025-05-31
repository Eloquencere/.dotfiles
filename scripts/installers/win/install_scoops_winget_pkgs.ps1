winget install --id Brave.Brave
winget install "WhatsApp" --source msstore
winget install "Discord" --source msstore
winget install --id Piriform.Recuva
winget install --id VideoLAN.VLC
winget install --id 7zip.7zip
winget install --id geeksoftwareGmbH.PDF24Creator
winget install --id schollz.croc
winget install --id dorssel.usbipd-win
winget install --id RustDesk.RustDesk
winget install --id Notion.Notion
winget install --id Surfshark.Surfshark
winget install "Focus 10" --source msstore
winget install "Cover - Comic reader" --source msstore
winget install --id Anki.Anki
winget install --id ArduinoSA.IDE.stable
winget install --id Microsoft.VisualStudioCode
winget install --id OpenWhisperSystems.Signal
winget install --id JGraph.Draw
winget install --id ElementLabs.LMStudio
winget install --id Anysphere.Cursor
# winget install --id Jitsi.Meet

winget upgrade --all --include-unknown

Invoke-RestMethod -Uri https://get.scoop.sh | Invoke-Expression
scoop install git
scoop bucket add java
scoop bucket add extras
scoop install extras/okular
scoop install extras/kanata
scoop install extras/wezterm
scoop install extras/teraterm
scoop install extras/kicad
scoop install java/openjdk
scoop install extras/logisim-evolution

scoop update --all

# Optional
# winget install --id SoftDeluxe.FreeDownloadManager
# winget install "Microsoft Whiteboard"
# winget install "Microsoft Journal"
# winget install --id Typst.Typst
# winget install --id BlenderFoundation.Blender
# winget install --id Microsoft.PowerToys --source winget
# winget install --id JackieLiu.NotepadsApp
# winget install --id Microsoft.Office
# winget install --id BlueStack.BlueStacks
# winget install --id GOG.Galaxy
# winget install --id Valve.Steam
# scoop install extras/parsec

## Remove "--nodelay" and run if you face any issues
# reg add "HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\Run" /v "Kanata" /t REG_SZ /d "C:\Windows\System32\conhost.exe --headless %USERPROFILE%\scoop\apps\kanata\current\kanata.exe --nodelay --cfg %XDG_CONFIG_HOME%\Kanata\config.kbd"

