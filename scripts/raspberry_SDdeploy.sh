#!/bin/bash
################################################
IPADDRESS_RASP="192.168.10.101"
HOSTNAME_RASP="pi-master"
WLAN_SSID_RASP="hat"
WLAN_PASSWORD_RASP="EspiritoS@#150920"
MICROSD_DEVICE='/dev/sdd'
IMAGE=0 #Options: 0=lite | 1=default (Desktop + default applications) | 2=full 
PATH_IMAGE[0]='/home/disco2/dados/programas/Raspberry/2021-10-30-raspios-bullseye-armhf-lite.img'
PATH_IMAGE[1]='/home/disco2/dados/programas/Raspberry/2021-03-04-raspios-buster-armhf.img'
PATH_IMAGE[2]='/home/disco2/dados/programas/Raspberry/2021-03-04-raspios-buster-armhf-full.img'
################################################

doublecheck() {
    while true; do
        echo
        echo "CRITICALS VARIABLES CONFIRMATION:"
        echo
        echo "IP ADRESS: $IPADDRESS_RASP"
        echo "HOSTNAME: $HOSTNAME_RASP"
        echo "WLAN SSID:  $WLAN_SSID_RASP"
        echo "WLAN PASSWORD: $WLAN_PASSWORD_RASP"
        echo "MICRO SD DEVICE ADDRES: $MICROSD_rasp"
        echo
        read -r -p "IS THE ABOVE INFORMATION CORRECT? (y/n): " yn

        case $yn in
            [Yy]* ) return 0; break;;
            [Nn]* ) echo "Script aborted!"; echo "Please edit the script and fix the information"; echo; exit;;
            * ) echo "Please answer yes or no.";;
        esac
    done
}

checkdevice() {

    DEVICE_INUSE=( $(blkid | cut -d: -f1) )

    for temp in "${DEVICE_INUSE[@]}"; do
        [[ "$temp" == "$MICROSD_DEVICE" ]] && return 1
    done
    return 0    
}    

recordimage () {
    dd bs=4M if=${PATH_IMAGE[$IMAGE]} of=$MICROSD_DEVICE
}    

prepare () {
mount /dev/sdc1 /mnt
touch /mnt/ssh
umount /dev/sdc1
mount /dev/sdc2 /mnt
cp /mnt/etc/wpa_supplicant/wpa_supplicant.conf /mnt/etc/wpa_supplicant/wpa_supplicant.conf.default
cp wpa_supplicant.conf /mnt/etc/wpa_supplicant
LINE=$(cat -n /mnt/etc/wpa_supplicant/wpa_supplicant.conf | grep ssid="" | tr -s '[:space:]' ' ' | cut -d' ' -f 2)
sed -i.bkp $LINE'c\ssid="'$WLAN_SSID_RASP'"' /mnt/etc/wpa_supplicant/wpa_supplicant.conf
LINE=$(cat -n /mnt/etc/wpa_supplicant/wpa_supplicant.conf | grep psk="" | tr -s '[:space:]' ' ' | cut -d' ' -f 2)
sed -i.bkp $LINE'c\psk="'$WLAN_PASSWORD_RASP'"' /mnt/etc/wpa_supplicant/wpa_supplicant.conf
}

#doublecheck
#return_doublecheck=$?
#checkdevice
#return_checkdevice=$?
#recordimage
prepare


#if [ $return_doublecheck -eq 0 ] && [ $return_checkdevice -eq 0 ]; then
#    recordimage
#
#elif [ $return_doublecheck -eq 0 ] && [ $return_checkdevice -eq 1 ]; then
#    echo "Fatal Error, the chosen device is already in use!"
#else
#    echo "Something is worng!"
#fi



#listar os blkid e ver se encontra se nao encontrar para por ai 
#blkid | grep /dev/sdc | cut -d" " -f2
#se encontrar pegar o UUID e ve se ele esta dentro do fstab
#usar o grep para pesquisar se o conteudo esta em /etc/fstab

