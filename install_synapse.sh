#!/bin/bash

set -e  # Stop execution on error

# Update packages
echo "Updating packages..."
sudo apt update && sudo apt upgrade -y

# Install dependencies
install_if_missing() {
    dpkg -s "$1" &>/dev/null || sudo apt install -y "$1"
}

install_if_missing python3
install_if_missing python3-dev
install_if_missing python3-venv
install_if_missing python3-pip
install_if_missing libpq-dev
install_if_missing libicu-dev
install_if_missing pkg-config
install_if_missing python3-icu

# Install Rust (Cargo) if not already installed
echo "Checking Rust installation..."
if ! command -v cargo &>/dev/null; then
    echo "Installing Rust..."
    curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y
    source "$HOME/.cargo/env"
else
    echo "Rust is already installed."
fi

# Clone the repository
echo "Cloning the repository..."
if [ ! -d "synapse" ]; then
    git clone https://github.com/DVCOM-UFC/synapse.git
fi

# Enter the repository directory
cd synapse || exit

git checkout develop-dvcom

# Create and activate virtual environment
echo "Creating and activating virtual environment..."
if [ ! -d ".synapse" ]; then
    python3 -m venv .synapse
fi

source .synapse/bin/activate

# Upgrade pip and install psycopg2 inside the virtual environment
echo "Installing dependencies..."
pip install --upgrade pip
pip install psycopg2-binary

# Install Poetry if not already installed
echo "Checking Poetry installation..."
if ! command -v poetry &>/dev/null; then
    echo "Installing Poetry..."
    pip install poetry
else
    echo "Poetry is already installed."
fi

# Install dependencies using Poetry
echo "Installing Synapse dependencies..."
poetry install || echo "Poetry install failed, continuing anyway."

# Copy configuration files
echo "Configuring Synapse..."
cp -r ../data .

# Ensure the virtual environment is activated before running Synapse
source .synapse/bin/activate

# Run Synapse
echo "Running Synapse..."
poetry run python -m synapse.app.homeserver -c data/homeserver.yaml
