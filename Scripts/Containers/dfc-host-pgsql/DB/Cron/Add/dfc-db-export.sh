#!/bin/bash

# Extra vars
## There should be no '/' at the end 
export dfc_project_main_folder="../../../../../.."

# Header of script
. $dfc_project_main_folder/Scripts/Dependencies/dfc-script-header.sh

# General process
message_info "$(date '+%H:%M:%S (%d/%m/%Y)')" 2
message_space 2

docker-compose -p $dfc_global__project_name exec -u root dfc-host-pgsql ash -c "echo \"mkdir -p /dfc-project/dumps/exported/scheduled/db_base/*(date '+%Y')/*(date '+%m')/*(date '+%d')\" >> /home/dfc-user/.dumps.sh" >&1
docker-compose -p $dfc_global__project_name exec -u root dfc-host-pgsql ash -c "echo \"su - postgres -c 'pg_dump db_base > /dfc-project/dumps/exported/scheduled/db_base/*(date '+%Y')/*(date '+%m')/*(date '+%d')/*(echo dump--db_name=db_base--time=*(date '+%H_%M_%S--date=%d_%m_%Y').sql)'\" >> /home/dfc-user/.dumps.sh" >&1
docker-compose -p $dfc_global__project_name exec -u dfc-user dfc-host-pgsql ash -c "sed -e 's/*/$/g' /home/dfc-user/.dumps.sh > /home/dfc-user/.dumps.sh.tmp && mv /home/dfc-user/.dumps.sh.tmp /home/dfc-user/.dumps.sh" >&1


message_info "В контейнере 'dfc-host-pgsql' добавлена новая задача автоматического экспорта БД в Cron" 1

# End of script
. $dfc_project_main_folder/Scripts/Dependencies/dfc-script-footer.sh
