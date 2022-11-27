https://clusterlabs.github.io/PAF/Quick_Start-CentOS-7.html
#############################
sudo yum module enable -y container-tools:rhel8
sudo yum module install -y container-tools:rhel8
#############################
#for each node

podman run -d  --name N1_postgres  -p 5432:5432 -e POSTGRES_PASSWORD=mypassword   -v postgress:/var/lib/postgresql/data   postgres:12
######################################
podman run -d  --name N2_postgres  -p 5432:5432 -e POSTGRES_PASSWORD=mypassword   -v postgress:/var/lib/postgresql/data   postgres:12
######################################
podman run -d  --name N3_postgres  -p 5432:5432 -e POSTGRES_PASSWORD=mypassword   -v postgress:/var/lib/postgresql/data   postgres:12

---------------------------------------
## systemd - container
# selinux
setsebool -P container_manage_cgroup on
### create dir @ /etc/systemd/system/
vim /etc/systemd/system/N1_pgsql_C.service
vim /etc/systemd/system/N2_pgsql_C.service
vim /etc/systemd/system/N3_pgsql_C.service
############################ Node 1 ###########################################
##CONTENT
[Unit]
Description=postgres container

[Service]
Restart=always
ExecStart=/usr/bin/podman start -a N1_postgres
ExecStop=/usr/bin/podman stop -t 2 N1_postgres

[Install]
WantedBy=local.target
###########################################################################
############################ Node 2 ###########################################
[Unit]
Description=postgres container

[Service]
Restart=always
ExecStart=/usr/bin/podman start -a N2_postgres
ExecStop=/usr/bin/podman stop -t 2 N2_postgres

[Install]
WantedBy=local.target
###########################################################################
############################ Node 3 ###########################################
[Unit]
Description=postgres container

[Service]
Restart=always
ExecStart=/usr/bin/podman start -a N3_postgres
ExecStop=/usr/bin/podman stop -t 2 N3_postgres

[Install]
WantedBy=local.target
###########################################################################
#############################
systemctl enable N3_pgsql_C.service
systemctl start N3_pgsql_C.service
systemctl status N3_pgsql_C.service
##########################################################
## Entering Docker containers
podman exec -it N1_postgres bash
podman exec -it N2_postgres bash
podman exec -it N3_postgres bash

##########################################################
#/usr/pgsql-14/bin/postgresql-14-setup initdb
################# install vim ##############################
apt-get update
apt-get install vim
##### edit postgresql.conf
#vim /var/lib/postgresql/data/postgresql.conf
~postgres/12/data/postgresql.conf
cat <<EOF >> /var/lib/postgresql/data/postgresql.conf
listen_addresses = '*'
wal_keep_segments = 32
hba_file = '/var/lib/postgresql/data/pg_hba.conf '
include = '../standby.conf'
EOF
##########################################################

cat <<EOF > /var/lib/postgresql/standby.conf
primary_conninfo = 'host=192.168.122.40 application_name=$(hostname -s)'
EOF