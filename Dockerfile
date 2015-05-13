FROM ubuntu
MAINTAINER Jonas Svatos <mail@jonassvatos.net>

RUN apt-get update && apt-get upgrade -y
RUN apt-get install -y wget
RUN wget -O - http://dl.ajaxplorer.info/repos/charles@ajaxplorer.info.gpg.key | sudo apt-key add -

RUN echo "deb http://dl.ajaxplorer.info/repos/apt stable main" > /etc/apt/sources.list.d/pydio.list
RUN apt-get update

RUN apt-get install -y pydio git curl php5-mysql php5-sqlite
RUN cp /usr/share/doc/pydio/apache2.sample.conf /etc/apache2/sites-available/pydio.conf
RUN a2enmod rewrite
RUN a2enmod ssl
RUN a2ensite default-ssl
RUN a2ensite pydio
RUN php5enmod mcrypt

WORKDIR /tmp
RUN curl -sS https://getcomposer.org/installer | php
RUN mv composer.phar /usr/local/bin/composer

WORKDIR /usr/share/pydio/plugins/access.swift
RUN git clone https://github.com/stackforge/openstack-sdk-php.git

WORKDIR /usr/share/pydio/plugins/access.swift/openstack-sdk-php
RUN composer install

WORKDIR /
VOLUME ["/var/www/pydio/data", "/tmp"]
CMD ["/usr/sbin/apache2ctl", "-D", "FOREGROUND"]
EXPOSE 80 443
