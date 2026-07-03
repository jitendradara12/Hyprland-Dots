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

#### ⚠️ BACKUPS CREATED by SCRIPT

> [!CAUTION]
> `copy.sh` creates a backup!
> Kindly investigate manually contents on your `$HOME/.config`
> Delete manually any backups which you dont want.

#### 🛎️ a small note on wallpapers

- by default, only few wallpapers will be copied (1 each dark and light plus 3 more). You will be offered to download more wallpapers. You can preview/check the additional wallpapers from this [`LINK`](https://github.com/LinuxBeginnings/Wallpaper-Bank/tree/main/wallpapers)

#### ⚠️ after installing these dots

- NVIDIA Owners.
  - After installation, check [`THIS`](https://github.com/LinuxBeginnings/Hyprland-Dots/wiki/FAQ_NVIDIA)
  - Make sure to edit your `~/.config/hypr/UserConfigs/ENVariables.conf` (highly recommended).
- Hybrid Intel/NVIDIA or AMD/NVIDIA laptops may need cursor handoff fixes
  - The installer now enables XCURSOR fallbacks and a startup cursor refresh when hybrid GPUs are detected.
- If you have already set your own keybinds, monitors, etc.... Just copy over from backup created before log-out or reboot. (recommended)

#### 🙋 QUESTIONS ?

- FAQ! Yes you can use these dotfiles to other distro! Just ensure to install proper packages first! If it makes you feel better, I use same config on my Gentoo:)
- QUICK HINT! Click the HINT! Waybar module (only available on some layouts). Also can be launched by keybind `SUPER + H`
- More question? click here browse through this [WIKI](https://github.com/LinuxBeginnings/Hyprland-Dots/wiki/)

#### ⌨ Keybinds

- Keybinds [`HERE`](https://github.com/LinuxBeginnings/Hyprland-Dots/wiki/Keybinds)

### ✍️ Contributing

- If you have improvements on the dotfiles or configuration, feel free to submit a PR for improvement.
    - Pull Requests (PRs) must be submitted against the `development` branch! 
    - Those submitted against the `main` branch will be closed 
    - The `main` branch is only for fully tested code 
       - Your change might work fine for your distro but not for the others we support 
- I always welcome improvements as I am also just learning just like you guys!

- Click [`HERE`](https://github.com/LinuxBeginnings/Hyprland-Dots/blob/main/CONTRIBUTING.md) for a guide how to contribute

> Thanks to all who have contributed code, or support on the Discord server. Your efforts are greatly appreciated

### 🔮 Discord Server

- Want to contribute? Click [`HERE`](https://github.com/LinuxBeginnings/Hyprland-Dots/blob/main/CONTRIBUTING.md) for a guide how to contribute

  > Thanks to all who have contributed code, or support on the Discord server. You efforts are greatly appreciated

- kindly join my [Discord](https://discord.gg/RZJgC7KAKm)

### 💖 Support

- a Star on my Github repos would be nice 🌟
- Subscribe to my Youtube Channel [YouTube](https://www.youtube.com/@LinuxBeginnings)
   > Note:  Videos coming soon to the YouTube channel!  

## 🫰 Thank you for the stars 🩷

### Document translations

- Spanish: [Código de Conducta](./i18n/CODE_OF_CONDUCT/CODE_OF_CONDUCT.es.md) · [Guía de mensajes de commit](./i18n/COMMIT_MESSAGE_GUIDELINES/COMMIT_MESSAGE_GUIDELINES.es.md) · [Guía de contribución](./i18n/CONTRIBUTING/CONTRIBUTING.es.md)

- French: [Code de Conduite](./i18n/CODE_OF_CONDUCT/CODE_OF_CONDUCT.fr.md) · [Directives pour les messages de commit](./i18n/COMMIT_MESSAGE_GUIDELINES/COMMIT_MESSAGE_GUIDELINES.fr.md) · [Guide de contribution](./i18n/CONTRIBUTING/CONTRIBUTING.fr.md)
