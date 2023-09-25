# AdamsApple

Scripts, configuration, and other setup information for my Mac.

## How to use

Just run `./install` (or `./install -v` for verbose output).

Then, I have a bunch of notes below because I didn't automate everything all at once.

## Specific notes

### iTerm2

Don't symlink the `plist` file or you run into [this bug](https://gitlab.com/gnachman/iterm2/-/issues/10962). Instead, simply go to iTerm2 → Preferences → General → Preferences → Load preferences from a custom folder or URL and supply `preferences/iTerm2/com.googlecode.iterm2.plist`. Alternatively, use this command:

`defaults write com.googlecode.iterm2 PrefsCustomFolder -string "/some/path/here/to/the/plist"`

Set up ⌥⇧⌘W to close tabs to the right ([reference](https://iterm2.com/python-api/examples/close_to_the_right.html)).

### Git

- Install [Delta](https://github.com/dandavison/delta).
- `git config --global core.editor "'/Applications/Visual Studio Code.app/Contents/Resources/app/bin/code' -w"`
- `git config --global help.autocorrect 30`

### VSCode

Settings are synced through my personal Microsoft account, so I didn't add them here.

### Karabiner-Elements

I only use this so that my keyboard modifiers affect my mouse ([reference](https://superuser.com/a/1031484)). However, by having Karabiner-Elements enabled on my keyboard at all, I hit [this issue](https://github.com/pqrs-org/Karabiner-Elements/issues/3545).

### Rectangle

Preferences... → go to the third tab → Import → Choose `RectangleConfig.json` from this repo.

### Homepage symlink

If this isn't a hack to top all hacks...

I made `/C:/AdamSymlinks` on my Mac for one reason: so that my Chrome homepage will migrate nicely between my Windows and macOS machines while always pointing at the same underlying location in OneDrive. However, Chrome either syncs all of your settings or none of them, so I can't choose to migrate everything *except* my homepage link. I couldn't figure out how to specify a path that would be valid for both Windows and macOS without any hacks, so I opted for a Windows-like path.

How to make this work on macOS:

- Make `/etc/synthetic.conf` as mentioned here: https://apple.stackexchange.com/a/388244. Contents (note: the space in between apparently has to be a `\t`):
  `C:	Users/adam/Documents`
- Reboot
- `ln -s /Users/adam/Library/CloudStorage/OneDrive-Personal/Documents/Homepage /Users/adam/Documents/AdamSymlinks/homepage`

How to make a symlink on Windows:

- `"C:\Program Files\Git\usr\bin\ln.exe" -s B:\OneDrive\Documents\Homepage ./homepage`

### QMK

At least as of Tue 07/04/2023, there's only a Rosetta version available ([reference](https://docs.qmk.fm/#/newbs_getting_started)).

When I tried following their guide, I got this:

```
$ arch -x86_64 brew install qmk/qmk/qmk

Error: Cannot install under Rosetta 2 in ARM default prefix (/opt/homebrew)!
To rerun under ARM use:
    arch -arm64 brew install ...
To install under x86_64, install Homebrew into /usr/local.
```

Their installation command for Homebrew (`arch -x86_64 /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install.sh)"`) did indeed install it in `/usr/local`, so I just had to run this command to install QMK: `arch -x86_64 /usr/local/Homebrew/bin/brew install qmk/qmk/qmk`.

Actually, I think I just needed to remove `/opt/homebrew/bin:/opt/homebrew/sbin` from my `PATH` (`export PATH=<all but /opt/homebrew stuff>`), otherwise `qmk setup` would complain about `/usr/local` since it was using the native version (since that's what it found in the `PATH`).

Then, I installed to my external drive with `qmk setup Adam13531/qmk_firmware -H /Volumes/inland/code/qmk` (note that this puts all of the QMK repo directly into the `qmk` folder as opposed to creating `qmk/qmk`).

For whatever reason, that didn't actually clone my repo, so I just did `git remote set-url origin https://github.com/Adam13531/qmk_firmware` and then `git pull --rebase`. At that point, I could flash my keyboard with the instructions in [my README](https://github.com/Adam13531/qmk_firmware).

### Brew

Not gonna bother automating this until I need to reinstall. Here's a list of Brew formulae/casks that I have, last updated 09/13/2023.

```
╰─❯ brew list
==> Formulae
bat			gh			lz4			mecab-ipadic		pcre			xz
ca-certificates		git-delta		mariadb			msgpack			pcre2			zsh-syntax-highlighting
fzf			groonga			mecab			openssl@3		ripgrep			zstd

==> Casks
qlmarkdown		syntax-highlight
```

(note: I don't know how something like "groonga" is there; I don't think I installed that myself 🤔)

### Chrome

#### uBlock Origin

To block the `@` completions for Google Docs (so that I don't leak sensitive info while streaming), add this in "My Filters":

```
! 2023-07-08 https://docs.google.com
docs.google.com##.docs-ui-unprintable.apps-search-menu
```

### Shortcuts

See [the README in `shortcuts`](./shortcuts/README.md).

### OS settings

- System Settings → Keyboard → Keyboard Shortcuts... → Services
  - Turn off practically all of these (they're things like "Make New Sticky Note" or "Convert Text to Simplified Chinese").
