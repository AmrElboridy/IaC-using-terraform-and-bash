#/bin/sh
if  [ "$(oc version | grep Kubernetes | wc -l)" -eq "1" ];
then
oc patch netnamespace idptest --type=merge -p \
  '{
    "egressIPs": [
      "192.168.1.161"
    ]
  }'
    while IFS="" read -r node || [ -n "$node" ]
    do
        CURRENT=$(oc get hostsubnets.network.openshift.io | grep $node | cut -d ' ' -f13 | tr -d '[]')
	oc patch hostsubnet $node --type=merge -p \
		'{"egressCIDRs": ["192.168.1.161/32", '$CURRENT'] }'
    done < list.txt
    
else
    echo "Kindly make sure OC CLI tools are installed"
fi

############ Edit permissions assigned to group ##### 
if [  "$(oc get groups | grep idp | wc -l)" -eq 1  ];
then
	oc policy add-role-to-user admin  system:serviceaccount:devops:jenkins -n idptest
        oc adm policy add-role-to-group edit devops -n idptest
	oc adm policy add-role-to-group edit idp -n idptest
else

    	echo "Kindly make sure group name is exist"
fi

