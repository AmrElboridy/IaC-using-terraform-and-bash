#/bin/sh
if  [ "$(oc version | grep Kubernetes | wc -l)" -eq "1" ];
then
oc patch netnamespace $project --type=merge -p \
  '{
    "egressIPs": [
      "$EGRESSIP"
    ]
  }'

  oc patch hostsubnet $NODE --type=merge -p \
  '{
    "egressCIDRs": [
      "$EGRESSIP/32",
      $(oc get hostsubnets.network.openshift.io | grep $NODE | cut -d ' ' -f13 | tr -d '[]')
      ]
  }'

else 
    echo "Kindly make sure OC CLI tools are installed"
fi

