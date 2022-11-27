#/bin/sh
function EgressIPadder {
    ############ Add EgressIP to the selected nodes
    if  [ "$(oc version | grep Kubernetes | wc -l)" -eq "1" ];
    then
    oc patch netnamespace $1 --type=merge -p \
      '{
        "egressIPs": [
          "'$2'"
        ]
      }'
        while IFS="" read -r node || [ -n "$node" ]
        do
            CURRENT=$(oc get hostsubnets.network.openshift.io | grep $node | awk '{print $1}' | tr -d '[]')
            oc patch hostsubnet $node --type=merge -p \
                    '{"egressCIDRs": ["'$2'/32", '$CURRENT'] }'
        done < list.txt
    else
        echo "Kindly make sure OC CLI tools are installed"
    fi 
    }
############ Add NTs to group or create it and assign  permissions #####
function GroupAdministration {
        myArray=$3
        declare -a arr=()

        for usr in ${myArray[@]};
        do
        CHK="$(oc get groups | grep -w "$(echo $usr | tr -d "()" )" | wc -l)"
                if [  $CHK -eq 1  ];
		then export GROUP=$(oc get groups | grep -w "$(echo $usr | tr -d "()" )"  | cut -d" " -f1)
                else :
                fi
        arr+=( $CHK )
        done

        CHK2="$(echo ${arr[0]} + ${arr[1]} + ${arr[2]} | bc)"
	declare -a arr2=()
	arr2=$(echo ${myArray[*]} | tr -d "()")
                if [  "$CHK2" -ge "1"  ];
                then
                    oc adm groups add-users $GROUP ${arr2[@]}
                    oc policy add-role-to-user admin  system:serviceaccount:devops:jenkins -n $1
                    oc adm policy add-role-to-group edit devops -n $1
                    oc adm policy add-role-to-group edit $GROUP -n $1
                else
                    oc adm groups new $2 ${arr2[@]}
                    oc policy add-role-to-user admin  system:serviceaccount:devops:jenkins -n $1
                    oc adm policy add-role-to-group edit devops -n $1
                    oc adm policy add-role-to-group edit $2 -n $1
                fi

}

function SiteSelector {
    if [   "$1" == "HQ(HACluster)"  ];
    then
        export KUBECONFIG=~/.kube/ha-kubeconfig
	terraform plan -var ConfigPath="$KUBECONFIG"
        terraform apply  -var ConfigPath="$KUBECONFIG" -auto-approve
        oc annotate namespace $2 openshift.io/node-selector="env=prod"
    elif [  "$1" == "HQ(Staging)" ];
    then
        export KUBECONFIG=~/.kube/ha-kubeconfig
        terraform plan -var ConfigPath="$KUBECONFIG"
        terraform apply  -var ConfigPath="$KUBECONFIG" -auto-approve
        oc annotate namespace $2 openshift.io/node-selector="env=stg"
    elif [  "$1" == "HQ(MainCluster)" ];
    then
        export KUBECONFIG=~/.kube/main-kubeconfig
        terraform plan -var ConfigPath="$KUBECONFIG"
        terraform apply  -var ConfigPath="$KUBECONFIG" -auto-approve
    elif [  "$1" == "HQ(DevOpsCluster)" ];
    then
        export KUBECONFIG=~/.kube/devops-kubeconfig
        terraform plan -var ConfigPath="$KUBECONFIG"
        terraform apply  -var ConfigPath="$KUBECONFIG" -auto-approve
   elif [  "$1" == "HQ(DRCluster)" ];
    then
        export KUBECONFIG=~/.kube/DR-kubeconfig
        terraform plan -var ConfigPath="$KUBECONFIG"
        terraform apply  -var ConfigPath="$KUBECONFIG" -auto-approve
   else
        export KUBECONFIG=~/.kube/test-kubeconfig
        terraform plan -var ConfigPath="$KUBECONFIG"
        terraform apply  -var ConfigPath="$KUBECONFIG" -auto-approve
   fi

}
