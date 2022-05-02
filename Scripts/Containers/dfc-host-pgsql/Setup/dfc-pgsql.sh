#!/bin/bash

# Extra vars
## There should be no '/' at the end 
dfc_project_main_folder="../../../.."

# Header of script
. $dfc_project_main_folder/Scripts/Dependencies/dfc-script-header.sh

# General process
message_info "$(date '+%H:%M:%S (%m/%d/%y)')" 2
message_space 2

docker-compose -p $dfc_global__project_name exec -u root dfc-host-pgsql ash -c "apk add postgresql" >&1
docker-compose -p $dfc_global__project_name exec -u root dfc-host-pgsql ash -c "mkdir /run/postgresql" >&1
docker-compose -p $dfc_global__project_name exec -u root dfc-host-pgsql ash -c "chown postgres:postgres /run/postgresql/" >&1
docker-compose -p $dfc_global__project_name exec -u postgres dfc-host-pgsql ash -c "mkdir /var/lib/postgresql/data" >&1
docker-compose -p $dfc_global__project_name exec -u postgres dfc-host-pgsql ash -c "chmod 0700 /var/lib/postgresql/data" >&1
docker-compose -p $dfc_global__project_name exec -u postgres dfc-host-pgsql ash -c "initdb -D /var/lib/postgresql/data" >&1
docker-compose -p $dfc_global__project_name exec -u root dfc-host-pgsql ash -c "echo \"su postgres -c 'pg_ctl start -D /var/lib/postgresql/data'\" > /etc/local.d/postgres-custom.start" >&1
docker-compose -p $dfc_global__project_name exec -u root dfc-host-pgsql ash -c "chmod +x /etc/local.d/postgres-custom.start" >&1

docker cp $dfc_project_main_folder/Scripts/Containers/dfc-host-pgsql/Setup/Load/Files/postgresql.conf $dfc_global__project_name--dfc-host-pgsql:/tmp >&1

docker-compose -p $dfc_global__project_name exec -u root dfc-host-pgsql ash -c "rm -f /var/lib/postgresql/data/postgresql.conf" >&1
docker-compose -p $dfc_global__project_name exec -u root dfc-host-pgsql ash -c "mv /tmp/postgresql.conf /var/lib/postgresql/data/postgresql.conf" >&1
docker-compose -p $dfc_global__project_name exec -u root dfc-host-pgsql ash -c "chmod 0700 /var/lib/postgresql/data/postgresql.conf" >&1
docker-compose -p $dfc_global__project_name exec -u root dfc-host-pgsql ash -c "chown postgres:postgres /var/lib/postgresql/data/postgresql.conf" >&1

docker cp $dfc_project_main_folder/Scripts/Containers/dfc-host-pgsql/Setup/Load/Files/pg_hba.conf $dfc_global__project_name--dfc-host-pgsql:/tmp >&1

docker-compose -p $dfc_global__project_name exec -u root dfc-host-pgsql ash -c "rm -f /var/lib/postgresql/data/pg_hba.conf" >&1
docker-compose -p $dfc_global__project_name exec -u root dfc-host-pgsql ash -c "mv /tmp/pg_hba.conf /var/lib/postgresql/data/pg_hba.conf" >&1
docker-compose -p $dfc_global__project_name exec -u root dfc-host-pgsql ash -c "chmod 0700 /var/lib/postgresql/data/pg_hba.conf" >&1
docker-compose -p $dfc_global__project_name exec -u root dfc-host-pgsql ash -c "chown postgres:postgres /var/lib/postgresql/data/pg_hba.conf" >&1

(cd $dfc_project_main_folder/Scripts/Containers/dfc-host-pgsql/Services/Enable && sh dfc-local.sh -d1) >&3
(cd $dfc_project_main_folder/Scripts/Containers/dfc-host-pgsql/Services/Start && sh dfc-pgsql.sh -d1) >&3

docker-compose -p $dfc_global__project_name exec -u postgres dfc-host-pgsql ash -c "psql -c \"alter user postgres with password '$dfc_global__project_pgsql_pass';\"" >&1

(cd $dfc_project_main_folder/Scripts/Containers/dfc-host-pgsql/DB && sh dfc-import-db.sh -d1) >&3
(cd $dfc_project_main_folder/Scripts/Containers/dfc-host-pgsql/DB/Cron && sh dfc-clean.sh -d1) >&3
(cd $dfc_project_main_folder/Scripts/Containers/dfc-host-pgsql/DB/Cron/Add && sh dfc-db-export.sh -d1) >&3
(cd $dfc_project_main_folder/Scripts/Containers/dfc-host-pgsql/DB/Cron/Add && sh dfc-dumps-clean.sh -d1) >&3

docker-compose -p $dfc_global__project_name exec -u dfc-user dfc-host-pgsql ash -c "echo 'export SAVEHIST=1000' >> \${ZDOTDIR:-\$HOME}/.zshrc" >&1
docker-compose -p $dfc_global__project_name exec -u dfc-user dfc-host-pgsql ash -c "echo 'alias psql=\"sudo su - postgres -c psql\"' >> \${ZDOTDIR:-\$HOME}/.zshrc" >&1

message_info "В контейнере 'dfc-host-pgsql' установлен пакет 'postgresql' и готов к работе" 1

# End of script
. $dfc_project_main_folder/Scripts/Dependencies/dfc-script-footer.sh
