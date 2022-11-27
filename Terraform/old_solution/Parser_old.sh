#/bin/sh

function Variable_subst {
	 export $1==$(cat terraform.tfvars | grep $1 | tr -d " " |  cut -d= -f2 | tr -d '"')
}
if [[ -f terraform.tfvars && -f EgressIPAdder_ref.sh && -f EgressIPAdder.sh ]];
then
	Variable_subst EgressIP
	Variable_subst project
	Variable_subst GROUP

   # export EGRESSIP=$(cat terraform.tfvars | grep EgressIP | tr -d " " | tr -d "EgressIP=" | sed -e 's/^"//' -e 's/"$//')
   # export project=$(cat terraform.tfvars | grep project | tr -d " " |  cut -d= -f2 | tr -d '"')
   # export GROUP=$( cat terraform.tfvars | grep GROUP | tr -d " " |  tr -d "GROUP="  | sed -e 's/^[ \t]*//' |  tr -d '"')
    envsubst '${project},${EGRESSIP},${GROUP}' < "EgressIPAdder_ref.sh" > "EgressIPAdder.sh"
    ###########################################################################
    /bin/bash EgressIPAdder.sh
else
    echo "Kindly re-add required files: terraform.tfvars and EgressIPAdder"
fi

