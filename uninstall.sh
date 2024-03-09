PROC_PATH="${0%/*}"
MODPROC="/data/adb/modules/proc_ppm"

touch $MODPROC/disable

if [ -e "$MODPROC/system/bin/root" ]
then
    unlink $MODPROC/system/bin/root
fi

if [ -n "$PROC_PATH/*.log" ] && [ -n "$MODPROC/*_logs" ]
then
    rm -rf $PROC_PATH/*.log \
        $MODPROC/*_logs
fi
