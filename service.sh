PROC_PATH="${0%/*}"
APPROVE="$PROC_PATH/module.prop"
VERIFY="[+] Miscellaneous configurations for optimizing the /proc/ppm/ kernel profile."
INACTIVE_DESC="[-] Module is inactive"

sync # Sync before execution to avoid crashes

# Function to confirm module status and update module description accordingly
s005() {
    if [[ -f "$PROC_PATH/disable" ]]
    then
        sed -i "/description=/c description=${INACTIVE_DESC}" "$APPROVE"
    else
        sed -i "/description=/c description=${VERIFY}" "$APPROVE"
    fi
}

s006() {
    (while :
    do
        sf=$(service list | grep -c "SurfaceFlinger")
        
        if [[ $sf -eq 1 ]]
        then
            service call SurfaceFlinger 1008 i32 1
            break
        else
            sleep 2
        fi
    done
    ) &
}; s006

s007() {
    (while :
    do
        sf=$(service list | grep -c "SurfaceFlinger")
        
        if [[ $sf -eq 1 ]]
        then
            service call SurfaceFlinger 1035 i32 0
            break
        else
            sleep 2
        fi
    done
    ) &
}; s007

s101() {
    # Function to find Mediatek thermal both and other v3
    if [[ -e "/vendor/etc/.tp" ]]
    then
        thermal_manager /vendor/etc/.tp/.ht120.mtc
        resetprop -v -n vendor.thermal.manager.is_ht120 1
    else
        thermal_manager /vendor/etc/.tp/thermal.off.conf
        resetprop -v -n vendor.thermal.manager.is_ht120 0
    fi
}; s101

# s008() {
#     
# }; s008

s009() {
    # after boot v1
    if [[ "$(getprop sys.boot_completed)" == 1 ]] && {
        [[ ! -d "$PROC_PATH/disable" ]]
    }
    then
        sleep 25
        if [[ -f "$PROC_PATH/root" ]]
        then
            sh "${PROC_PATH}/root"
            # Check if root script has been executed successfully
            if [[ $? -eq 0 ]]
            then
                echo "Root script executed successfully"
            else
                echo "Failed to execute root script skipped"
                exit 0
            fi
        fi
    else
        sleep 25
        if [[ -f "$PROC_PATH/root" ]]
        then
            exec "${PROC_PATH}/root"
        fi
    fi
}; s009

s010() {
    # after boot v2
    if [[ -f "$PROC_PATH/root" ]]
    then
        . "${PROC_PATH}/root"
        # Check if root script has been executed successfully
        if [[ $? -eq 0 ]]
        then
            echo "Root script executed successfully"
        else
            echo "Failed to execute root script skipped"
            exit 0
        fi
        
        log_info "Finished!"
    fi
}; s010

s011() {
    # after boot v3
    resetprop -v -n --file "${PROC_PATH}/proc.prop"
}; s011

# Update module description
s005
