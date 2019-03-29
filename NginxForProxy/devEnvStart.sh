#!/usr/bin/env bash

docker run -d -tt -p 8080:80    --name apache2-dev --restart=always  -v $DEV_WORK_DIRECTORY/Conf/apache2/sites-enabled:/etc/apache2/sites-enabled -v $DEV_WORK_DIRECTORY/projects:/var/www  smartiiz/apache2 
docker run -d -tt -p 8083:3306  --name mysql-dev   --restart=always  -v $DEV_WORK_DIRECTORY/mysql:/var/lib/mysql -e MYSQL_ROOT_PASSWORD=smartiiz mysql
docker run --rm  -d -p 8080:80  --name myadmin     --restart=always -e PMA_ARBITRARY=1  phpmyadmin/phpmyadmin
docker run -d -tt -p 80:80      --name nginx-dev   --restart=always  -v $DEV_WORK_DIRECTORY/Conf/nginx:/etc/nginx/sites-enabled smartiiz/nginx
