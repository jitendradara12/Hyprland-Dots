# Hyprland-dots

Based on KooL's Hyprland dotfiles.

## Local Management & Syncing

### Option A: Direct Symlink Sync (Recommended)

To keep your live `~/.config` in sync with your local git clone.

Run the helper link script (automatically backs up existing configurations to `.bak.[timestamp]` folders):

```bash
./scripts/link_dots.sh
```

### Option B: Traditional Copy Install

To manually copy files from the repository to `~/.config`:

```bash
chmod +x copy.sh
./copy.sh
```

_Note: This script will create backups of any conflicting files in your `~/.config` directory._
