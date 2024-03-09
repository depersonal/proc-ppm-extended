#!/system/bin/sh

PROC_PATH="${0%/*}"
APPROVE="$PROC_PATH/module.prop"
VERIFY="[-] Misc configuration for /proc/ppm/ kernel profile."

# DEBUG_LOG="${PROC_PATH}/debug.log"

two() {
    if [[ -e "$PROC_PATH/disable" ]]
    then
        sed -i "/description=/c description=${VERIFY}" $APPROVE
    fi
}; two

three() {
#beginning
    if [[ -n "$PROC_PATH/root" ]]
    then
        sh "${PROC_PATH}/root"
    else
        exec "${PROC_PATH}/root"
    fi
}; three

twelfth() {
    . "${PROC_PATH}/root"
    
    log_init
    log_info "Starting proc_ppm"
    
    bootopt_apply
}; twelfth

six() {
    resetprop -v -n --file "${PROC_PATH}/proc.prop"
}; six
