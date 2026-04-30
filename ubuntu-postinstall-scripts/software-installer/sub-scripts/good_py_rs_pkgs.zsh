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
    "cargo-expand"
    "cargo-info"
    "irust"
    # Profiling code
    "cargo-bloat" "cargo-flamegraph"
    "cargo-nextest"
    "cargo-deny"
    "cargo-generate"
    # "cargo-dist"
    # "cargo-inspect" # Educational
)
cargo binstall "${CARGO_PKGS[@]}"

# cargo clippy -- -W clippy::pedantic -W clippy::nursery -W clippy::unwrap_used clippy::expect_used

# # Useful rust libs
# itertools
# serde
# regex & sqlx | sqlite
# Rayon & dashmap & crossbeam
# Color eyre
# Tracing
# Clap
# Tokio & axum & tonic & yew & reqwest & egui

