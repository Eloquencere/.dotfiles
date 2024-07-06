mkdir ~/Documents/install_script_temp_folder
cd ~/Documents/install_script_temp_folder

# Necessary Python libraries
pyenv install 3.12
pyenv global 3.12
pyenv shell 3.12
pip install --upgrade pip
# debugging
pip install icecream
# presentation
pip install drawio
pip install colorama pyfiglet
pip install dash plotly seaborn
# seaborn - (replace matplotlib)
# data representation and calculation
pip install mysql-connector-python
pip install polars xarray 
# xarray - (multi-dimentional arrays)
pip install Cython numba taichi
pip install numpy scipy pillow
pip install parse
# quality of life
pip install pendulum
# pendulum - (replace datetime)
pip install pydantic
pip install ruff
# ruff (linter)


# Bottles(Wine) Emulator
yes | flatpak install bottles

# install overleaf
flatpak install yacreader
sudo pacman -S obsidian zathura

cd ~/Documents
rm -rf install_script_temp_folder
