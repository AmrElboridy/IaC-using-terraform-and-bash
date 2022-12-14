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
            CURRENT=$(oc get hostsubnets.network.openshift.io | grep $node | awk '{print $6}' | tr -d '[]')
            oc patch hostsubnet $node --type=merge -p \
                    '{"egressCIDRs": ["'$2'/32", '$CURRENT'] }'
        done < list.txt
    else
        echo "Kindly make sure OC CLI tools are installed"
    fi 
    }
############ Add NTs to group or create it and assign  permissions #####
function GroupAdministration {
       GROUPDL="$1"
        CHK="$(oc get groups | grep "$GROUPDL"| wc -l)"

                if [  "$CHK" -eq 1  ];
                then
                    oc policy add-role-to-user admin  system:serviceaccount:devops:jenkins -n $2
                    oc adm policy add-role-to-group edit devops -n $2
                    oc adm policy add-role-to-group edit "$GROUPDL" -n $2
                else
                    oc policy add-role-to-user admin  system:serviceaccount:devops:jenkins -n $2
                    oc adm policy add-role-to-group edit devops -n $2
                    echo "Please Contact Your System Administrator, This user has no Group"
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
