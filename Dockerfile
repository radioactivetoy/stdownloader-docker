FROM alpine:latest
MAINTAINER Radioactivetoy radioactivetoy@nestorsg.com # You want to add your own name here

RUN apk add --no-cache --update-cache bash lighttpd \ 
php5-common php5-iconv php5-json php5-gd php5-curl php5-xml php5-pgsql php5-imap php5-cgi fcgi \
python py-pip \
unrar dcron 

RUN pip install transmissionrpc requests bs4 flock rarfile configparser supervisor 

RUN mkdir /var/run/lighttpd
RUN touch /var/run/lighttpd/php-fastcgi.socket
RUN chown -R lighttpd:lighttpd /var/run/lighttpd

COPY rootfs/etc/lighttpd/* /etc/lighttpd/
COPY rootfs/etc/supervisord.conf /etc/

RUN echo "0 0,7,10,12,14,16,18,20,22 * * * /var/www/html/stdownloader/scripts/video_automation.sh" > /etc/crontabs/lighttpd
 
EXPOSE 80/tcp

ENTRYPOINT ["/usr/bin/supervisord", "--nodaemon", "--configuration", "/etc/supervisord.conf"]
