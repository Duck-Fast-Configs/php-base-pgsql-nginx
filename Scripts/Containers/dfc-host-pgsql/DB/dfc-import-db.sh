#!/bin/bash

# Extra vars
## There should be no '/' at the end 
export dfc_project_main_folder="../../../.."

# Header of script
. $dfc_project_main_folder/Scripts/Dependencies/dfc-script-header.sh

# General process
message_info "$(date '+%H:%M:%S (%d/%m/%Y)')" 2
message_space 2

file_sql="$(echo dump--db_name=db_base--time=$(date '+%H_%M_%S--date=%d_%m_%Y').sql)"
message_info "Экспортированный файл БД db_base будет в ./WorkFolder/Containers/dfc-host-pgsql/Dumps/Scheduled/${file_sql}" 2
docker-compose -p $dfc_global__project_name exec -u postgres dfc-host-pgsql ash -c "pg_dump db_base > /dfc-project/dumps/exported/unscheduled/${file_sql}" >&1
docker-compose -p $dfc_global__project_name exec -u postgres dfc-host-pgsql ash -c "psql -c 'drop database db_base;'" >&1
docker-compose -p $dfc_global__project_name exec -u postgres dfc-host-pgsql ash -c "psql -c 'create database db_base;'" >&1
docker-compose -p $dfc_global__project_name exec -u postgres dfc-host-pgsql ash -c "psql db_base < /dfc-project/dumps/imported/db_base.sql" >&1
message_info "Произошел импорт из файла ./WorkFolder/Containers/dfc-host-pgsql/Dumps/Imported/db_base.sql в базу данных db_base" 2

message_info "В контейнере 'dfc-host-pgsql' база данных была импортирована" 1

# End of script
. $dfc_project_main_folder/Scripts/Dependencies/dfc-script-footer.sh
