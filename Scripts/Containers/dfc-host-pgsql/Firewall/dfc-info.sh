#!/bin/bash

# Extra vars
## There should be no '/' at the end
dfc_project_main_folder="../../../.."

# Header of script
. $dfc_project_main_folder/Scripts/Dependencies/dfc-script-header.sh

# General process
message_info "$(date '+%H:%M:%S (%m/%d/%y)')" 2
message_space 2

message_info "В контейнере 'dfc-host-pgsql' информация из брандмауэра:" 1
docker-compose -p $dfc_global__project_name exec --privileged -u root dfc-host-pgsql ash -c "echo ''" >&3
docker-compose -p $dfc_global__project_name exec --privileged -u root dfc-host-pgsql ash -c "iptables -nvL" >&3
docker-compose -p $dfc_global__project_name exec --privileged -u root dfc-host-pgsql ash -c "echo ''" >&3

# End of script
. $dfc_project_main_folder/Scripts/Dependencies/dfc-script-footer.sh
