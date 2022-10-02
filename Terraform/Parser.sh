#/bin/sh

function Variable_subst {
	 export $1=$(cat terraform.tfvars | grep $1 | tr -d " " |  cut -d= -f2 | tr -d '="')
}

if [[ -f terraform.tfvars && -f EgressIPAdder_ref.sh && -f EgressIPAdder.sh ]];
then
	Variable_subst EgressIP
	Variable_subst project
	Variable_subst GROUP

    envsubst '${project},${EgressIP},${GROUP}' < "EgressIPAdder_ref.sh" > "EgressIPAdder.sh"
    ##########################
    ## Shell script to execute custom infrastructe as code
    #######################
    /bin/bash EgressIPAdder.sh
else
    echo "Kindly re-add required files: terraform.tfvars and EgressIPAdder"
fi

