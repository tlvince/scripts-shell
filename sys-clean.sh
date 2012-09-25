#!/bin/bash
# A system clean-up script.
# Copyright 2012 Tom Vincent <http://tlvince.com/contact>
#
# Author:   Tom Vincent
# Version:  0.4.2 (2009-09-08)
#
# Changelog:
# Original Version: 0.4.0 (2009-02-01)
# Version:          0.4.1 (2009-03-27)

# Clean thumbnails
rm -rf ~/.config/purple/icons/*
rm -rf ~/.thumbnails/*

# Clean trash
rm -rf ~/.local/share/Trash/*
sudo rm -rf /root/.local/share/Trash/*

# Clean cookies
#rm -rf ~/.opera/cache4/*
#rm -rf ~/.opera/opcache/*
#rm -rf ~/.opera/images/*
#rm -rf ~/.opera/thumbnails/*

# Clean packages
#sudo apt-get autoclean
#sudo apt-get clean
#sudo apt-get autoremove
#sudo deborphan | xargs sudo apt-get -y purge
#localepurge
sudo pacman -Scc

echo "$0 has completed successfully" | dzen2 -p 3 &
