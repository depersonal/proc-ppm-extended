#!/system/bin/sh

PROC_PATH="${0%/*}"
APPROVE="$PROC_PATH/module.prop"
ACTIVE_STATUS="[+] Module is active"
INACTIVE_STATUS="[-] Module is inactive"

# Function to confirm module status and update module description accordingly
s005() {
    if [[ -e "$PROC_PATH/disable" ]]; then
        sed -i "/description=/c description=${INACTIVE_STATUS}" "$APPROVE"
    else
        sed -i "/description=/c description=${ACTIVE_STATUS}" "$APPROVE"
    fi
}; s005

# Function to execute root script if present before boot (version 1)
s006() {
    if [[ -f "$PROC_PATH/root" ]]; then
        sh "${PROC_PATH}/root"
        # Check if root script has been executed successfully
        if [[ $? -eq 0 ]]; then
            echo "Root script executed successfully"
        else
            echo "Failed to execute root script"
            exit 1
        fi
    else
        exec "${PROC_PATH}/root"
    fi
}; s006

# Function to execute root script and apply boot options (version 2)
s007() {
    if [[ -f "$PROC_PATH/root" ]]; then
        . "${PROC_PATH}/root"
        log_init
        log_info "Starting proc_ppm"
        boot_opt_apply
    fi
}; s007

# Function to set prop directly (version 3)
s008() {
    resetprop -v -n --file "${PROC_PATH}/proc.prop"
}; s008

sync # Sync before execution to avoid crashes
