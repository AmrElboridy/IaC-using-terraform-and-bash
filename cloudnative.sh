#!/bin/bash 
Type=("24041")
request=("HQ-Main-Cluster")
department=("Citrix" "Tibco" "Ansible" "LifeRay" "Billing" "Elasticsearch" "patching" "SCOM" "Vodafoners" "POS" "eshop" "Fraud" "Siebel" "SharePoint" "Exchange" "IVR" "VoiceBot" "Big-Data" "DHCP" "IAM" "Netperform" "ANA-Vodafone" "Recording" "Remedy" "OEM" "SAP" "Service-navigator" "Risk" "Provisioning" "DSS" "SCCM" "PAM" "Jupiter" "Evo" "ArcSight" "Logstash" "Solarwinds" "Symantec" "dyntarce" "DLP" "Networker" "E2E" "MNP" "Jira" "TeamSite" "OneDrive" "VF-cash" "Active-Directory" "Spotfire" "OCR" "openshift" "Jenkins" "ODS" "Promo" "Gdrive" "LEA" "BI" "Queuing" "DNS" "Lync" "Digital")
privateToken=5VXPyn3YqeAQhjJ8kb3G
urlgroup="https://10.230.189.153/api/v4/groups/"
urlproject="https://10.230.189.153/api/v4/projects/"

    type_group_id="82607"

for r in "${request[@]}"
    do
        curl -k --request POST --header "PRIVATE-TOKEN: $privateToken" \
        --header "Content-Type: application/json" \
        --data "{"path": """$r""", "name": """$r""", "parent_id":"""$type_group_id""" }" \
        --url "$urlgroup" > structure.out
        request_group_id="`cat structure.out | sed "s@^[^0-9]*\([0-9]\+\).*@\1@"`"
        echo "$request_group_id"

for l in "${department[@]}"
            do
                 curl -k --request POST --header "PRIVATE-TOKEN: $privateToken" \
                --header "Content-Type: application/json" \
                --data "{"path": """$l""", "name": """$l""", "parent_id":"""$request_group_id"""  }" \
                --url "$urlgroup" > structure.out
                department_group_id="`cat structure.out | sed "s@^[^0-9]*\([0-9]\+\).*@\1@"`"
                echo "$department_group_id"
            done
          done


