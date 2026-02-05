#!/usr/bin/env bash

# This script is used to set the pcmanfm theme to the current theme
# run async to avoid blocking the shell
pkill pcmanfm-qt && pcmanfm-qt --desktop &
