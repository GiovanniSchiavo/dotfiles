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

STOW_CONFIG_DIRS=(
  hypr
  uwsm
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

log "Removing Omarchy hypr config files..."
rm -rf "$HOME/.config/hypr/bindings.conf" "$HOME/.config/hypr/monitors.conf" "$HOME/.config/hypr/input.conf"
rm -rf "$HOME/.config/uwsm/default" 

log "Applying dotfiles with stow..."
for dir in "${STOW_CONFIG_DIRS[@]}"; do
  log "→ Stowing ${dir%/}"
  stow -t "$HOME" "${dir%/}"
done

log "✅ System initialization complete!"
