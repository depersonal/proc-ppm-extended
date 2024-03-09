PROC_PATH="$MODPATH"
SCRIPT_PATH="root"
MODPROC="$PROC_PATH/$SCRIPT_PATH"

DEBUG=false

INFO_LOG="${PROC_PATH}/info.log"
ERROR_LOG="${PROC_PATH}/error.log"

# DEBUG_LOG=${PROC_PATH}/debug.log

log_init() {
    :> "$INFO_LOG"
    :> "$ERROR_LOG"
    # :> "$DEBUG_LOG" 
}

_log_tweaks() {
    local log="$1"
    shift
    while (( "$#" )); do
        local message="$1"
        echo "[$(date "+%H:%M:%S")] $message" >> "$log"
        shift
    done
}

log_info() {
    _log_tweaks "$INFO_LOG" "$@"
}

log_error() {
    _log_tweaks "$ERROR_LOG" "$@"
}

# log_debug() {
#     _log_tweaks "$DEBUG_LOG" "$@"
# }

write() {
    local file="$1"
    local value="$2"
    
    [ -f "$file" ] || {
        log_error "Error: File $file does not exist."
        return 1
    }
    
    chmod +w "$file" 2>/dev/null
    
    echo "$value" >"$file" 2>/dev/null || {
        log_error "Error: Failed to write to $file."
        return 1
    }
    return 0
}

bootopt_apply() {
    log_info "Device: $(getprop ro.product.system.model)" \
        "Brand: $(getprop ro.product.system.brand)" \
        "Kernel: $(uname -r)" \
        "Rom build type: $(getprop ro.system.build.type)" \
        "Android Version: $(getprop ro.system.build.version.release)" \
        "Applying boot optimization"
    sync # Sync before execute to avoid crashes
    
    log_info "Done."
}

zero() {
    ui_print "- Setting executable permissions"
    set_perm_recursive "$MODPROC" root root 0777 0755
}; zero

sixth() {
    if [[ -e "/data/adb/modules/proc_ppm/ppm_logs" ]]
    then
        ui_print "old version logs detected"
        
        sh -x "${PROC_PATH}/uninstall.sh"
    else
        ui_print "create a new version logs"
        
        echo "" > $PROC_PATH/ppm_logs
    fi
}; sixth

one() {
#direct
    if [[ -f "$PROC_PATH/root" ]]
    then
        chmod 755 "$PROC_PATH/root"
        
        log_init
        log_info "Starting proc_ppm"
        sh -x "${PROC_PATH}/root"
        
        bootopt_apply
        log_info "Finished!"
        ui_print "proc_ppm executed:"
    fi
}; one

fourteenth() {
#direct prop
    ui_print "  Prop directly(path=$PROC_PATH/proc.prop type=direct_executed vis=PRIVATE)"
    
    resetprop -v -n --file "${PROC_PATH}/proc.prop"
}; fourteenth

eleventh() {
    ui_print "- Creating symlinks"
    
    mkdir -p $PROC_PATH/system/bin
    
    ln -s $PROC_PATH/root $PROC_PATH/system/bin
}; eleventh
