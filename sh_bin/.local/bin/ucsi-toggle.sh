#!/bin/sh
case "$1" in
    pre)
        # Unload before sleep so the port falls back to dumb charging
        modprobe -r ucsi_acpi typec_ucsi
        ;;
    post)
        # Reload after wake to force a clean hardware re-initialization
        modprobe ucsi_acpi typec_ucsi
        ;;
esac
