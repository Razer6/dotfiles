#!/bin/bash

# Close any open System Preferences panes to prevent overrides
osascript -e 'tell application "System Preferences" to quit'

echo "Configuring macOS system defaults..."

###############################################################################
# Keyboard & Input                                                            #
###############################################################################

# Set a blazingly fast keyboard repeat rate
defaults write NSGlobalDomain KeyRepeat -int 1
defaults write NSGlobalDomain InitialKeyRepeat -int 10

# Disable auto-correct and "smart" substitutions that mess with code/terminal
defaults write NSGlobalDomain NSAutomaticSpellingCorrectionEnabled -bool false
defaults write NSGlobalDomain NSAutomaticQuoteSubstitutionEnabled -bool false
defaults write NSGlobalDomain NSAutomaticDashSubstitutionEnabled -bool false

###############################################################################
# Finder                                                                      #
###############################################################################

# Show all filename extensions
defaults write NSGlobalDomain AppleShowAllExtensions -bool true

# Show path bar in Finder (helpful for navigation)
defaults write com.apple.finder ShowPathbar -bool true

# Keep folders on top when sorting by name
defaults write com.apple.finder _FXSortFoldersFirst -bool true

# When performing a search, search the current folder by default
defaults write com.apple.finder FXDefaultSearchScope -string "SCcf"

# Disable the warning when changing a file extension
defaults write com.apple.finder FXEnableExtensionChangeWarning -bool false

# Avoid creating .DS_Store files on network or USB volumes
defaults write com.apple.desktopservices DSDontWriteNetworkStores -bool true
defaults write com.apple.desktopservices DSDontWriteUSBStores -bool true

###############################################################################
# Dock & Dashboard                                                            #
###############################################################################

# Set the icon size of Dock items (in pixels)
defaults write com.apple.dock tilesize -int 40

# Automatically hide and show the Dock
defaults write com.apple.dock autohide -bool true

# Speed up the show/hide animation of the Dock
defaults write com.apple.dock autohide-delay -float 0
defaults write com.apple.dock autohide-time-modifier -float 0.4

# Don’t show recent applications in Dock
defaults write com.apple.dock show-recents -bool false

###############################################################################
# System Settings                                                             #
###############################################################################

# Save screenshots to the Desktop
defaults write com.apple.screencapture location -string "${HOME}/Desktop"

# Save screenshots in PNG format (other options: BMP, GIF, JPG, PDF, TIFF)
defaults write com.apple.screencapture type -string "png"

# Check for software updates daily, not just once per week
defaults write com.apple.SoftwareUpdate ScheduleFrequency -int 1

###############################################################################
# Kill affected apps                                                          #
###############################################################################

for app in "Dock" "Finder" "SystemUIServer"; do
    killall "$app" > /dev/null 2>&1
done

echo "Done. Note that some of these changes require a logout/restart to take effect."
