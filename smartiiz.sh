#!/usr/bin/env bash


#Maintenair brice.daupiard@smartiiz.com
CURRENTFOLDER=$1;
ACTION=$2;
P2=$3;
P3=$4;

cd $1;

clear_docker(){
    echo "clearing";
    if [ "$P2" == "all" ]; then
        echo "kill and remove  nginx proxy pass";
        docker kill smartiiz-nginx;
        docker rm smartiiz-nginx;
        echo "nginx Removed";
        echo "kill and remove Apache2 and Php";
        docker kill smartiiz-apache-php;
        docker rm smartiiz-apache-php;
        echo "Apache 2 and Php Removed";
        echo "kill and remove  Mysql";
        docker kill smartiiz-mysql-5.6;
        docker rm smartiiz-mysql-5.6;
        echo "Mysql Removed";
        echo "kill and remove  phpsmartiiz-phpmyadmin";
        docker kill smartiiz-phpmyadmin;
        docker rm smartiiz-phpmyadmin;
        echo "phpsmartiiz-phpmyadmin Removed";
        echo "Il y a actuelement $(docker ps -q | wc -l) container up";
    fi;

}

start_docker(){
    if [ "$P2" == "apache" ]; then
        echo "Restart Apache2 and Php";
        docker start smartiiz-apache-php
        echo "Apache 2 and Php Restarted";
    fi;
    
    if [ "$P2" == "mysql" ]; then
        echo "Restart Mysql";
        docker start smartiiz-mysql-5.6
        echo "Mysql Restarted";
    fi;
    
    if [ "$P2" == "phpsmartiiz-phpmyadmin" ]; then
        echo "Restart phpsmartiiz-phpmyadmin";
        docker start smartiiz-phpmyadmin
        echo "phpsmartiiz-phpmyadmin Restarted";
    fi;
    
    if [ "$P2" == "nginx" ]; then
        echo "Restart nginx proxy";
        docker start smartiiz-nginx
        echo "phpsmartiiz-phpmyadmin nginx proxy";
    fi;
    
    if [ "$P2" == "all" ]; then
        echo "Restart Apache2 and Php";
        docker start smartiiz-apache-php
        echo "Apache 2 and Php Restarted";
        echo "Restart Mysql";
        docker start smartiiz-mysql-5.6
        echo "Mysql Restarted";
        echo "Restart phpsmartiiz-phpmyadmin";
        docker start smartiiz-phpmyadmin
        echo "phpsmartiiz-phpmyadmin Restarted";
    fi;

}

restart_docker(){
    if [ "$P2" == "apache" ]; then
        echo "Restart Apache2 and Php";
        docker restart smartiiz-apache-php
        echo "Apache 2 and Php Restarted";
    fi;
    
    if [ "$P2" == "mysql" ]; then
        echo "Restart Mysql";
        docker restart smartiiz-mysql-5.6
        echo "Mysql Restarted";
    fi;
    
    if [ "$P2" == "phpsmartiiz-phpmyadmin" ]; then
        echo "Restart phpsmartiiz-phpmyadmin";
        docker restart smartiiz-phpmyadmin
        echo "phpsmartiiz-phpmyadmin Restarted";
    fi;
    
    if [ "$P2" == "nginx" ]; then
        echo "Restart nginx proxy";
        docker restart smartiiz-nginx
        echo "phpsmartiiz-phpmyadmin nginx proxy";
    fi;
    
    if [ "$P2" == "all" ]; then
        echo "Restart Apache2 and Php";
        docker restart smartiiz-apache-php
        echo "Apache 2 and Php Restarted";
        echo "Restart Mysql";
        docker restart smartiiz-mysql-5.6
        echo "Mysql Restarted";
        echo "Restart phpsmartiiz-phpmyadmin";
        docker restart smartiiz-phpmyadmin
        echo "phpsmartiiz-phpmyadmin Restarted";
    fi;
}

stop_docker(){
    if [ "$P2" == "apache" ]; then
        echo "Restart Apache2 and Php";
        docker stop smartiiz-apache-php
        echo "Apache 2 and Php Restarted";
    fi;
    
    if [ "$P2" == "mysql" ]; then
        echo "Restart Mysql";
        docker stop smartiiz-mysql-5.6
        echo "Mysql Restarted";
    fi;
    
    if [ "$P2" == "phpsmartiiz-phpmyadmin" ]; then
        echo "Restart phpsmartiiz-phpmyadmin";
        docker stop smartiiz-phpmyadmin
        echo "phpsmartiiz-phpmyadmin Restarted";
    fi;
    
    if [ "$P2" == "nginx" ]; then
        echo "Restart nginx proxy";
        docker stop smartiiz-nginx
        echo "phpsmartiiz-phpmyadmin nginx proxy";
    fi;
    
    if [ "$P2" == "all" ]; then
        echo "Restart Apache2 and Php";
        docker stop smartiiz-apache-php
        echo "Apache 2 and Php Restarted";
        echo "Restart Mysql";
        docker stop smartiiz-mysql-5.6
        echo "Mysql Restarted";
        echo "Restart phpsmartiiz-phpmyadmin";
        docker stop smartiiz-phpmyadmin
        echo "phpsmartiiz-phpmyadmin Restarted";
    fi;
}

setHosts(){
    export SMARTIIZ_PHPMYADMIN=$(docker inspect -f '{{range .NetworkSettings.Networks}}{{.IPAddress}}{{end}}' smartiiz-phpmyadmin);
    export SMARTIIZ_APACHEPHP=$(docker inspect -f '{{range .NetworkSettings.Networks}}{{.IPAddress}}{{end}}' smartiiz-apache-php);
    export SMARTIIZ_NGINX=$(docker inspect -f '{{range .NetworkSettings.Networks}}{{.IPAddress}}{{end}}' smartiiz-nginx);
    export SMARTIIZ_MYSQL=$(docker inspect -f '{{range .NetworkSettings.Networks}}{{.IPAddress}}{{end}}' smartiiz-mysql-5.6);
    docker exec -u 0 smartiiz-apache-php /bin/sh -c "echo \"$SMARTIIZ_MYSQL smartiiz-mysql\" >> /etc/hosts";
    docker exec -u 0 smartiiz-apache-php /bin/sh -c "echo \"$SMARTIIZ_PHPMYADMIN smartiiz-phpmyadmin\" >> /etc/hosts";
    docker exec -u 0 smartiiz-apache-php /bin/sh -c "echo \"$SMARTIIZ_NGINX smartiiz-nginx\" >> /etc/hosts";
    docker exec -u 0 smartiiz-nginx /bin/sh -c "echo \"$SMARTIIZ_APACHEPHP  smartiiz-apache\" >> /etc/hosts";
    docker exec -u 0 smartiiz-nginx /bin/sh -c "echo \"$SMARTIIZ_PHPMYADMIN smartiiz-phpmyadmin\" >> /etc/hosts";
    docker exec -u 0 smartiiz-phpmyadmin /bin/sh -c "echo \"$SMARTIIZ_MYSQL smartiiz-mysql\" >> /etc/hosts";
    docker exec -u 0 smartiiz-apache-php /bin/sh -c "service apache2 restart";
    docker exec -u 0 smartiiz-nginx /bin/sh -c "service nginx restart";
}

InstallApachePHP(){

    echo "START BUILDING CUSTOM SMARTIIZ IMAGE";
    cd apache2;
    
    if [ "$P3" == "update" ]; then
        docker image rm smartiiz/apache2-php-cli;
        docker image rm smartiiz/nginx;
    fi;
    
    echo "CREATING APACHE2 AND PHP 7.0 FPM IMAGE";
    docker build -t smartiiz/apache2-php-cli .
    
    cd ../nginxForProxy
    
    echo "CREATING NginxForProxy IMAGE";
    docker build -t smartiiz/nginx .
    
    echo "SET UP DEV ENV and creating required Mount Folder";
    export DEV_WORK_DIRECTORY=$P2;
    
    cd $P2;
    
    echo  "Create log Path";
    mkdir logs;
    
    echo  "Project directory";
    mkdir;
    
    echo  "Docker accessible configuration for apache and Nginx";
    mkdir conf;
    
    mkdir conf/apache2
    
    mkdir conf/nginx;
    
    echo  "Mysql configuration directory";
    mkdir mysql;
    
    echo "LAUNCH CONTAINER";
    docker run  -d -tt -p 8082:80    --name smartiiz-apache-php  --restart=always  -v $P2/../conf/apache2/sites-enabled:/etc/apache2/sites-enabled -v $P2:/var/www  -v $P2/../logs/apache2:/var/log/apache2/ smartiiz/apache2-php-cli 
    docker run  -d -tt -p 8083:3306  --name smartiiz-mysql-5.6   --restart=always  -v $P2/../mysql:/var/lib/mysql -e MYSQL_ROOT_PASSWORD=smartiiz mysql:5.6
    docker run  -d -tt -p 8080:80    --name smartiiz-phpmyadmin  --restart=always  -e PMA_HOST=$(docker inspect -f '{{range .NetworkSettings.Networks}}{{.IPAddress}}{{end}}' smartiiz-mysql-5.6) phpmyadmin/phpmyadmin
    docker run  -d -tt -p 80:80      --name smartiiz-nginx       --restart=always  -v $P2/../conf/nginx:/etc/nginx/sites-enabled -v $P2/../logs/nginx:/var/log/nginx/ smartiiz/nginx
    
    cd "$CURRENTFOLDER";
    pwd
    cp -R "$CURRENTFOLDER/template/hello-smartiiz"          "$P2/../." ;
    cp    "$CURRENTFOLDER/template/nginx/default.conf"      "$P2/../conf/nginx/." ;
    echo "APACHE PROXY PASS : $(docker inspect -f '{{range .NetworkSettings.Networks}}{{.IPAddress}}{{end}}' smartiiz-apache-php)";
    cp -R "$CURRENTFOLDER/template/apache/default.conf"     "$P2/../conf/apache2/sites-enabled/smartiiz.conf" ;
#sudo -- sh -c -e  "echo \"127.0.0.1 smartiiz.lab phpsmartiiz-phpmyadmin.smartiiz.lab www.smartiiz.lab\"" >> /etc/hosts;
    docker ps -a;
}



if [ "$ACTION" == "Install" ]; then
    InstallApachePHP
    setHosts
    docker exec -it smartiiz-apache-php /bin/bash;
elif [ "$ACTION" == "start" ]; then
    start_docker
    setHosts
    docker exec -it smartiiz-apache-php /bin/bash;
elif [ "$ACTION" == "restart" ]; then
    restart_docker
    setHosts
    docker exec -it smartiiz-apache-php /bin/bash;
elif [ "$ACTION" == "stop" ]; then
    stop_docker
elif [ "$ACTION" == "clear" ]; then
    echo "EUH ?";
    clear_docker
else
    echo "Nothing to do";
fi;
