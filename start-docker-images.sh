#!/bin/bash

if [ $# -eq 1 ] && [ $1 == "remove" ]; then
    docker stop nginxproxy && docker rm nginxproxy
    docker stop mariadb && docker rm mariadb
    docker stop homeshaft && docker rm homeshaft
    docker stop znc && docker rm znc
    docker stop disc-wiki && docker rm disc-wiki
fi;


docker run -d --name "nginxproxy" -p 80:80 -v /var/run/docker.sock:/tmp/docker.sock:ro jwilder/nginx-proxy
docker run --name "mariadb" -v $HOME/dbvolume:/var/lib/mysql -e MYSQL_ROOT_PASSWORD=$MYSQL_ROOT_PASSWORD -d mariadb:latest
docker run --name "homeshaft" --link mariadb:mysqlhost -e VIRTUAL_HOST=homeshaft.confusedherring.com -e 'GIT_REPO=https://github.com/davidh87/homeshaft.git' -d richarvey/nginx-php-fpm
docker run -d --name "znc" -p 6699:6699 -v $HOME/.znc:/znc-data jimeh/znc

#docker run -d --name "disc-wiki" -v $HOME/disc-wiki.conf:/etc/nginx/nginx.conf:ro -e VIRTUAL_HOST=disc-wiki-new.confusedherring.com nginx
docker run -d -p 8080:80  --name "disc-wiki" -v $HOME/disc-wiki-proxy.conf:/etc/nginx/conf.d/default.conf:ro -e VIRTUAL_HOST=disc-wiki-new.confusedherring.com nginx
