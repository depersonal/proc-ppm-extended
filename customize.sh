$BOOTMODE || abort "! Flash from Recovery is not supported"

if [ -e "$MODPATH/uninstall.sh" ]; then
    . $MODPATH/uninstall.sh; else
    abort "  Some file are missing?"
fi

if [ -d "/proc/ppm" ]; then
    ui_print "  /proc/ppm directory found"
    echo
    echo "$(cat /proc/ppm/enabled)"
    echo "$(cat /proc/ppm/policy_status)"
    echo "[$(cat /proc/ppm/profile/profile_on)] PROFILE_ON: disabled"
    echo "[3] CPUFREQ_POWER_MODE: $(cat /proc/cpufreq/cpufreq_power_mode)"
    echo "[$(cat /sys/module/ged/parameters/is_GED_KPI_enabled)] IS_GED_KPI_ENABLED: enabled"
    echo [0] THERMAL_ZONE_MODE: $(cat /sys/devices/virtual/thermal/thermal_zone*/mode)
    echo
    echo "$(cat /proc/driver/thermal/tztsAll_enable)"
    echo; else
    abort "! /proc/ppm directory not found"
fi

if [ -f "/data/adb/modules/proc_ppm/disable" ]; then
    ui_print "  proc_ppm/Proc ppm <- Detected as having been turned off, safe, no conflict"
    touch /data/adb/modules_update/procmods_rvsd/update
    $MODPATH/procmods; else
    ui_print "  Turn off the module that is causing the conflict -> proc_ppm/Proc ppm"
    touch /data/adb/modules/proc_ppm/disable
    $MODPATH/procmods
fi

setting_permission_recursive() {
    set_perm_recursive $MODPATH 0 0 0755 644
    set_perm $MODPATH/procmods root root 755
};

if [ -n "/data/adb/modules_update/procmods_rvsd/procmods" ]; then
    setting_permission_recursive
    ui_print "  𝖯𝗋𝗈𝖼𝗆𝗈𝖽𝗌 | 𝖣𝗂𝗌𝖺𝖻𝗅𝖾 /𝗉𝗋𝗈𝖼/𝗉𝗉𝗆 𝗆𝗈𝖽𝗌"; else
    setting_permission_recursive
    ui_print "  𝖯𝗋𝗈𝖼𝗆𝗈𝖽𝗌 | 𝖣𝗂𝗌𝖺𝖻𝗅𝖾 /𝗉𝗋𝗈𝖼/𝗉𝗉𝗆 𝗆𝗈𝖽𝗌"
fi

if [ -d "/proc/ppm" ]; then
    if [ -f "$MODPATH/changelog.md" ]; then
        echo
        echo "$(cat $MODPATH/changelog.md)"; else
        abort "  Some file are missing?"
    fi
fi
