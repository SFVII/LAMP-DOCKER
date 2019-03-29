## Dockerfile pour le déploiement d'application de type wordpress
# ou plutot custom Website.

FROM phusion/baseimage:latest

MAINTAINER SFVII (brice@nippon.wtf)

ENV DEBIAN_FRONTEND noninteractive
ENV HTTP_PATH /var/www/
ENV PHP-FPM 9000
ENV APACHE-PORT 8082

RUN apt-get -y update
RUN apt-get -y --force-yes install dpkg-dev debhelper

#On va rajouter notre package liste au container
ADD  packagelist.txt /tmp/packagelist.txt
RUN  apt-get install --force-yes -y $(cat /tmp/packagelist.txt);
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
