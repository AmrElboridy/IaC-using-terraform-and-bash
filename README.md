# open_shift_project



Welcome to the IaC-using-terraform-and-bash wiki! This project aims to create infrastructure " Openshift projects with some specific parameters like resourceQuota and EgressIP" using terraform. As per the current limitation to do so using terraform provider for k8s, part of the code was written using shell script to complete the required scope.

A role which allow Servic account  .. to give another service account admin cluster role

oc create clusterrole permissionsrole --verb=* --resource=roles,rolebindings,clusterroles,clusterrolebindings
oc adm policy add-cluster-role-to-user permissionsrole -z oc-sa


