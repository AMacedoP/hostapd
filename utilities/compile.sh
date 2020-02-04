#!/bin/sh

remote() {
    tar zcf hostapdtesis.tar.gz -C "/mnt/d/Users/dti/Desktop/JJ/hostapd_JJ" ./../
    scp hostapdtesis.tar.gz labtel@192.168.35.183:~/ina/sdk/dl/
    ssh -t labtel@192.168.35.183 "cd ~/ina/sdk && make cleanhost && make -j1 V=sc"
    rm -f /home/zorr/packages/*
    scp labtel@192.168.35.183:~/ina/sdk/bin/ar71xx/packages/base/hostapd* /home/zorr/packages
    scp /home/zorr/packages/* root@192.168.1.2:~/ipk
    ssh -t root@192.168.1.2 "opkg remove hostapd && opkg install ~/ipk/*"
}

estamaquina() {
    tar zcf hostapdtesis.tar.gz -C "/mnt/d/Users/dti/Desktop/JJ/hostapd_JJ" ./../
    cp hostapdtesis.tar.gz /home/zorr/sdk/dl/
    cd /home/zorr/sdk && make cleanhost && make -j1 V=sc
    if [ $? -ne 0 ]; then
        echo "La compilación falló"
        exit 1
    fi
    rm -f /home/zorr/packages/*
    cp /home/zorr/sdk/bin/ar71xx/packages/base/hostapd* /home/zorr/packages
    scp /home/zorr/packages/* root@192.168.1.2:~/ipk
    ssh -t root@192.168.1.2 "opkg remove hostapd && opkg install ~/ipk/*"
}

if [ $# -eq 0 ]; then
    echo "Uso ./compile [local/remoto]"
    exit 1
fi

HOST=$1
if [ $HOST = "local" ]; then
    echo "Corriendo host local"
    estamaquina
else
    echo "Corriendo host remoto"
    remote
fi
