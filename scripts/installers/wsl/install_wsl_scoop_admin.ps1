Set-ExecutionPolicy AllSigned
Set-ExecutionPolicy RemoteSigned -scope CurrentUser

setx XDG_CONFIG_HOME %USERPROFILE%\Documents
setx PATH "%PATH%;%USERPROFILE%\AppData\Local\BraveSoftware\Brave-Browser\Application"

# Installing WSL
wsl --install -d Ubuntu-24.04
# Install fonts

### Tips ###
## To allow execution of this script
# Set-ExecutionPolicy RemoteSigned -Scope LocalMachine
## To revert
# Set-ExecutionPolicy Undefined -Scope LocalMachine

## WSL ##
# https://stackoverflow.com/questions/61110603/how-to-set-up-working-x11-forwarding-on-wsl2
# https://kenny.yeoyou.net/it/2020/09/10/windows-development-environment.html
# https://www.reddit.com/r/neovim/comments/1byy8lu/copying_to_the_windows_clipboard_from_wsl2/
