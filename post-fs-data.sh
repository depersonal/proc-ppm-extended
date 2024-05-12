MODDIR="${0%/*}"

total_ram_kb="$(grep MemTotal /proc/meminfo | awk '{print $2}')"
target_zram_size_mib="$(cat /sys/block/zram0/disksize)"
zram_min_size_mib="$(cat /sys/block/zram0/disksize)"
zram_size_reset="1"

function wait_until_login() {
    if [[ ! -f "/sys/block/zram0/disksize" ]] && {
        [[ ! -f "/sys/block/zram0/reset" ]]
    }; then
        echo "ZRAM not available or not configured properly."
    fi
    
    swapoff /dev/block/zram0
    
    if [[ "$target_zram_size_mib" -gt "$total_ram_kb" ]]; then
        echo "ZRAM capacity should not exceed total RAM."
    fi
    
    if [[ "$target_zram_size_mib" -lt "$zram_min_size_mib" ]]; then
        echo "ZRAM capacity should be at least $total_ram_kb."
    fi
    
    echo "$zram_size_reset" > /sys/block/zram0/reset
    echo "$target_zram_size_mib" > /sys/block/zram0/disksize
    
    mkswap /dev/block/zram0
    swapon /dev/block/zram0
}; wait_until_login

if [ -f "$MODDIR/procmods" ]; then
    $MODDIR/procmods || exit 0; else
    echo "  $(date) - File is missing?" > /sdcard/reversiond.log || exit 0
fi
