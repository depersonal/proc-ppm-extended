PROC_PATH="${0%/*}"
APPROVE="$PROC_PATH/module.prop"
VERIFY="[+] Miscellaneous configurations for optimizing the /proc/ppm/ kernel profile."
INACTIVE_DESC="[-] Module is inactive"

# Function to confirm module status and update module description accordingly
s005() {
    if [[ -e "$PROC_PATH/disable" ]]; then
        sed -i "/description=/c description=${INACTIVE_DESC}" "$APPROVE"
    else
        sed -i "/description=/c description=${VERIFY}" "$APPROVE"
    fi
}; s005

s006() {
    (while :
    do
        sf=$(service list | grep -c "SurfaceFlinger")
    
        if [ $sf -eq 1 ]
        then
            service call SurfaceFlinger 1008 i32 1
            break
        else
            sleep 2
        fi
    done
    ) &
}; s006

# s007() {
#     
# }; s007

# s008() {
#     
# }; s008

s009() {
    # after boot v1
    if [[ "$(getprop sys.boot_completed)" == 1 ]] && [[ ! -d "$PROC_PATH/disable" ]]; then
        sleep 25
        if [[ -f "$PROC_PATH/root" ]]; then
            sh "${PROC_PATH}/root"
            # Check if root script has been executed successfully
            if [[ $? -eq 0 ]]; then
                echo "Root script executed successfully"
            else
                echo "Failed to execute root script"
                exit 1
            fi
        fi
    else
        sleep 25
        if [[ -f "$PROC_PATH/root" ]]; then
            exec "${PROC_PATH}/root"
        fi
    fi
}; s009

s010() {
    # after boot v2
    if [[ -f "$PROC_PATH/root" ]]; then
        . "${PROC_PATH}/root"
        log_info "Finished!"
    fi
}; s010

s011() {
    # after boot v3
    resetprop -v -n --file "${PROC_PATH}/proc.prop"
}; s011

# Update module description
s005
