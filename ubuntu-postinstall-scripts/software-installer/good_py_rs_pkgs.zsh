pip install icecream # for debugging
pip install colorama pyfiglet # presentation
pip install dash plotly seaborn mysql-connector-python # data representation and calculation
pip install fireducks xarray openpyxl
pip install numpy scipy pillow
pip install Cython numba taichi
pip install parse pendulum pydantic ruff mypy pyglet
pip install keras scikit-learn torch # AI/ML

# Useful Rust binaries
CARGO_PKGS=(
    "cargo-expand" "irust" "bacon"
)
cargo install "${CARGO_PKGS[@]}"

