MODDIR="${0%/*}"

if [ -f "$MODDIR/procmods" ]; then
    rm $MODDIR/procmods && {
        touch $MODDIR/disable || exit 0
    }; else
    touch $MODDIR/remove
    echo "  $(date) - Some file are missing?" > /sdcard/reversiond.log || exit 0
fi
