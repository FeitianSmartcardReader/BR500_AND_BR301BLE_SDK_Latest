#!/bin/bash
sudo defaults write /Library/Preferences/com.apple.security.smartcard Logging -bool yes
log stream --predicate 'process == "com.apple.ifdreader"' --debug
