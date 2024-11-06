#!/usr/bin/env bash

################################################################################
# macOS itself
################################################################################

# Allow key repeat when holding a key like "e" rather than showing a
# diacritic-chooser dialog
defaults write -g ApplePressAndHoldEnabled -bool false

# Use the Dark appearance.
defaults write NSGlobalDomain AppleInterfaceStyle Dark

# Show scroll bars all the time. I think this is helpful when streaming
# so that people know how long a page/document is.
defaults write NSGlobalDomain AppleShowScrollBars -string "Always"

# Jump to the scroll-bar spot that was clicked.
defaults write NSGlobalDomain AppleScrollerPagingBehavior -bool true

# Disable smart quotes.
defaults write NSGlobalDomain NSAutomaticQuoteSubstitutionEnabled -bool false

# Disable smart dashes.
defaults write NSGlobalDomain NSAutomaticDashSubstitutionEnabled -bool false

# Hot corners: bottom left → Mission Control.
defaults write com.apple.dock wvous-bl-corner -int 2
defaults write com.apple.dock wvous-bl-modifier -int 0

# Hot corners: bottom right → Mission Control.
defaults write com.apple.dock wvous-br-corner -int 2
defaults write com.apple.dock wvous-br-modifier -int 0

# Disable bigger mouse pointer when shaking it.
defaults write NSGlobalDomain CGDisableCursorLocationMagnification -bool true

# Stop capturing shadows in screenshots since they expand the dimensions of the
# capture.
defaults write com.apple.screencapture disable-shadow -bool true

########################################
# Keyboard shortcuts
########################################

# Note to self: to bind something like ⌥⌘F4, see
# https://stackoverflow.com/a/77154760/3595355. The string is "@~".

# ⌥⌘⇧W (I also use this for "close tabs to the right" in other apps like
# VSCode and iTerm 2)
defaults write com.google.Chrome NSUserKeyEquivalents -dict-add "Close Tabs to the Right" -string '@~$w'

# ⌘E so that it's like what it was on Windows
defaults write com.microsoft.onenote.mac NSUserKeyEquivalents -dict-add "Search All Notebooks" -string '@e'

########################################
# Dock
########################################

# Do not show recently used apps in a separate section of the Dock.
defaults write com.apple.dock show-recents -bool false

# Autohides the Dock.
defaults write com.apple.dock autohide -bool true

########################################
# Finder
########################################

# Show all filename extensions.
defaults write NSGlobalDomain AppleShowAllExtensions -bool true

# Show path bar.
defaults write com.apple.finder ShowPathbar -bool true

# Use list view in all Finder windows by default.
# Four-letter codes for the other view modes: `icnv`, `clmv`, `Flwv`.
defaults write com.apple.finder FXPreferredViewStyle -string "Nlsv"


################################################################################
# AltTab configuration
################################################################################
# https://alt-tab-macos.netlify.app/

# Preview the selected window
defaults write com.lwouis.alt-tab-macos previewFocusedWindow true

# ⌘Tab to switch windows
defaults write com.lwouis.alt-tab-macos holdShortcut "\\U2318"

# ⌥` should just be disabled since I don't like having a dialog show up
# for that.
defaults write com.lwouis.alt-tab-macos nextWindowShortcut2 ""

# Show tabs as icons+names, not windows. This is to hopefully prevent
# leaks while streaming.
defaults write com.lwouis.alt-tab-macos hideThumbnails true

# I don't really use spaces, so the numbers that show are extaneous
# information.
defaults write com.lwouis.alt-tab-macos hideSpaceNumberLabels true


################################################################################
# iTerm 2
################################################################################

# Load preferences from a custom folder.
defaults write com.googlecode.iterm2 LoadPrefsFromCustomFolder -bool true

# Save preference changes automatically.
defaults write com.googlecode.iterm2 NoSyncNeverRemindPrefsChangesLostForFile_selection -int 2
