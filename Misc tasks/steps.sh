############## /etc/hosts
cp hosts /etc/hosts
#############################
yum update -y 
#yum install epel-release -y
#yum install podman -y
sudo yum module enable -y container-tools:rhel8
sudo yum module install -y container-tools:rhel8
##################################################
#podman network create my-network --driver bridge
##################################################
podman run --detach --name vodafone-pgsql-1 -p 5433:5432 \
  --env REPMGR_PARTNER_NODES=vodafone-pgsql-1,vodafone-pgsql-2,vodafone-pgsql-3:5433 \
  --env REPMGR_NODE_NAME=vodafone-pgsql-1 \
  --env REPMGR_NODE_NETWORK_NAME=vodafone-pgsql-1 \
  --env REPMGR_PRIMARY_HOST=vodafone-pgsql-1 \
  --env REPMGR_PRIMARY_PORT=5433 \
  --env REPMGR_PORT_NUMBER=5433 \
  --env REPMGR_PASSWORD=repmgrpass \
  --env POSTGRESQL_PASSWORD=secretpass \
  -v postgres:/var/lib/postgresql/data  \
  docker.io/bitnami/postgresql-repmgr
  ########################################
  podman run --detach --name vodafone-pgsql-2 -p 5433:5432 \
  --env REPMGR_PARTNER_NODES=vodafone-pgsql-1,vodafone-pgsql-2,vodafone-pgsql-3:5433 \
  --env REPMGR_NODE_NAME=vodafone-pgsql-2 \
  --env REPMGR_NODE_NETWORK_NAME=vodafone-pgsql-2 \
  --env REPMGR_PRIMARY_HOST=vodafone-pgsql-1 \
  --env REPMGR_PRIMARY_PORT=5433 \
  --env REPMGR_PORT_NUMBER=5433 \
  --env REPMGR_PASSWORD=repmgrpass \
  --env POSTGRESQL_PASSWORD=secretpass \
  -v postgres2:/var/lib/postgresql/data \
  docker.io/bitnami/postgresql-repmgr:latest
  ########################################
  podman run --detach --name vodafone-pgsql-3 -p 5433:5432 \
  --env REPMGR_PARTNER_NODES=vodafone-pgsql-1,vodafone-pgsql-2,vodafone-pgsql-3:5433 \
  --env REPMGR_NODE_NAME=vodafone-pgsql-3 \
  --env REPMGR_NODE_NETWORK_NAME=vodafone-pgsql-3 \
  --env REPMGR_PRIMARY_HOST=vodafone-pgsql-1 \
  --env REPMGR_PRIMARY_PORT=5433 \
  --env REPMGR_PORT_NUMBER=5433 \
  --env REPMGR_PASSWORD=repmgrpass \
  --env POSTGRESQL_PASSWORD=secretpass \
  -v postgres3:/var/lib/postgresql/data \
  docker.io/bitnami/postgresql-repmgr:latest
  ################################################
  ###################################################
  ## nginx 
  ###################################################
#cp (docker file and script) to the destinations 3 VMs
################################
podman build -t vodafone-pg-proxy-1  .
podman build -t vodafone-pg-proxy-2  .
podman build -t vodafone-pg-proxy-3  .
###################################
### run the container image 
  podman run --name vodafone-proxy-1 -p 5432:5432 \
  -v nginx:/etc/nginx/nginx \
  -d localhost/vodafone-pg-proxy-1
  ###################################
  podman run --name vodafone-proxy-2 -p 5432:5432 \
  -v nginx:/etc/nginx/nginx \
  -d localhost/vodafone-pg-proxy-2
  ###################################
  podman run --name vodafone-proxy-3 -p 5432:5432 \
  -v nginx:/etc/nginx/nginx \
  -d localhost/vodafone-pg-proxy-3
###################################
### create service accoutn for both containers 
cp N_sd.service /etc/systemd/system/
cp Psql_sd.service /etc/systemd/system/
systemctl enable N_sd.service
systemctl start N_sd.service
systemctl status N_sd.service
systemctl enable Psql_sd.service
systemctl start Psql_sd.service
systemctl status Psql_sd.service
##############################################
ansible-playbook sampleplaybook.yml -i ansible_hosts
#############################
podman save -o ~/prim_proxy.tar localhost/vodafone-pg-proxy-1:1
podman load -i prim_proxy.tar

podman stop $(podman ps -a -q)
podman rm $(podman ps -a -q) -f
podman rm -f --all


sudo podman exec vodafone-pgsql-2 repmgr -f /opt/bitnami/repmgr/conf/repmgr.conf node check |  grep 'node is primary' |  wc -l")
