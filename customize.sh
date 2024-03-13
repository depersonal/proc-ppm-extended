PROC_PATH="$MODPATH"
SCRIPT_NAME="root"
MODPROC="$PROC_PATH/$SCRIPT_NAME"

# Function to create executable permissions
s000() {
    ui_print "- Setting executable permissions"
    set_perm_recursive "$MODPROC" root root 0777 0755
}; s000

# Function to manage log files
s001() {
    # Check for old version logs
    if [[ -e "/data/adb/modules/proc_ppm/ppm_logs" ]]; then
        ui_print "Old version logs detected"
        sh -x "${MODPATH}/uninstall.sh"
    else
        ui_print "Creating a new version of logs"
        echo "" > "$MODPATH/ppm_logs"
    fi
    
    # Remove log files if found
    if [[ -e "$PROC_PATH/error.log" ]]; then
        rm -f "$PROC_PATH/error.log"
    fi

    if [[ -e "$PROC_PATH/info.log" ]]; then
        rm -f "$PROC_PATH/info.log"
    fi
    
    if [[ -e "$MODPROC/ppm_logs" ]]; then
        rm -f "$MODPROC/ppm_logs"
    fi
}; s001

# Function to execute proc_ppm if root file exists
s002() {
    if [[ -f "$MODPATH/root" ]]; then
        chmod 755 "$MODPROC"
        sh -x "${MODPROC}"
        ui_print "proc_ppm executed"
    fi
}; s002

# Function to set prop directly
s003() {
    ui_print "Prop directly (path=$MODPATH/proc.prop type=direct_executed vis=PRIVATE)"
    resetprop -v -n --file "${PROC_PATH}/proc.prop"
}; s003

# Function to create symlinks
s004() {
    ui_print "- Creating symlinks"
    mkdir -p "$MODPATH/system/bin"
    ln -s "$MODPROC" "$MODPATH/system/bin"
}; s004

# Function to enable debug logging (not used)
# enable_debug() {
#     DEBUG=true
#     ui_print "Debug mode enabled"
# }; enable_debug

sync # Sync before execution to avoid crashes
