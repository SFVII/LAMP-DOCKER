#!/usr/bin/env bash


#Maintenair brice.daupiard@smartiiz.com

ACTION = $1;
FOCUS  = $2;
DEV_WORK_DIRECTORY = $3

InstallApachePHP(){
    echo "START BUILDING CUSTOM SMARTIIZ IMAGE";
    cd apache2;
    echo "CREATING APACHE2 AND PHP 7.0 FPM IMAGE";
    docker build -t smartiiz/apache2-php-cli
    cd ../nginxForProxy
    echo "CREATING NginxForProxy IMAGE";
    docker build -t smartiiz/nginx
    
    echo "SET UP DEV ENV and creating required Mount Folder";
    
    cd $DEV_WORK_DIRECTORY;
    
    echo "Create log Path";
    mkdir logs;
    echo "Project directory";
    mkdir projects;
    echo "Docker accessible configuration for apache and Nginx";
    mkdir Conf;
    mkdir Conf/apache2
    mkdir Conf/nginx;
    echo "Mysql configuration directory";
    mkdir mysql;
    
    echo "LAUNCH CONTAINER";
    docker run --rm -d -tt -p 8080:80    --name apache2-dev --restart=always  -v $DEV_WORK_DIRECTORY/Conf/apache2/sites-enabled:/etc/apache2/sites-enabled -v $DEV_WORK_DIRECTORY/projects:/var/www  smartiiz/apache2 
    docker run --rm -d -tt -p 8083:3306  --name mysql-dev   --restart=always  -v $DEV_WORK_DIRECTORY/mysql:/var/lib/mysql -e MYSQL_ROOT_PASSWORD=smartiiz mysql
    docker run --rm  -d -p 8080:80       --name myadmin     --restart=always -e PMA_ARBITRARY=1  phpmyadmin/phpmyadmin
    docker run --rm -d -tt -p 80:80      --name nginx-dev   --restart=always  -v $DEV_WORK_DIRECTORY/Conf/nginx:/etc/nginx/sites-enabled smartiiz/nginx
    
    echo "COUNTAINER LAUNCHED";
    docker ps -a;
    
    echo "PROXY PASS VALUE FOR NGINX :";
    docker inspect -f '{{range .NetworkSettings.Networks}}{{.IPAddress}}{{end}}' apache2php7-dev;
    echo "MYSQL HOST AND PHPMYADMIN FOR CONNECTION (Default PORT: 3306)";
    docker inspect -f '{{range .NetworkSettings.Networks}}{{.IPAddress}}{{end}}' mysql-dev;
    echo "MYSQL ROOT PASSWORD : smartiiz";

}

start(){
    if [ $FOCUS = "apache" ]; then
        echo "Restart Apache2 and Php";
        docker start apache2-dev
        echo "Apache 2 and Php Restarted";
    fi;
    
    if [ $FOCUS = "mysql" ]; then
        echo "Restart Mysql";
        docker start mysql-dev
        echo "Mysql Restarted";
    fi;
    
    if [ $FOCUS = "phpmyadmin" ]; then
        echo "Restart phpmyadmin";
        docker start myadmin
        echo "phpmyadmin Restarted";
    fi;
    
    if [ $FOCUS = "nginx" ]; then
        echo "Restart nginx proxy";
        docker start nginx-dev
        echo "phpmyadmin nginx proxy";
    fi;
    
    if [ $FOCUS = "all" ]; then
        echo "Restart Apache2 and Php";
        docker start apache2-dev
        echo "Apache 2 and Php Restarted";
        echo "Restart Mysql";
        docker start mysql-dev
        echo "Mysql Restarted";
        echo "Restart phpmyadmin";
        docker start myadmin
        echo "phpmyadmin Restarted";
    fi;

}

restart(){
    if [ $FOCUS = "apache" ]; then
        echo "Restart Apache2 and Php";
        docker restart apache2-dev
        echo "Apache 2 and Php Restarted";
    fi;
    
    if [ $FOCUS = "mysql" ]; then
        echo "Restart Mysql";
        docker restart mysql-dev
        echo "Mysql Restarted";
    fi;
    
    if [ $FOCUS = "phpmyadmin" ]; then
        echo "Restart phpmyadmin";
        docker restart myadmin
        echo "phpmyadmin Restarted";
    fi;
    
    if [ $FOCUS = "nginx" ]; then
        echo "Restart nginx proxy";
        docker restart nginx-dev
        echo "phpmyadmin nginx proxy";
    fi;
    
    if [ $FOCUS = "all" ]; then
        echo "Restart Apache2 and Php";
        docker restart apache2-dev
        echo "Apache 2 and Php Restarted";
        echo "Restart Mysql";
        docker restart mysql-dev
        echo "Mysql Restarted";
        echo "Restart phpmyadmin";
        docker restart myadmin
        echo "phpmyadmin Restarted";
    fi;
}

stop(){
    if [ $FOCUS = "apache" ]; then
        echo "Restart Apache2 and Php";
        docker stop apache2-dev
        echo "Apache 2 and Php Restarted";
    fi;
    
    if [ $FOCUS = "mysql" ]; then
        echo "Restart Mysql";
        docker stop mysql-dev
        echo "Mysql Restarted";
    fi;
    
    if [ $FOCUS = "phpmyadmin" ]; then
        echo "Restart phpmyadmin";
        docker stop myadmin
        echo "phpmyadmin Restarted";
    fi;
    
    if [ $FOCUS = "nginx" ]; then
        echo "Restart nginx proxy";
        docker stop nginx-dev
        echo "phpmyadmin nginx proxy";
    fi;
    
    if [ $FOCUS = "all" ]; then
        echo "Restart Apache2 and Php";
        docker stop apache2-dev
        echo "Apache 2 and Php Restarted";
        echo "Restart Mysql";
        docker stop mysql-dev
        echo "Mysql Restarted";
        echo "Restart phpmyadmin";
        docker stop myadmin
        echo "phpmyadmin Restarted";
    fi;
}

if [ $ACTION = "Install"]; then
    InstallApachePHP();
fi;

if [ $ACTION = "start"]; then
    start();
fi;

if [ $ACTION = "restart"]; then
    restart();
fi;

if [ $ACTION = "stop"]; then
    stop();
fi;
