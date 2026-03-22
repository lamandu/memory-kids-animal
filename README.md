# Memory Kids Animal 🐾

A modern memory card game for children, built with **Godot 4.6.1**. Features cute animals, smooth animations, and a progression system with difficulty levels. Designed for Android (Google Play) with Steam as a secondary target.

## Overview

This project is a complete modernization of a legacy Cocos Creator game. It includes:
- 3 difficulty levels (Easy, Medium, Hard)
- Smooth flip animations and visual feedback
- Star rating system based on attempts
- Responsive grid layout for different screen sizes
- Built-in support for multiple animal themes

## Project Structure

```
memory-kids-animal/
├── project.godot              # Godot configuration
├── README.md                  # This file
├── assets/
│   ├── icon.svg              # App icon
│   └── animals/              # Animal sprite images (11 PNG files)
├── scenes/
│   ├── Splash.tscn          # Splash screen
│   ├── Menu.tscn            # Main menu with difficulty selection
│   ├── Game.tscn            # Main game scene
│   ├── Victory.tscn         # Victory screen with star animations
│   └── components/
│       └── Card.tscn        # Card prefab
├── scripts/
│   ├── Global.gd            # Autoload singleton - game state & config
│   ├── Splash.gd            # Splash screen logic
│   ├── Menu.gd              # Menu & difficulty selection
│   ├── Game.gd              # Main game logic & card grid
│   ├── Card.gd              # Card behavior & animations
│   └── Victory.gd           # Victory screen & star animation
└── doc/
    ├── analise-modernizacao.md    # Full analysis (Portuguese)
    └── setup-e-publicacao.md      # Android/Steam setup guide (Portuguese)
```

## Quick Start

### Requirements
- **Godot 4.6.1** or later
- **OpenJDK 17+** (for Android export)
- **Android SDK** (for building APK)

### Installation

1. **Download & Extract Godot 4.6.1**
   ```bash
   # Or install from https://godotengine.org/download
   # Extract to: C:\Tools\Godot\ (or your preferred location)
   ```

2. **Add Godot to PATH** (Windows)
   - Settings → Environment Variables
   - Add `E:\tools\Godot` (adjust to your path) to `Path`
   - Restart terminal

3. **Open the project**
   ```bash
   godot "d:/workspaces/workspacePortifolio/memory-kids-animal/project.godot"
   ```

4. **Run in editor**
   - Press `F5` or click the ▶ Play button

## Features

### Core Gameplay
- **Card Flipping:** Smooth 3D-like flip animation
- **Match Detection:** Visual feedback for correct/incorrect matches
- **Difficulty Levels:**
  - Easy: 6 unique animals (12 cards)
  - Medium: 10 unique animals (20 cards)
  - Hard: 11 unique animals (22 cards)
- **Star Rating:** 1-3 stars based on attempt count
- **Responsive Grid:** Adapts to different screen sizes

### Visual Feedback
- ✅ Match found: Card glows green with scale animation
- ❌ Mismatch: Card shakes gently
- ⭐ Victory: Animated star burst effect
- 🎨 Smooth transitions between scenes

### Animals Included
Bear, Chick, Cow, Dog, Elephant, Giraffe, Penguin, Pig, Rabbit, Snake, Whale

## Development Roadmap

### Phase 1: MVP (✅ Completed)
- [x] Core game mechanics
- [x] Three difficulty levels
- [x] Animations & feedback
- [x] Star rating system
- [x] Menu & navigation

### Phase 2: Launch (In Progress)
- [ ] Sound effects & background music
- [ ] Sound toggle button
- [ ] Mute icon/controls
- [ ] AdMob integration
- [ ] In-app purchase (remove ads)
- [ ] COPPA compliance for Google Play

### Phase 3: Expansion (Planned)
- [ ] Additional animal themes (Jungle, Ocean, Arctic, Insects, Dinosaurs)
- [ ] Level progression map
- [ ] Animal collection/album
- [ ] Daily rewards
- [ ] Localization (EN, ES, PT-BR)
- [ ] Firebase Analytics
- [ ] Accessibility features

### Phase 4: Steam (Post-Android)
- [ ] Desktop layout adaptation
- [ ] Mouse/keyboard/gamepad controls
- [ ] Steam achievements
- [ ] Cloud save integration

## Building for Android

### Setup Android Development Environment

1. **Install Android Studio** or Android SDK command-line tools
   - Download from: https://developer.android.com/studio

2. **Configure Godot**
   - Editor → Editor Settings
   - Set `Export/Android/Java SDK Path` → `C:\Program Files\Microsoft\jdk-17.0.18.8-hotspot`
   - Set `Export/Android/Android SDK Path` → `C:\Users\YourUser\AppData\Local\Android\Sdk`

3. **Install Export Templates**
   - Editor → Manage Export Templates
   - Click "Download and Install" (≈500MB)

4. **Create Keystore** (for Play Store signing)
   ```bash
   keytool -genkey -v \
     -keystore memory-kids-animal.keystore \
     -alias memorykids \
     -keyalg RSA \
     -keysize 2048 \
     -validity 10000
   ```

### Export APK/AAB

```bash
# Generate AAB (recommended for Play Store)
godot --export-release "Android" memory-kids-animal.aab

# Or generate APK (for direct installation)
godot --export-release "Android" memory-kids-animal.apk
```

### Test on Device

```bash
# Install via ADB
adb install memory-kids-animal.apk

# View logs
adb logcat -s "Godot"
```

## Publishing on Google Play

### Requirements
- **Developer Account:** $25 one-time fee
- **Privacy Policy:** Required for apps targeting children
- **COPPA Compliance:** Must follow Children's Online Privacy Protection Act
- **Age Rating:** Questionnaire required
- **Graphics & Description:** Screenshots, feature graphic, app description

### Steps
1. Create app in [Google Play Console](https://play.google.com/console)
2. Mark as "Designed for Families"
3. Configure COPPA settings
4. Upload screenshots (min 2 phone, min 1 tablet 7")
5. Write description (short: 80 chars, long: 4000 chars)
6. Upload AAB file
7. Submit for review (1-7 days)

For detailed setup guide, see [doc/setup-e-publicacao.md](doc/setup-e-publicacao.md) (Portuguese).

## Publishing on Steam

Steam support is planned as a secondary target. Requirements:
- Steamworks account ($100 one-time fee per game)
- Desktop layout adaptation (landscape 16:9)
- Mouse/keyboard/gamepad support
- Achievements integration

## Technologies

| Technology | Version | Purpose |
|------------|---------|---------|
| Godot Engine | 4.6.1 | Game engine |
| GDScript | 2.0 | Game logic & scripting |
| OpenJDK | 17.0.18 | Android compilation |
| Android SDK | API 21+ | Android deployment |

## Game Design Notes

### Target Audience
Children ages 3-8 years old

### Design Principles
- **Simple & Intuitive:** Minimal UI, big touch targets (48dp+)
- **Forgiving Gameplay:** No punishment for mistakes, gentle feedback
- **Encouraging:** Star system motivates replaying
- **Educational:** Animal names can be spoken aloud (future feature)
- **Accessible:** High contrast, large fonts, colorblind mode support (planned)

### Color Palette
- **Background:** Sky blue (#1FA3E3)
- **Cards (Back):** Soft blue (#3A8FD0)
- **Cards (Front):** Cream white (#FAFAF8)
- **Match Success:** Soft green (#C7F0D8)
- **Text:** Dark gray (#2D3436)
- **Accents:** Warm orange (#FF9F43), Pink (#FD79A8)

## Code Architecture

### Global State (Global.gd)
Centralized configuration and game state:
- Difficulty settings with star thresholds
- Animal themes
- Session state (attempts, matched pairs, stars)

### Game Loop (Game.gd)
- Responsive grid layout calculation
- Card instantiation and management
- Match detection and feedback
- HUD updates

### Card Behavior (Card.gd)
- Flip animation with scale transformation
- Match/mismatch effect playback
- Touch input handling
- Dynamic texture loading

### Scene Management
- Splash → Menu → Game → Victory → Menu (loop)
- Smooth transitions via `Global.go_to(scene_path)`

## Performance

### Target Metrics
- **APK Size:** < 50MB
- **RAM Usage:** < 200MB
- **Frame Rate:** 60 FPS on mid-range devices (Android 5.0+)
- **Load Time:** < 2 seconds

### Optimizations
- Sprite frame inlining (Godot project setting)
- Mobile renderer (GL compatibility)
- Responsive grid sizing (no fixed dimensions)

## Troubleshooting

### Godot won't open the project
- Add Godot executable to Windows PATH
- Restart terminal after PATH update
- Use full path: `"C:\Tools\Godot\Godot_v4.6.1-stable_win64.exe" "project.godot"`

### Type errors in GDScript
- Ensure all variables have explicit types (`:` not `:=` for complex assignments)
- Check Godot version (4.6.1+)
- Restart editor if caching issues occur

### Android export fails
- Verify JDK 17+ path in Editor Settings
- Install Android export templates (Editor → Manage Export Templates)
- Check Android SDK path is valid
- Ensure API level 21+ is installed

## License

This project is provided as-is for educational and commercial use.

## Contact & Support

For issues or questions related to this project, contact the project maintainer.

---

**Built with ❤️ using Godot Engine**

[Godot Documentation](https://docs.godotengine.org) | [GDScript Guide](https://docs.godotengine.org/en/stable/getting_started/scripting/gdscript/index.html)
