FROM phusion/baseimage:0.9.18
MAINTAINER Quadeare <lacrampe.florian@gmail.com>

# Use baseimage-docker's init system.
CMD ["/sbin/my_init"]

# Export TERM
RUN export TERM=xterm

# Install dependencies
RUN apt-get update
RUN apt-get install -y wget apache2 php5 php5-mcrypt php5-gd php5-sqlite php5-mysql php5-pgsql supervisor git unzip zip libav-tools imagemagick apache2-utils
RUN apt-get build-dep -y aria2
RUN apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

# Install aria2
RUN mkdir -p /tmp/aria2-compilation
WORKDIR /tmp/aria2-compilation
RUN wget https://github.com/aria2/aria2/releases/download/release-1.23.0/aria2-1.23.0.tar.xz
RUN tar xf aria2-1.23.0.tar.xz && rm aria2-1.23.0.tar.xz
WORKDIR /tmp/aria2-compilation/aria2-1.23.0
RUN ./configure
RUN make && make install

# Enable apache2 modules
RUN a2enmod ssl && a2enmod rewrite

# Clone letsencrypt project
# RUN git clone https://github.com/letsencrypt/letsencrypt /opt/letsencrypt

# Fix php output_buffering
RUN sed -i 's/output_buffering = 4096/output_buffering = Off/g' /etc/php5/apache2/php.ini
RUN rm -rf /var/www/html

# Install pydio
WORKDIR "/var/www/pydio"
RUN wget http://netix.dl.sourceforge.net/project/ajaxplorer/pydio/stable-channel/6.2.2/pydio-core-6.2.2.tar.gz
RUN tar xf pydio-core-6.2.2.tar.gz
RUN cp -a pydio-core-6.2.2/* .
RUN rm -rf pydio-core-6.2.2/ pydio-core-6.2.2.tar.gz

# Install aria2 web-ui
WORKDIR "/var/www/aria2-webui"
RUN git clone https://github.com/ziahamza/webui-aria2.git ./
RUN touch /etc/apache2/.htpasswd

# Add configs files
ADD ./extra-data/mcrypt.ini /etc/php5/apache2/conf.d/mcrypt.ini
ADD ./extra-data/000-default.conf /etc/apache2/sites-available/000-default.conf
ADD ./extra-data/.htaccess /var/www/pydio/.htaccess
ADD ./extra-data/envvars /etc/apache2/envvars
ADD ./extra-data/supervisord.conf /etc/supervisor/conf.d/supervisord.conf
#ADD ./extra-data/lets-encrypt.sh /lets-encrypt.sh
ADD ./extra-data/configuration.js /var/www/aria2-webui/configuration.js
ADD ./extra-data/start.sh /start.sh
ADD ./extra-data/add-user.sh /add-user.sh
ADD ./extra-data/remove-user.sh /remove-user.sh

# Add bash script on bash
RUN ln -s /remove-user.sh /usr/bin/remove-user
RUN ln -s /add-user.sh /usr/bin/add-user

# Fix rights
WORKDIR "/var/www"
RUN chown -R www-data:www-data /var/www

# Volume
RUN ln -s /var/www/pydio/data/files /downloads
VOLUME ["/downloads"]

# Expose ports
EXPOSE 80
EXPOSE 6800


CMD ["/start.sh"]
