#!/usr/bin/env bash


#Maintenair brice.daupiard@smartiiz.com

ACTION=$1;
P2=$2;
P3=$3;
CURRENTFOLDER="$(pwd)"

clear_docker(){
    echo "clearing";
    if [ "$P2" == "all" ]; then
        echo "kill and remove  nginx proxy pass";
        docker kill nginx-dev;
        docker rm nginx-dev;
        echo "nginx Removed";
        echo "kill and remove Apache2 and Php";
        docker kill apache2-dev;
        docker rm apache2-dev;
        echo "Apache 2 and Php Removed";
        echo "kill and remove  Mysql";
        docker kill mysql-dev;
        docker rm mysql-dev;
        echo "Mysql Removed";
        echo "kill and remove  phpmyadmin";
        docker kill myadmin;
        docker rm myadmin;
        echo "phpmyadmin Removed";
        echo "Il y a actuelement $(docker ps -q | wc -l) container up";
    fi;

}

start_docker(){
    if [ "$P2" == "apache" ]; then
        echo "Restart Apache2 and Php";
        docker start apache2-dev
        echo "Apache 2 and Php Restarted";
    fi;
    
    if [ "$P2" == "mysql" ]; then
        echo "Restart Mysql";
        docker start mysql-dev
        echo "Mysql Restarted";
    fi;
    
    if [ "$P2" == "phpmyadmin" ]; then
        echo "Restart phpmyadmin";
        docker start myadmin
        echo "phpmyadmin Restarted";
    fi;
    
    if [ "$P2" == "nginx" ]; then
        echo "Restart nginx proxy";
        docker start nginx-dev
        echo "phpmyadmin nginx proxy";
    fi;
    
    if [ "$P2" == "all" ]; then
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

restart_docker(){
    if [ "$P2" == "apache" ]; then
        echo "Restart Apache2 and Php";
        docker restart apache2-dev
        echo "Apache 2 and Php Restarted";
    fi;
    
    if [ "$P2" == "mysql" ]; then
        echo "Restart Mysql";
        docker restart mysql-dev
        echo "Mysql Restarted";
    fi;
    
    if [ "$P2" == "phpmyadmin" ]; then
        echo "Restart phpmyadmin";
        docker restart myadmin
        echo "phpmyadmin Restarted";
    fi;
    
    if [ "$P2" == "nginx" ]; then
        echo "Restart nginx proxy";
        docker restart nginx-dev
        echo "phpmyadmin nginx proxy";
    fi;
    
    if [ "$P2" == "all" ]; then
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

stop_docker(){
    if [ "$P2" == "apache" ]; then
        echo "Restart Apache2 and Php";
        docker stop apache2-dev
        echo "Apache 2 and Php Restarted";
    fi;
    
    if [ "$P2" == "mysql" ]; then
        echo "Restart Mysql";
        docker stop mysql-dev
        echo "Mysql Restarted";
    fi;
    
    if [ "$P2" == "phpmyadmin" ]; then
        echo "Restart phpmyadmin";
        docker stop myadmin
        echo "phpmyadmin Restarted";
    fi;
    
    if [ "$P2" == "nginx" ]; then
        echo "Restart nginx proxy";
        docker stop nginx-dev
        echo "phpmyadmin nginx proxy";
    fi;
    
    if [ "$P2" == "all" ]; then
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

setHosts(){
    export SMARTIIZ_PHPMYADMIN=$(docker inspect -f '{{range .NetworkSettings.Networks}}{{.IPAddress}}{{end}}' myadmin);
    export SMARTIIZ_APACHEPHP=$(docker inspect -f '{{range .NetworkSettings.Networks}}{{.IPAddress}}{{end}}' apache2-dev);
    export SMARTIIZ_NGINX=$(docker inspect -f '{{range .NetworkSettings.Networks}}{{.IPAddress}}{{end}}' nginx-dev);
    export SMARTIIZ_MYSQL=$(docker inspect -f '{{range .NetworkSettings.Networks}}{{.IPAddress}}{{end}}' mysql-dev);
    echo "\"$SMARTIIZ_MYSQL mysql\" >> /etc/hosts"
    docker exec -u 0 apache2-dev /bin/sh -c "echo \"$SMARTIIZ_MYSQL mysql\" >> /etc/hosts";
    docker exec -u 0 apache2-dev /bin/sh -c "echo \"$SMARTIIZ_PHPMYADMIN myadmin\" >> /etc/hosts";
    docker exec -u 0 apache2-dev /bin/sh -c "echo \"$SMARTIIZ_NGINX nginx\" >> /etc/hosts";
    docker exec -u 0 nginx-dev /bin/sh -c "echo \"$SMARTIIZ_APACHEPHP apache\" >> /etc/hosts";
    docker exec -u 0 nginx-dev /bin/sh -c "echo \"$SMARTIIZ_PHPMYADMIN myadmin\" >> /etc/hosts";
    docker exec -u 0 myadmin /bin/sh -c "echo \"$SMARTIIZ_MYSQL mysql\" >> /etc/hosts";
    docker exec -u 0 apache2-dev /bin/sh -c "service apache2 restart";
    docker exec -u 0 nginx-dev /bin/sh -c "service nginx restart";
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
    mkdir projects;
    
    echo  "Docker accessible configuration for apache and Nginx";
    mkdir conf;
    
    mkdir conf/apache2
    
    mkdir conf/nginx;
    
    echo  "Mysql configuration directory";
    mkdir mysql;
    
    echo "LAUNCH CONTAINER";
    docker run  -d -tt -p 8082:80    --name apache2-dev --restart=always  -v $P2/conf/apache2/sites-enabled:/etc/apache2/sites-enabled -v $P2/projects:/var/www  -v $P2/logs/apache2:/var/log/apache2/ smartiiz/apache2-php-cli 
    docker run  -d -tt -p 8083:3306  --name mysql-dev   --restart=always  -v $P2/mysql:/var/lib/mysql -e MYSQL_ROOT_PASSWORD=smartiiz mysql:5.6
    docker run  -d -tt -p 8080:80    --name myadmin     --restart=always  -e PMA_HOST=$(docker inspect -f '{{range .NetworkSettings.Networks}}{{.IPAddress}}{{end}}' mysql-dev) phpmyadmin/phpmyadmin
    docker run  -d -tt -p 80:80      --name nginx-dev   --restart=always  -v $P2/conf/nginx:/etc/nginx/sites-enabled -v $P2/logs/nginx:/var/log/nginx/ smartiiz/nginx
    
    cd "$CURRENTFOLDER";
  

    pwd
    cp -R "$CURRENTFOLDER/template/hello-smartiiz"          "$P2/projects/." ;
    cp    "$CURRENTFOLDER/template/nginx/default.conf"      "$P2/conf/nginx/." ;
    echo "APACHE PROXY PASS : $(docker inspect -f '{{range .NetworkSettings.Networks}}{{.IPAddress}}{{end}}' apache2-dev)";
    cp -R "$CURRENTFOLDER/template/apache/default.conf"     "$P2/conf/apache2/sites-enabled/smartiiz.conf" ;
    sudo -- sh -c -e  "echo \"127.0.0.1 smartiiz.lab phpmyadmin.smartiiz.lab www.smartiiz.lab\"" >> /etc/hosts;
    
    
    echo "COUNTAINER LAUNCHED";
    docker ps -a;
    
    echo "PROXY PASS VALUE FOR NGINX :";
    docker inspect -f '{{range .NetworkSettings.Networks}}{{.IPAddress}}{{end}}' apache2-dev;
    echo "MYSQL HOST AND PHPMYADMIN FOR CONNECTION (Default PORT: 3306)";
    docker inspect -f '{{range .NetworkSettings.Networks}}{{.IPAddress}}{{end}}' mysql-dev;
    echo "MYSQL ROOT PASSWORD : smartiiz";
   

}



if [ "$ACTION" == "Install" ]; then
    InstallApachePHP
    setHosts
    docker exec -it apache2-dev /bin/bash;
elif [ "$ACTION" == "start" ]; then
    start_docker
    setHosts
    docker exec -it apache2-dev /bin/bash;
elif [ "$ACTION" == "restart" ]; then
    restart_docker
    setHosts
    docker exec -it apache2-dev /bin/bash;
elif [ "$ACTION" == "stop" ]; then
    stop_docker
elif [ "$ACTION" == "clear" ]; then
    echo "EUH ?";
    clear_docker
else
    echo "Nothing to do";
fi;
