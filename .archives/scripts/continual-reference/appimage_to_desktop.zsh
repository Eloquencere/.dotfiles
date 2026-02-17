#!/bin/zsh

# Ensure user provided an AppImage path
app_name=$1
appimage_path=$2
appimage_filename="${appimage_path##*/}"

# ask if the inputs are good
echo "App name: $app_name"
echo "AppImage Path : $appimage_path"

echo -n "Would you like to continue?(y/N) "
read user_choice
if [[ $user_choice =~ ^[Nn]$ ]]; then
    return 1
fi

# Test if AppImage supports --version or --appimage-updateinfo (not all support updateinfo)
if [[ -z $($appimage_path --appimage-updateinfo 2>/dev/null) ]]; then
    echo "This AppImage does NOT support self-updating."
    read "choice?Continue installation anyway? (y/n): "
    [[ "$choice" != [Yy]* ]] && echo "Aborted." && exit 1
else
    echo "This AppImage supports self-update."
fi

mkdir -p ~/Applications/$app_name

chmod +x $appimage_path
mv $appimage_path ~/Applications/$app_name
cd ~/Applications/$app_name

./*.AppImage --appimage-extract
cp --dereference ./squashfs-root/*.png $app_name.png
# Be careful about the comand below, need to preserve the arguments to the appimage
sed -i "s|^Exec=.*|Exec=$HOME/Applications/$app_name/$appimage_filename|" ./squashfs-root/*.desktop
sed -i "s|^Icon=.*|Icon=$HOME/Applications/$app_name/$app_name.png|" ./squashfs-root/*.desktop
echo "NoDisplay=false" >> ./squashfs-root/*.desktop
mv ./squashfs-root/*.desktop ~/.local/share/applications
rm -rf squashfs-root

cd -

