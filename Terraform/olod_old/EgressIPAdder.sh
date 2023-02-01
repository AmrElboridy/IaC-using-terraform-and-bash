#/bin/sh
## Exit codes:
#		0: Normal termination
#		1: existing Group
#		2: New Group using the first NT name 
############ Check cluster name ##### 
if [   "HQ(HACluster)" == "HQ(HACluster)"  ];
then
    oc annotate namespace idptest openshift.io/node-selector="env=prod" 
elif [  "HQ(HACluster)" == "HQ(Staging)" ]; 
then
    oc annotate namespace idptest openshift.io/node-selector="env=stg" 
else
    :  #Do nothing
fi

############ Add EgressIP to the selected nodes
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

############ Add NTs to group or create it and assign  permissions ##### 
myArray=("TahoonHa" "Ranaa" "Henady")
declare -a arr=()
for usr in ${myArray[@]};
do
CHK="$(oc get groups | grep $usr | wc -l)"
        if [  $CHK -eq 1  ];
        then export GROUP=$(oc get groups | grep -w "$usr"  | cut -d" " -f1)
        else :
        fi
arr+=( $CHK )
done
CHK2="$(echo ${arr[0]} + ${arr[1]} + ${arr[2]} | bc)"
        if [  $CHK2 -ge 1  ];
        then
            oc adm groups add-users $GROUP ${myArray[*]}
            oc policy add-role-to-user admin  system:serviceaccount:devops:jenkins -n idptest
            oc adm policy add-role-to-group edit devops -n idptest
            oc adm policy add-role-to-group edit $GROUP -n idptest
           # exit 1
        else
            oc adm groups new Group2 ${myArray[*]}
            oc policy add-role-to-user admin  system:serviceaccount:devops:jenkins -n idptest
            oc adm policy add-role-to-group edit devops -n idptest
            oc adm policy add-role-to-group edit "${myArray[0]}" -n idptest
           # exit 2
        fi
