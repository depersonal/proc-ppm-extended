PROC_PATH="$MODPATH" || PROC_PATH="$MODDIR"
SCRIPT_NAME="root"
MODPROC="$PROC_PATH/$SCRIPT_NAME"

touch /data/adb/modules/proc_ppm/update

# Function to find Mediatek thermal both and other v1
s100() {
    if [[ -e "/vendor/etc/.tp" ]]
    then
        ui_print "- Found thermal detected"
        mkdir -p "$PROC_PATH/system/vendor/etc/.tp"
        find "/vendor/etc/.tp" -type f -exec ln -s {} "$PROC_PATH/system/vendor/etc/.tp/" \;
    fi
}; s100

# Function to create executable permissions
s000() {
    ui_print "- Setting executable permissions"
    set_perm_recursive "$MODPROC" root root 0777 0755
}; s000

# Function to manage log files
s001() {
    # Check for old version logs
    if [[ -f "/data/adb/modules/proc_ppm/ppm_logs" ]]
    then
        ui_print "Old version logs detected"
        sh -x "${PROC_PATH}/uninstall.sh"
    else
        ui_print "Creating a new version of logs"
        echo "" > "$PROC_PATH/ppm_logs"
    fi
    
    # Remove log files if found
    if [[ -e "$PROC_PATH/error.log" ]]
    then
        rm -f "$PROC_PATH/error.log"
    fi
    
    if [[ -e "$PROC_PATH/info.log" ]]
    then
        rm -f "$PROC_PATH/info.log"
    fi
    
    if [[ -e "$MODPROC/ppm_logs" ]]
    then
        rm -f "$MODPROC/ppm_logs"
    fi
}; s001

# Function to execute proc_ppm if root file exists
s002() {
    if [[ -f "$PROC_PATH/root" ]]
    then
        chmod 755 "$MODPROC"
        sh -x "${MODPROC}"
        ui_print "proc_ppm executed"
    fi
}; s002

# Function to set prop directly
s003() {
    ui_print "  Prop directly (path=$PROC_PATH/proc.prop type=direct_executed vis=PRIVATE)"
    resetprop -v -n --file "${PROC_PATH}/proc.prop"
}; s003

# Function to create symlinks
s004() {
    ui_print "- Creating symlinks"
    mkdir -p "$PROC_PATH/system/bin"
    ln -s "$MODPROC" "$PROC_PATH/system/bin"
}; s004

# Function to enable debug logging (not used)
# enable_debug() {
#     DEBUG=true
#     ui_print "Debug mode enabled"
# }; enable_debug

sync # Sync before execution to avoid crashes
