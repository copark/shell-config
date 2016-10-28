#!/bin/bash
export HOME=/User/copark

export ANDROID_HOME=$HOME/Dev/android-sdks
export ANDROID_NDK=$HOME/Dev/android-ndk-r8d
export NDK_TOOLCHAINS=$ANDROID_NDK/toolchains/arm-linux-androideabi-4.4.3/prebuilt/darwin-x86/bin

export PATH=$PATH:$ANDROID_HOME/tools                             
export PATH=$PATH:$ANDROID_HOME/platform-tools
export PATH=$PATH:$ANDROID_NDK
export PATH=$PATH:$NDK_TOOLCHAINS

## for build aosp
# mount android filesystem - because need case sensitive filesystem
# mount the android file image
# create virtual filesystem
# hdiutil create -type SPARSE -fs 'Case-sensitive Journaled HFS+' -size 40g ~/android.dmg
function mountAndroid { 
    hdiutil attach ~/SSD/Volumes/android.dmg.sparseimage -mountpoint /Volumes/android; 
}

# hdiutil create -type SPARSE -fs 'Case-sensitive Journaled HFS+' -size 100g /Volumes/"Macintosh HD"/WorkSpace/android.dmg
function mountAndroid {
    hdiutil attach ~/SSD/WorkSpace/android.dmg.sparseimage -mountpoint /Volumes/android; 
}

export BUILD_MAC_SDK_EXPERIMENTAL=1

alias GALAXY_SOURCE="/Volumes/android/sources/android-4.2.2_r1"
alias goAndroid='cd /Volumes/android/sources/android_4.4_r1; source build/envsetup.sh'
alias goGalaxyNexus='cd /Volumes/android/sources/android-4.2.2_r1; source build/envsetup.sh;lunch full_maguro-userdebug'
alias goGalaxyNexus421='cd /Volumes/android/sources/android-4.2.1_r1; source build/envsetup.sh;lunch full_maguro-userdebug'
alias buildGalaxyNexus='lunch full_maguro-eng'
alias buildEmulator='lunch full-eng'
alias reboot_bootloader='adb reboot bootloader'
alias flashall='fastboot flashall -w'
alias flash_system='fastboot flash system /Volumes/android/sources/android-4.2.2_r1/out/target/product/maguro/system.img'

# change mount 
alias remount_galaxy3='adb shell mount -o rw,remount -t ext4 /dev/block/mmcblk0p9 /system'
alias remount_galaxyNexus='adb shell mount -o rw,remount -t ext4 /dev/block/platform/omap/omap_hsmmc.0/by-name/system /system'

function run_avd_manager {
    android avd
}
    
# run emulator
function galaxyNexus {
    local AVD
    if [ "$#" -eq 0 ]; then
        AVD=GalaxyNexus
    else
        AVD=$1
    fi
    
    emulator -avd $AVD &
}

## smali , baksmali
function do_smali {
    # doSmali [folder] abc.dex
    java -jar ~/util/smali-1.4.2-dev.jar -o $2 $1 
}

function do_bak_smali {
    # doBakSmali abc.dex [folder]
    java -jar ~/util/baksmali-1.4.2-dev.jar -o $2 $1
}

function create_dex {
    # createDex abc.jar abc.dex
    dx -JXmx1024M --dex --verbose --output=$2 $1
}

function lf {
    ~/util/LogFilter/LogFilter.sh &
}

function apktool {
    java -jar ~/util/apktool.jar
}


function create_lib_project {
    echo "name path package"
    android create lib-project -n $1 -p $2 -t 4 --package $3
}

function android-objdump {
    arm-linux-androideabi-objdump -dR $1 > $1.asm 
}

function android-nm {
    arm-linux-androideabi-nm -Dg $1 > $1.txt
}

function android-update {
    android update project --path .
}

function android-getScreenShot {
    adb pull /sdcard/Pictures/Screenshots
}

function android-screenCap {
    DATE=`date +%Y-%m-%d`
    FILE_NAME=/sdcard/$DATE.png

    adb shell screencap -p $FILE_NAME
    adb pull $FILE_NAME
    adb shell rm $FILE_NAME
    echo "reterive " $FILE_NAME
}

function android-screenRecord {
    DATE=`date +%Y-%m-%d`
    FILE_NAME=/sdcard/$DATE.mp4

    echo "If you want to stop record. Please CTRL + C"

    adb shell screenrecord --verbose $FILE_NAME

    echo "Please wait 3 second..."
    sleep 3
    adb pull $FILE_NAME
    adb shell rm $FILE_NAME
    echo "reterive " $FILE_NAME
}

function clearOcb {
    adb shell pm clear com.skmc.okcashbag.home_google
}

function removeOcb {
    adb uninstall com.skmc.okcashbag.home_google
}

function removeLog {
    rm -rf /Users/skplanet/util/LogFilter/*.txt
}

function initWear {
    adb -d forward tcp:5601 tcp:5601 
}

# make_dex dst.dex src.jar
function make_dex {
    dx --dex --output=$2 $1
}

function dex_method_id_by_jar {
    TEMP=temp.dex
    dx --dex --output $TEMP $1
    cat $TEMP | head -c 92 | tail -c 4 | hexdump -e '1/4 "%d\n"'
    rm $TEMP
}

function dex_method_id {
    cat $1 | head -c 92 | tail -c 4 | hexdump -e '1/4 "%d\n"'
}

function adb_package_list {
    adb shell 'pm list packages -f' | sed -e 's/.*=//' | sort
}

function android_tags {
    # Gets the list of unique tags in a project for logcat filterspecs
    grep Log\. -r --include "*.java" | awk -F\" '{print $2}' | sort -u | xargs
}
