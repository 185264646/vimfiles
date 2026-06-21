#!/bin/sh
# A script to install this repo to your system

set -e

mkdir -p ~/.vim
cd ~/.vim

if [ -d .git ]; then
	git pull
else
	# -b master is specified to avoid the warning about the default branch name
	git init -b master
	git remote add origin git@github.com:185264646/vimfiles.git
	git fetch
	git reset FETCH_HEAD
fi
