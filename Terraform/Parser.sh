#/bin/sh

function Variable_subst {
	 export $1=$(cat terraform.tfvars | grep $1 | tr -d " " |  cut -d= -f2 | tr -d '="')
}

if [[ -f terraform.tfvars && -f IaC_ref.sh && -f IaC.sh ]];
then
	Variable_subst EgressIP
	Variable_subst project
	Variable_subst Site
	
	export GroupDL=$(cat terraform.tfvars | grep GroupDL | cut -d= -f2-50 |  tr -d '"' )
	export LABEL=$(cat terraform.tfvars | grep LABEL | cut -d= -f2,3 | tr -d '"' |  sed 's/^ *//g')

    envsubst '${LABEL},${project},${EgressIP},${Site},${NT},${GroupDL}' < "IaC_ref.sh" > "IaC.sh"
    ##########################
    ## Shell script to execute custom infrastructe as code
    #######################
    /bin/bash IaC.sh
else
    echo "Kindly re-add required files: terraform.tfvars and IaC files"
fi

