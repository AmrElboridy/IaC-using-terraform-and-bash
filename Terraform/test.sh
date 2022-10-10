#!/bin/bash 
## Exit codes:
#		0: Normal termination
#		1: existing Group
#		2: New Group using the first NT name 
export project="test"
myArray=("ab" "ff" "ww")
declare -a arr=()
for usr in ${myArray[@]}; 
do
CHK="$(oc get groups | grep $usr | wc -l)"
        if [  $CHK -eq 1  ];
        then export GROUP=$(oc get groups | grep -w "$usr"  | cut -d" " -f1)
        else :
        fi
arr+=( $CHK )
done
CHK2="$(echo ${arr[0]} + ${arr[1]} + ${arr[2]} | bc)"
        if [  $CHK2 -ge 1  ];
        then
            oc adm groups add-users $GROUP ${myArray[*]}
            oc policy add-role-to-user admin  system:serviceaccount:devops:jenkins -n $project
            oc adm policy add-role-to-group edit devops -n $project
            oc adm policy add-role-to-group edit $GROUP -n $project
            exit 1
        else
            oc adm groups new "${myArray[0]}" ${myArray[*]}
            oc policy add-role-to-user admin  system:serviceaccount:devops:jenkins -n $project
            oc adm policy add-role-to-group edit devops -n $project
            oc adm policy add-role-to-group edit "${myArray[0]}" -n $project
            exit 2
        fi