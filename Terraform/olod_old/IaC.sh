#/bin/sh
source ./Lib.sh
############ Check cluster name #####
if   [ "HQ(MainCluster)" == "HQ(MainCluster)" ] && [  "True" == "True"  ];
then
########################## HA Duplicate check box has been selected ##########################
# Main Cluster
 export KUBECONFIG=~/.kube/main-kubeconfig
        terraform plan -var ConfigPath="$KUBECONFIG"
        terraform apply  -var ConfigPath="$KUBECONFIG" -auto-approve 
   ############ Add EgressIP to the selected nodes
    #EgressIPadder idptest ""
#   ############ Add NTs to group or create it and assign  permissions #####
    GroupAdministration  "idptest" "Group3" "("Thon" "wael" "Hend")"
    unset KUBECONFIG
# HA cluster
 export KUBECONFIG=~/.kube/ha-kubeconfig
        terraform plan -var ConfigPath="$KUBECONFIG"
        terraform apply  -var ConfigPath="$KUBECONFIG" -auto-approve
    ############ Add EgressIP to the selected nodes
   # EgressIPadder idptest ""
#   ########### Add NTs to group or create it and assign  permissions #####
    GroupAdministration  "idptest" "Group3" "("Thon" "wael" "Hend")"
else
    ##########  selected site ################
    SiteSelector "HQ(MainCluster)" idptest
    ########### Add EgressIP to the selected nodes
   # EgressIPadder idptest "" 
    ############ Add NTs to group or create it and assign  permissions #####
    GroupAdministration  "idptest" "Group3" "("Thon" "wael" "Hend")"
fi
unset KUBECONFIG
