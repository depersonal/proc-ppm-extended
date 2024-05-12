MODDIR="${0%/*}"

function wait_until_login() {
    while [[ `getprop sys.boot_completed` -ne "1" ]] && {
        [[ ! -d "/sdcard" ]]
    }; do
        sleep 2
    done
    
    local test_file=/sdcard/.PERMISSION_TEST

    touch "$test_file"
    while [ ! -f "$test_file" ]; do
        touch "$test_file"
        sleep 1
    done
    
    rm "$test_file"
}; wait_until_login

sleep 2

if [ -f "$MODDIR/procmods" ]; then
    $MODDIR/procmods || exit 0; else
    echo "  $(date) - File is missing?" > /sdcard/reversiond.log || exit 0
fi
