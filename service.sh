PROC_PATH="${0%/*}"
APPROVE="$PROC_PATH/module.prop"
VERIFY="[+] Misc configuration for /proc/ppm/ kernel profile."

five() {
#alter
    if [[ "$(getprop sys.boot_completed)" == 1 ]] && {
        [[ ! -d "$PROC_PATH/disable" ]]
    }
    
    then
        sleep 25
        
        [ -e "$PROC_PATH/root" ] && {
            sh "$PROC_PATH/root"
        }
    else
        root
    fi
}; five

thirteenth() {
    . "${PROC_PATH}/root"
    log_info "Finished!"
}; thirteenth

seven() {
    resetprop -v -n --file "$PROC_PATH/proc.prop"
}; seven

sed -i "/description=/c description=${VERIFY}" $APPROVE
