#/bin/sh
source ./Lib.sh
    SiteSelector "$Site" $project
    ########### Add EgressIP to the selected nodes
    EgressIPadder $project "$EgressIP" 
    ############ Add NTs to group or create it and assign  permissions #####
    GroupAdministration  "$GroupDL"  "$project" 
fi
unset KUBECONFIG
