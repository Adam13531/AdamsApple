# AdamsApple
Scripts, configuration, and other setup information for my Mac.

## How to use

I should eventually replace everything with https://github.com/anishathalye/dotbot, but I don't want to "perfect" to be the enemy of "good", so I just wrote my own `install.sh` quickly. Running that copies some files to the right locations, but it doesn't install every program on its own.

## Specific notes

### iTerm2

Don't symlink the `plist` file or you run into [this bug](https://gitlab.com/gnachman/iterm2/-/issues/10962). Instead, simply go to iTerm2 → Preferences → General → Preferences → Load preferences from a custom folder or URL and supply `preferences/iTerm2/com.googlecode.iterm2.plist`.

### VSCode

Settings are synced through my personal Microsoft account, so I didn't add them here.

### Raycast

I only use this for its ability to globally hotkey applications. I think you have to manually import the `preferences/[...]rayconfig` file through Raycast itself (Settings → Advanced → Import / Export).

### Homepage symlink

If this isn't a hack to top all hacks...

I made `/C:/AdamSymlinks` on my Mac for one reason: so that my Chrome homepage will migrate nicely between my Windows and macOS machines while always pointing at the same underlying location in OneDrive. However, Chrome either syncs all of your settings or none of them, so I can't choose to migrate everything *except* my homepage link. I couldn't figure out how to specify a path that would be valid for both Windows and macOS without any hacks, so I opted for a Windows-like path.

How to make this work on macOS:

- Make /etc/synthetic.conf as mentioned here: https://apple.stackexchange.com/a/388244. Contents (note: the space in between apparently has to be a `\t`):
  `C:	Users/adam/Documents`
- Reboot
- `ln -s /Users/adam/Library/CloudStorage/OneDrive-Personal/Documents/Homepage /Users/adam/Documents/AdamSymlinks/homepage`

How to make a symlink on Windows:

- `"C:\Program Files\Git\usr\bin\ln.exe" -s B:\OneDrive\Documents\Homepage ./homepage`

### OS settings

- System Settings → Keyboard → Keyboard Shortcuts... → App Shortcuts → ➕
  - Application: Google Chrome
  - Menu Title: Close Tabs to the Right
  - Keyboard Shortcut: ⌥⇧⌘W
  - Application: Microsoft OneNote
  - Menu Title: Search All Notebooks
  - Keyboard Shortcut: ⌘E
