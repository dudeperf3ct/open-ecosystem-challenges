#!/usr/bin/env bash
set -e

echo "✨ Installing gum"

curl -LO "https://github.com/charmbracelet/gum/releases/download/v0.17.0/gum_0.17.0_amd64.deb"
sudo apt install ./gum_0.17.0_amd64.deb
rm gum_0.17.0_amd64.deb
