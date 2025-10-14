set -euo pipefail

# === Helper function for logging ===
log() {
  echo -e "\n\033[1;34m[INIT]\033[0m $1"
}

# === Packages to install ===
PACKAGES=(
  stow
  digikam
  darktable
  telegram-desktop
)

PACKAGES_REMOVE=(
  1password
  1password-cli
  1password-beta
)

WEBAPP_REMOVE=(
  Basecamp
  Hey
)

# === Update and install packages ===
log "Updating system and installing packages..."
sudo pacman -Syu --noconfirm
sudo pacman -S --noconfirm --needed "${PACKAGES[@]}"

# === Clean up unwanted apps ===
log "Removing Packages and related config..."
sudo pacman -Rns --noconfirm "${PACKAGES_REMOVE[@]}" || true
rm -f "$HOME/.config/1password"


# === Remove webapps ===
log "Removing Basecamp and Hey webapps via omarchy script..."
omarchy-webapp-remove "${WEBAPP_REMOVE[@]}"

# === Apply dotfiles ===
DOTFILES_DIR="$HOME/.config"
cd "$DOTFILES_DIR" || {
  log "❌ Could not enter $DOTFILES_DIR"
  exit 1
}

log "Applying dotfiles with stow..."
for dir in */; do
  log "→ Stowing ${dir%/}"
  stow -R "${dir%/}"
done

log "✅ System initialization complete!"
