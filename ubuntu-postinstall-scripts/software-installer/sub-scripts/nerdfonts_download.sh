# Thanks - gist.github.com/matthewjberger/7dd7e079f282f8138a9dc3b045ebefa0

declare -a fonts=(
	UbuntuSans
)

fonts_dir="$HOME/.local/share/fonts"
mkdir -p "$fonts_dir"

for font in "${fonts[@]}"; do
	wget https://github.com/ryanoasis/nerd-fonts/releases/latest/download/${font}.zip
	unzip ${font} -d ${fonts_dir}
	rm -f ${font}.zip
done
find "$fonts_dir" -name '*Windows Compatible*' -delete
fc-cache -fv

