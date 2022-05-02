#!/bin/bash

# Extra vars
## There should be no '/' at the end
dfc_project_main_folder="../../../../.."

# Header of script
. $dfc_project_main_folder/Scripts/Dependencies/dfc-script-header.sh

# General process
message_info "$(date '+%H:%M:%S (%m/%d/%y%)')" 2
message_space 2

docker-compose -p $dfc_global__project_name exec --detach -u postgres dfc-host-pgsql ash -c "pg_ctl start -D /var/lib/postgresql/data" >&1

message_info "В контейнере 'dfc-host-pgsql' сервис 'postgresql' запущен" 1

# End of script
. $dfc_project_main_folder/Scripts/Dependencies/dfc-script-footer.sh
