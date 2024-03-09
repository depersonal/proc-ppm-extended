fSCRIPT_PARENT_PATH="$MODPATH"
SCRIPT_NAME="root"
SCRIPT_PATH="$SCRIPT_PARENT_PATH/$SCRIPT_NAME"

DEBUG=false

zero() {
    ui_print "- Setting executable permissions"
    set_perm_recursive "$SCRIPT_PATH" root root 0777 0755
}; zero

sixth() {
    if [[ -e "/data/adb/modules/proc_ppm/ppm_logs" ]]
    then
        ui_print "old version logs detected"
        
        sh -x "$MODPATH/uninstall.sh"
    else
        ui_print "create a new version logs"
        
        echo "" > $MODPATH/ppm_logs
    fi
}; sixth

one() {
#direct
    if [[ -f "$MODPATH/root" ]]
    then
        chmod 755 "$MODPATH/root"
        
        sh -x "$MODPATH/root"
        
        ui_print "proc_ppm executed:"
    fi
}; one

fourteenth() {
#direct prop
    ui_print "  Prop directly(path=$MODPATH/proc.prop type=direct_executed vis=PRIVATE)"
    
    resetprop -v -n --file "$PROC_PATH/proc.prop"
}; fourteenth

eleventh() {
    ui_print "- Creating symlinks"
    
    mkdir -p $MODPATH/system/bin
    ln -s $MODPATH/root $MODPATH/system/bin
}; eleventh
