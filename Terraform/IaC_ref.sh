#/bin/sh
source ./Lib.sh
    ##########  selected site ################
    SiteSelector "$Site" $project "$LABEL"
    ########### Add EgressIP to the selected nodes
    EgressIPadder $project "$EgressIP" 
    ############ Add NTs to group or create it and assign  permissions #####
    GroupAdministration "$GroupDL" "$project"
unset KUBECONFIG
rm terraform.tfstate
