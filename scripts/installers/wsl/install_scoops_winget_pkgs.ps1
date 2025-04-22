winget install --id XP8C9QZMS2PC1T --source msstore        # brave
winget install --id 9NKSQGP7F2NH --source msstore          # whatsapp
winget install --id XPDC2RH70K22MN --source msstore        # discord
winget install --id XP8LGT18LSS4QS  			   # recuva
winget install --id JackieLiu.NotepadsApp
winget install --id wez.wezterm
winget install schollz.croc
winget install --id RustDesk.RustDesk
winget install --id Notion.Notion --source winget
winget install "Focus 10" --source msstore
winget install --id Surfshark.Surfshark --source winget
winget install "Cover - Comic reader" --source msstore
winget install --id SoftDeluxe.FreeDownloadManager
winget install --id ArduinoSA.IDE.stable
winget install --id JGraph.Draw
winget install --id Microsoft.VisualStudioCode --source winget
winget install --id OpenWhisperSystems.Signal
winget install --id Anki.Anki --source winget
winget install --id VideoLAN.VLC --source winget
winget install --id 7zip.7zip
winget install --id Obsidian.Obsidian
winget install --id BlueStack.BlueStacks

winget upgrade --all --include-unknown

Invoke-RestMethod -Uri https://get.scoop.sh | Invoke-Expression
scoop install git
scoop bucket add java
scoop bucket add extras
scoop bucket add nonportable
scoop install extras/wezterm
scoop install extras/okular
scoop install extras/teraterm
scoop install extras/kicad
scoop install extras/kanata
scoop install java/openjdk
scoop install extras/logisim-evolution

scoop update -a

# Be admin
scoop install nonportable/pdf24-creator-np

# # After installing VMWare
winget install usbipd

# Optional
# winget install "Microsoft Whiteboard"
# scoop install extras/parsec
# scoop install main/duplicacy
# winget install --id BlenderFoundation.Blender
# winget install VcXsrv ## For WSL
# winget install --id Microsoft.PowerToys --source winget

# reg add "HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\Run" /v "Kanata" /t REG_SZ /d "C:\Windows\System32\conhost.exe --headless %USERPROFILE%\scoop\apps\kanata\current\kanata.exe --cfg %XDG_CONFIG_HOME%\Kanata\config.kbd"

