#!/bin/sh

source ~/.zshrc

git clone git@github.com:oleander/hub-swift.git
cd hub-swift
git stash

rm -r .build
rm -f Package.resolved

git pull origin master
swift build
