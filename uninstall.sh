PROC_PATH="/data/adb/modules/proc_ppm"

touch $PROC_PATH/disable
unlink $PROC_PATH/system/bin/root

[ -e "$PROC_PATH/ppm_logs" ] && { 
    rm -rf $PROC_PATH/ppm_logs
}
