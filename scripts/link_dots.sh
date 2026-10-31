#!/usr/bin/env bash

# link_dots.sh
# Safely backups existing files/dirs in ~/.config and ~/.zshrc and symlinks them to ~/code/temp/Hyprland-dots/config/

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
DOTFILES_CONFIG_DIR="$(cd "$SCRIPT_DIR/../config" && pwd)"
TARGET_DIR="$HOME/.config"
TIMESTAMP=$(date +%Y%m%d%H%M%S)

echo "Starting synchronization of config files..."
echo "Source: $DOTFILES_CONFIG_DIR"
echo "Target: $TARGET_DIR"
echo

# Ensure target directory exists
mkdir -p "$TARGET_DIR"

# Loop through all files and directories in the dotfiles config folder (including hidden ones)
shopt -s dotglob
for item_path in "$DOTFILES_CONFIG_DIR"/*; do
    [ -e "$item_path" ] || continue
    item_name=$(basename "$item_path")
    
    # Skip standard metadata / Git / ignore files and files managed by NixOS/Home Manager (like zshrc)
    if [[ "$item_name" == "." || "$item_name" == ".." || "$item_name" == ".git" || "$item_name" == ".gitignore" || "$item_name" == "README.md" || "$item_name" == "AGENTS.md" || "$item_name" == "tool_state" || "$item_name" == "zshrc" ]]; then
        continue
    fi
    
    target_path="$TARGET_DIR/$item_name"
    
    if [ -e "$target_path" ] || [ -L "$target_path" ]; then
        # If it's already a symlink pointing to the correct source, skip it
        if [ -L "$target_path" ] && [ "$(readlink -f "$target_path")" = "$(readlink -f "$item_path")" ]; then
            echo "✓ $item_name is already correctly symlinked to $target_path."
            continue
        fi
        
        # If it is a real file or directory (not a symlink), back it up
        if [ ! -L "$target_path" ]; then
            backup_path="${target_path}.bak.${TIMESTAMP}"
            echo "⚠️  Moving existing target $target_path to $backup_path"
            mv "$target_path" "$backup_path"
        else
            # If it is a symlink pointing elsewhere, remove the old symlink
            echo "Replacing existing symlink for $item_name at $target_path"
            rm "$target_path"
        fi
    fi
    
    # Create the symlink
    echo "Creating symlink for $item_name -> $target_path"
    ln -sf "$item_path" "$target_path"
done
shopt -u dotglob

# Cleanup old redundant/mistaken symlinks in ~/.config
for old_symlink in "zshrc" "dns.sh" "updatehaha.sh" "AGENTS.md" "tool_state" "README.md" ".gitignore"; do
    if [ -L "$TARGET_DIR/$old_symlink" ]; then
        echo "🧹 Cleaning up legacy redundant symlink at $TARGET_DIR/$old_symlink"
        rm "$TARGET_DIR/$old_symlink"
    fi
done

# If ~/.zshrc is a symlink pointing to our repo, remove it so NixOS Home Manager manages it
if [ -L "$HOME/.zshrc" ] && [ "$(readlink -f "$HOME/.zshrc")" = "$(readlink -f "$DOTFILES_CONFIG_DIR/zshrc")" ]; then
    echo "🧹 Removing legacy ~/.zshrc symlink (managed by NixOS Home Manager)"
    rm "$HOME/.zshrc"
fi

# Waybar needs a concrete config to open. The installer normally creates
# ~/.config/hypr/waybar/config -> configs/<layout>; a hand-linked checkout
# skips that step, so create the generated link here.
waybar_dir="$TARGET_DIR/hypr/waybar"
if [ -d "$waybar_dir/configs" ] && [ ! -e "$waybar_dir/config" ]; then
    waybar_config="$waybar_dir/configs/TOP-Default"
    if compgen -G "/sys/class/power_supply/BAT*" >/dev/null 2>&1; then
        waybar_config="$waybar_dir/configs/TOP-Default-Laptop"
    fi
    [ -f "$waybar_config" ] || waybar_config="$waybar_dir/configs/TOP-Default"
    if [ -f "$waybar_config" ]; then
        ln -sf "$waybar_config" "$waybar_dir/config"
        echo "Creating Waybar config symlink for $waybar_config"
    fi
fi

# The active Waybar layout is generated state, not a file to commit.
exclude_file="$SCRIPT_DIR/../.git/info/exclude"
if [ -f "$exclude_file" ] && ! grep -qxF '/config/hypr/waybar/config' "$exclude_file"; then
    printf '%s\n' '/config/hypr/waybar/config' >> "$exclude_file"
fi

echo
echo "✓ Sync complete! All dotfiles are now symlinked."
echo "You can now edit files as normal, and commit/push changes from $SCRIPT_DIR/.."
