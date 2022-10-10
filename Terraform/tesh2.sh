#!/bin/bash 
myArray=("mona" "amr" "hassan")
declare -a arr=()

for usr in ${myArray[@]}; 
do
CHK="$(oc get groups | grep $usr | wc -l)"
        if [  $CHK -eq 1  ];
        then GROUP=$(oc get groups | grep -w "${myArray[usr+1]}"  | cut -d" " -f1)
        else :
        fi
  arr+=( $CHK )
done
# check array content
declare -p arr
CHK2="$(echo ${arr[0]} + ${arr[1]} + ${arr[2]} | bc)"
echo $CHK2
echo $GROUP
#if [[ (${arr[0]} || ${arr[2]}  || ${arr[2]}) -eq 1 ]]; 
#then
 #       echo "hello"
  #      else
   #     :