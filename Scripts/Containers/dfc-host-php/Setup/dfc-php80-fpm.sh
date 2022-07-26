#!/bin/bash

# Extra vars
## There should be no '/' at the end 
dfc_project_main_folder="../../../.."

# Header of script
. $dfc_project_main_folder/Scripts/Dependencies/dfc-script-header.sh

# General process
message_info "$(date '+%H:%M:%S (%m/%d/%y)')" 2
message_space 2

(cd $dfc_project_main_folder/Scripts/Containers/dfc-host-php/Services/Disable && sh dfc-php-fpm.sh -d1) >&3

docker-compose -p $dfc_global__project_name exec -u root dfc-host-php ash -c "mkdir /var/log/php8" >&1
docker-compose -p $dfc_global__project_name exec -u root dfc-host-php ash -c "apk del php7-fpm" >&1
docker-compose -p $dfc_global__project_name exec -u root dfc-host-php ash -c "apk del php81-fpm" >&1
docker-compose -p $dfc_global__project_name exec -u root dfc-host-php ash -c "apk add php8-fpm" >&1
docker-compose -p $dfc_global__project_name exec -u root dfc-host-php ash -c "cd /etc/php8/php-fpm.d && sed -i \"s~listen = 127.0.0.1:9000~listen = dfc-host-php:9000~g\" \$(grep \"listen = 127.0.0.1:9000\" -rl .)" >&1
docker-compose -p $dfc_global__project_name exec -u root dfc-host-php ash -c "cd /etc/php8/php-fpm.d && sed -i \"s~user = nobody~user = dfc-user~g\" \$(grep \"user = nobody\" -rl .)" >&1
docker-compose -p $dfc_global__project_name exec -u root dfc-host-php ash -c "cd /etc/php8/php-fpm.d && sed -i \"s~group = nobody~group = dfc-user~g\" \$(grep \"group = nobody\" -rl .)" >&1

(cd $dfc_project_main_folder/Scripts/Containers/dfc-host-php/Services/Enable && sh dfc-php-fpm.sh -d1) >&3

message_info "В контейнере 'dfc-host-php' установлен пакет 'php80-fpm' и готов к работе" 1

# End of script
. $dfc_project_main_folder/Scripts/Dependencies/dfc-script-footer.sh
