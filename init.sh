#!/bin/bash

set -e

echo "🚀 Starting dotfiles initialization..."

# =============================================================================
# STEP 1: Install Homebrew
# =============================================================================
if ! command -v brew &> /dev/null; then
    echo "📦 Installing Homebrew..."
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
else
    echo "✅ Homebrew is already installed"
fi

# =============================================================================
# STEP 2: Add Homebrew taps
# =============================================================================
echo "🔌 Adding Homebrew taps..."
brew tap nikitabobko/tap      # AeroSpace
brew tap FelixKratz/formulae  # Sketchybar
brew tap tarkah/tickrs        # Tickrs

# =============================================================================
# STEP 3: Install Homebrew packages
# =============================================================================
echo "📥 Installing Homebrew packages..."

packages=(
    # CLI tools
    "btop"
    "ente-cli"
    "eza"
    "fastfetch"
    "fzf"
    "gemini-cli"
    "gh"
    "jackett"
    "mise"
    "starship"
    "stow"
    "tmux"
    "yazi"
    "zoxide"
    # Zsh plugins
    "zsh-autosuggestions"
    "zsh-syntax-highlighting"
    # Sketchybar dependencies
    "lua"
    "nowplaying-cli"
    "sketchybar"
    "switchaudio-osx"
    # Other
    "tickrs"
)

brew install "${packages[@]}"

# =============================================================================
# STEP 4: Install Homebrew casks
# =============================================================================
echo "📥 Installing Homebrew casks..."

casks=(
    # Apps
    "discord"
    "figma"
    "ghostty"
    "scroll-reverser"
    "telegram"
    "visual-studio-code"
    "whatsapp"
    # Window management
    "aerospace"
    # Fonts
    "font-jetbrains-mono-nerd-font"
    "font-sf-mono"
    "font-sf-pro"
    "font-sf-symbols"
)

brew install --cask "${casks[@]}"

# =============================================================================
# STEP 5: Install external dependencies
# =============================================================================
echo "📦 Installing external dependencies..."

# Tmux plugin manager (tpm)
if [ ! -d "$HOME/.config/tmux/plugins/tpm" ]; then
    echo "  → Installing tmux plugin manager..."
    git clone https://github.com/tmux-plugins/tpm ~/.config/tmux/plugins/tpm
else
    echo "  ✅ tmux plugin manager is already installed"
fi

# Sketchybar app font
echo "  → Installing Sketchybar app font..."
curl -L https://github.com/kvndrsslr/sketchybar-app-font/releases/download/v2.0.28/sketchybar-app-font.ttf -o "$HOME/Library/Fonts/sketchybar-app-font.ttf"

# SbarLua
echo "  → Installing SbarLua..."
(git clone https://github.com/FelixKratz/SbarLua.git /tmp/SbarLua && cd /tmp/SbarLua/ && make install && rm -rf /tmp/SbarLua/)

# =============================================================================
# STEP 6: Stow dotfiles
# =============================================================================
echo "🔗 Stowing dotfiles..."
stow aerospace btop eza ghostty mise sketchybar starship tickrs tmux yazi zsh

# =============================================================================
# STEP 7: Post-stow configuration
# =============================================================================
echo "⚙️ Running post-stow configuration..."

# Symlink tickrs config (requires special location)
mkdir -p "$HOME/Library/Application Support/tickrs"
ln -sf "$PWD/tickrs/.config/tickrs/config.yml" "$HOME/Library/Application Support/tickrs/config.yml"

# =============================================================================
# STEP 8: macOS settings
# =============================================================================
echo "🍎 Tweaking macOS settings..."

# Move windows by dragging anywhere (ctrl + cmd)
defaults write -g NSWindowShouldDragOnGesture -bool true

# Disable window animations
defaults write -g NSAutomaticWindowAnimationsEnabled -bool false

# =============================================================================
# DONE
# =============================================================================
echo "✅ Initialization complete!"