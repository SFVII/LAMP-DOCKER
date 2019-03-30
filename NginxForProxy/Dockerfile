## Dockerfile pour le déploiement d'application de type wordpress
# ou plutot custom Website.

FROM phusion/baseimage:latest

MAINTAINER SMARTIIZ (brice.daupiard@smartiiz.com)

ENV DEBIAN_FRONTEND noninteractive
ENV NGINX_CONF /etc/nginx/nginx.conf
ENV NGINX_ERROR_LOG /var/log/nginx/error.log
ENV NGINX_ACCESS_LOG /var/log/nginx/access.log
ENV NGINX_PORT 80

RUN apt-get -y update
RUN apt-get -y --force-yes install dpkg-dev debhelper

#On va rajouter notre package liste au container
ADD  packagelist.txt /tmp/packagelist.txt
RUN  apt-get install --force-yes -y $(cat /tmp/packagelist.txt);
RUN  echo "exit 0" > /usr/sbin/policy-rc.d
ADD  start_services.sh /start_services.sh
RUN  chmod +x /start_services.sh
ENTRYPOINT ["/start_services.sh"]
EXPOSE 80
CMD ["/sbin/my_init && echo 'Container is ready' && /bin/sh "]
