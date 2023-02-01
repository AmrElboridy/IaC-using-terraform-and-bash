#/bin/sh
source ./Lib.sh
    ##########  selected site ################
    SiteSelector "testing" idptno-afterrole "APP=WORK"
    ########### Add EgressIP to the selected nodes
    EgressIPadder idptno-afterrole "192.1.1.1" 
    ############ Add NTs to group or create it and assign  permissions #####
    GroupAdministration "CN=Tech-Infrastructure Architecture-Design & Planning,OU=DL,DC=internal,DC=eg,DC=vodafone,DC=com" "idptno-afterrole"
unset KUBECONFIG
rm terraform.tfstate
