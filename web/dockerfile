FROM centos/httpd
MAINTAINER Limbas GmbH <info@limbas.com>

# install dependencies
RUN yum -y update
RUN yum -y install epel-release http://rpms.remirepo.net/enterprise/remi-release-7.rpm &&\
    yum-config-manager --enable remi-php71 &&\
    yum -y install php php-pdo php-pgsql php-mysql php-gd php-soap php-imap php-xml php-ctype php-mbstring ImageMagick poppler-utils wget zip unzip perl-Image-ExifTool htmldoc &&\
    yum clean all

# add limbas source
ADD openlimbas.tar.gz /opt
RUN chown -R apache:apache /opt/openlimbas/dependent

# fix missing timezone in php.ini
RUN echo "date.timezone = Europe/Berlin" >> /etc/php.ini

# apache config
ADD openlimbas.conf /etc/httpd/conf.d/openlimbas.conf
RUN sed -i 's/DocumentRoot ".*"/DocumentRoot "\/opt\/openlimbas\/dependent"/g' /etc/httpd/conf/httpd.conf

# database connection config
ADD include_db.lib /opt/openlimbas/dependent/inc/include_db.lib
RUN chown apache /opt/openlimbas/dependent/inc/include_db.lib

# unpack demo extensions
RUN tar xzf /opt/openlimbas/dependent/EXTENSIONS/demo.tar.gz -C /opt/openlimbas/dependent/EXTENSIONS

# dependent is written to by apache
VOLUME /opt/openlimbas/dependent

# original entry file from centos/httpd
CMD ["/run-httpd.sh"]
