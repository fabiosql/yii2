#!/bin/bash

run() {
  APP="${1}"
  if docker ps -a --format '{{.Names}}' | grep -q "${APP}"; then
    docker stop ${APP}
    docker rm ${APP}
  fi
 docker build -t ${APP} .
 docker run -p 80:80 -idt --name ${APP} ${APP}
}

run "app"