#/bin/sh
source ./Lib.sh
############ Check cluster name #####
if   [ "$Site" == "HQ(MainCluster)" ] && [  "$DuplicateCheckBox" == "True"  ];
then
########################## HA Duplicate check box has been selected ##########################
# Main Cluster
 export KUBECONFIG=~/.kube/main-kubeconfig
        terraform plan -var ConfigPath="$KUBECONFIG"
        terraform apply  -var ConfigPath="$KUBECONFIG" -auto-approve 
   ############ Add EgressIP to the selected nodes
    EgressIPadder $project "$EgressIP"
#   ############ Add NTs to group or create it and assign  permissions #####
    GroupAdministration  "$project" "$GroupDL" "$NT"
    unset KUBECONFIG
# HA cluster
 export KUBECONFIG=~/.kube/ha-kubeconfig
        terraform plan -var ConfigPath="$KUBECONFIG"
        terraform apply  -var ConfigPath="$KUBECONFIG" -auto-approve
    ############ Add EgressIP to the selected nodes
    EgressIPadder $project "$EgressIpHA"
#   ########### Add NTs to group or create it and assign  permissions #####
    GroupAdministration  "$project" "$GroupDL" "$NT"
else
    ##########  selected site ################
    SiteSelector "$Site" $project
    ########### Add EgressIP to the selected nodes
    EgressIPadder $project "$EgressIP" 
    ############ Add NTs to group or create it and assign  permissions #####
    GroupAdministration  "$project" "$GroupDL" "$NT"
fi
unset KUBECONFIG
