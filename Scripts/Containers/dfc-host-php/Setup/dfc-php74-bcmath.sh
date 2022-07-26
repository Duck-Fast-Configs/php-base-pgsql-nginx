#!/bin/bash

# Extra vars
## There should be no '/' at the end 
dfc_project_main_folder="../../../.."

# Header of script
. $dfc_project_main_folder/Scripts/Dependencies/dfc-script-header.sh

# General process
message_info "$(date '+%H:%M:%S (%m/%d/%y)')" 2
message_space 2

docker-compose -p $dfc_global__project_name exec -u root dfc-host-php ash -c "apk add php7-bcmath --repository=https://dl-cdn.alpinelinux.org/alpine/v3.15/community" >&1

message_info "В контейнере 'dfc-host-php' установлен пакет 'php74-bcmath' и готов к работе" 1

# End of script
. $dfc_project_main_folder/Scripts/Dependencies/dfc-script-footer.sh
