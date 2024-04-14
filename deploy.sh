#!/bin/bash

run() {
  APP="${1}"
  if docker ps -a --format '{{.Names}}' | grep -q "${APP}"; then
    docker stop ${APP}
    docker rm ${APP}
    docker stop app_db
    docker rm app_db
  fi
 docker build -t ${APP} .
 docker run -p 80:80 -idt --name ${APP} ${APP}

 docker run -idt -p 3306:3306 --name app_db -e MYSQL_ROOT_PASSWORD=root -e MYSQL_DATABASE=app -e MYSQL_ALLOW_EMPTY_PASSWORD=false -v /var/lib/mysql/app_db:/var/lib/mysql --restart unless-stopped mysql:8.0
}

run "app"