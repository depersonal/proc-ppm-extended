# Hardcoded paths
PROC_PATH="/data/adb/modules_update/proc_ppm"
MODPROC="/data/adb/modules/proc_ppm"
ROOT_FILE="/root/bootloop_indicator"

# Touch after execution to avoid bootloop
if [ -e "$MODPROC/update" ]; then
    unlink "$MODPROC/system/bin/root"
    # Check if root file has been unlinked successfully
    if [ $? -eq 0 ]; then
        echo "Root file unlinked successfully"
    else
        echo "Failed to unlink root file"
        exit 1
    fi
elif [ -e "$ROOT_FILE" ]; then
    touch "$MODPROC/disable"
    # Check if disable file has been touched successfully
    if [ $? -eq 0 ]; then
        echo "Disable file touched successfully"
    else
        echo "Failed to touch disable file"
        exit 1
    fi
fi

# Remove log files if found
if [ -f "$PROC_PATH/error.log" ]; then
    rm -f "$PROC_PATH/error.log"
    # Check if error log file has been removed successfully
    if [ $? -eq 0 ]; then
        echo "Error log file removed successfully"
    else
        echo "Failed to remove error log file"
        exit 1
    fi
fi

if [ -f "$PROC_PATH/info.log" ]; then
    rm -f "$PROC_PATH/info.log"
    # Check if info log file has been removed successfully
    if [ $? -eq 0 ]; then
        echo "Info log file removed successfully"
    else
        echo "Failed to remove info log file"
        exit 1
    fi
fi

if [ -f "$MODPROC/ppm_logs" ]; then
    rm -f "$MODPROC/ppm_logs"
    # Check if ppm logs file has been removed successfully
    if [ $? -eq 0 ]; then
        echo "PPM logs file removed successfully"
    else
        echo "Failed to remove PPM logs file"
        exit 1
    fi
fi

sync # Synchronize before execution to prevent failures
