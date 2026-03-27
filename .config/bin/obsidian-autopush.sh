#!/usr/bin/env bash

pgrep -x obsidian && exit 0

VAULT="$HOME/Desktop/Vaults/Red Team"
cd "$VAULT" || exit 1

/usr/bin/git add .
/usr/bin/git diff --cached --quiet && exit 0
/usr/bin/git commit -m "Vault Update: $(date '+%d-%m-%Y %H-%M')"
/usr/bin/git push
