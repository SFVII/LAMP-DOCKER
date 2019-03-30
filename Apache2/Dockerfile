## Dockerfile pour le déploiement d'application de type wordpress
# ou plutot custom Website.

FROM phusion/baseimage:latest

MAINTAINER SMARTIIZ (brice.daupiard@smartiiz.com)

ENV DEBIAN_FRONTEND noninteractive
ENV HTTP_PATH /var/www/
ENV PHP-FPM 9000
ENV APACHE-PORT 8082


RUN apt-get -y update
RUN apt-get -y --force-yes install dpkg-dev debhelper

#On va rajouter notre package liste au container
ADD  packagelist.txt /tmp/packagelist.txt
RUN  apt-get install --force-yes -y $(cat /tmp/packagelist.txt);
RUN  php -r "copy('https://getcomposer.org/installer', 'composer-setup.php');";
RUN  php -r "if (hash_file('sha384', 'composer-setup.php') === '48e3236262b34d30969dca3c37281b3b4bbe3221bda826ac6a9a62d6444cdb0dcd0615698a5cbe587c3f0fe57a54d8f5') { echo 'Installer verified'; } else { echo 'Installer corrupt'; unlink('composer-setup.php'); } echo PHP_EOL;";
RUN  php composer-setup.php;
RUN  php -r "unlink('composer-setup.php');";
RUN  ls -l /usr/lib/apache2/modules/;
RUN  a2enmod rewrite;
RUN  a2enmod deflate;
RUN  a2enmod cache;
RUN  a2enmod proxy;
RUN  a2enmod ssl;
RUN  a2enmod actions;
RUN  echo "exit 0" > /usr/sbin/policy-rc.d
COPY fastcgi.conf /etc/apache2/conf-enabled/fastcgi.conf
ADD start_services.sh /start_services.sh
RUN chmod +x /start_services.sh
ENTRYPOINT ["/start_services.sh"]
EXPOSE 80
CMD ["/sbin/my_init && echo 'Container is ready' && /bin/sh "]
