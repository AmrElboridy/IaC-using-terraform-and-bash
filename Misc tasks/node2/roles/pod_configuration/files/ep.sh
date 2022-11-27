#!/bin/bash
apt-get update -y
apt-get install -y sshpass
while true;
do
CHK=$( grep "down;" /etc/nginx/nginx.conf | wc -l )
CHK2=$( sshpass -f password.txt  ssh -o UserKnownHostsFile=/dev/null -o StrictHostKeyChecking=no -p 22 root@vodafone-pgsql-2 "podman exec vodafone-pgsql-2 repmgr -f /opt/bitnami/repmgr/conf/repmgr.conf node check | grep 'node is primary' | wc -l")
        if [[ $CHK == 1 ]] && [[ $CHK2 == 3 ]]; 
        then
                echo "This node was stanby and will be master "
                cp -f up/nginx.conf /etc/nginx/nginx.conf
                nginx -s reload
        elif [[ $CHK == 0 ]] && [[ $CHK2 == 3 ]]; 
        then
                echo "This node was primary and still primary"
        elif [[ $CHK == 1 ]] && [[ $CHK2 == 0 ]];
        then
                echo "This node was stanby and still stanby"
        else
                echo "This node was stanby and still stanby"
                cp -f down/nginx.conf /etc/nginx/nginx.conf
                nginx -s reload
        fi
sleep 10;
done 
