# Manjaro Hello — UI/UX Concept

A lightweight **Qt6 + QML** community concept for a modernized `manjaro-hello`, designed to welcome newcomers without bloating the ISO.

## Highlights
- **5-Card Horizontal Walkthrough:** Smooth swipe/arrow-key navigation with a frameless translucent UI.
- **30-Second Survival Guide:** Jargon-free onboarding covering Rolling Releases, avoiding random terminal scripts, and Timeshift snapshots.
- **JSON-Driven FOSS App Picker:** Non-hardcoded categories (`data/apps.json`) in a slanted accordion layout with clear *Proprietary* badges and a copyable `pamac` command preview.
- **Mascot Concept (Baby Masai Giraffe):** Manjaro is named after Mount Kilimanjaro in Tanzania—and the Masai giraffe (*Twiga*) is Tanzania's national animal. Included as a playful "Manjaro 2.0" community pitch.

## Quick Run (Manjaro)
```bash
sudo pacman -S --needed pyside6 noto-fonts
git clone [https://github.com/AwwsmGaurav/manjaro-hello-concept.git](https://github.com/AwwsmGaurav/manjaro-hello-concept.git)
cd manjaro-hello-concept
python main.py
```

Or install locally via makepkg -si and run manjaro-hello-concept.

License
MIT
