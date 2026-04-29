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
    "cargo-expand" "cargo-info" "irust" "bacon"
)
cargo install "${CARGO_PKGS[@]}"

# # Other useful rust binaries
# cargo-audit
# cargo-bloat
# cargo-outdated
# cargo-deny
# cargo-flamegraph & hyperfine - profiling code
# cargo-nextest
# cargo-dist
# cargo-generate
# xh - use with yew

# # Useful rust libs
# itertools
# regex & sqlx | sqlite
# Color eyre
# Tracing
# Clap
# Rayon & dashmap
# serde
# Tokio & axum & tonic & yew & reqwest & egui
# cargo clippy -- -W clippy::pedantic -W clippy::nursery -W clippy::unwrap_used clippy::expect_used

