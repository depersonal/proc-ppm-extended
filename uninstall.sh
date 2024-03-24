# Hardcoded paths
PROC_PATH="/data/adb/modules_update/proc_ppm"
MODPROC="/data/adb/modules/proc_ppm"
ROOT_FILE="/root/bootloop_indicator"

# Path to the directory where the symlink is located
SYMLINK_PATH="$MODPROC/system/vendor/etc/.tp"

# Unlinked thermal Mediatek both and other
if [[ -e "$MODPROC/system/vendor/etc/.tp" ]]
then
    unlink "$MODPROC/system/vendor/etc/.tp"
    # Check if thermal file has been unlinked successfully
    if [[ $? -eq 0 ]]
    then
        echo "Thermal file unlinked successfully"
    else
        echo "Failed to unlink thermal file skipped"
        exit 1
    fi
fi

# Check if the symlink exists
if [[ -L "$SYMLINK_PATH" ]]
then
    # Unlink the symlink
    unlink "$SYMLINK_PATH"
    
    # Check if unlinking was successful
    if [[ $? -eq 0 ]]
    then
        echo "Thermal symlink unlinked successfully"
    else
        echo "Failed to unlink thermal symlink skipped"
        exit 1
    fi
else
    echo "Thermal symlink does not exist, nothing to unlink"
fi

# Touch after execution to avoid bootloop
if [[ -e "$MODPROC/update" ]]
then
    unlink "$MODPROC/system/bin/root"
    # Check if root file has been unlinked successfully
    if [[ $? -eq 0 ]]
    then
        echo "Root file unlinked successfully"
    else
        echo "Failed to unlink root file skipped"
        exit 1
    fi
elif [[ -e "$ROOT_FILE" ]]
then
    touch "$MODPROC/disable"
    # Check if disable file has been touched successfully
    if [[ $? -eq 0 ]]
    then
        echo "Disable file touched successfully"
    else
        echo "Failed to touch disable file skipped"
        exit 1
    fi
fi

# Remove log files if found
if [[ -f "$PROC_PATH/error.log" ]]
then
    rm -f "$PROC_PATH/error.log"
    # Check if error log file has been removed successfully
    if [[ $? -eq 0 ]]
    then
        echo "Error log file removed successfully"
    else
        echo "Failed to remove error log file skipped"
        exit 1
    fi
fi

if [[ -f "$PROC_PATH/info.log" ]]
then
    rm -f "$PROC_PATH/info.log"
    # Check if info log file has been removed successfully
    if [[ $? -eq 0 ]]
    then
        echo "Info log file removed successfully"
    else
        echo "Failed to remove info log file skipped"
        exit 1
    fi
fi

if [[ -f "$MODPROC/ppm_logs" ]]
then
    rm -f "$MODPROC/ppm_logs"
    # Check if ppm logs file has been removed successfully
    if [[ $? -eq 0 ]]
    then
        echo "PPM logs file removed successfully"
    else
        echo "Failed to remove PPM logs file skipped"
        exit 1
    fi
fi

sync # Synchronize before execution to prevent failures
