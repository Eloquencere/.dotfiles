declare -a fonts=(
	JetBrainsMono
)
version=latest
if [[ $version =~ "latest" ]]; then
	version="latest/download"
else
	version="download/${version}"
fi
fonts_dir="${HOME}/.local/share/fonts"
if [[ ! -d "$fonts_dir" ]]; then
    mkdir -p "$fonts_dir"
fi
for font in "${fonts[@]}"; do
	wget https://github.com/ryanoasis/nerd-fonts/releases/${version}/${font}.zip
	unzip ${font} -d ${fonts_dir}
	rm -f ${font}.zip
done
find "$fonts_dir" -name '*Windows Compatible*' -delete
fc-cache -fv
