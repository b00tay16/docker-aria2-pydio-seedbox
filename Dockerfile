FROM phusion/baseimage:0.9.18
MAINTAINER Quadeare <lacrampe.florian@gmail.com>

# Install dependencies
RUN apt-get update
RUN apt-get install -y wget apache2 php5 php5-mcrypt php5-gd php5-sqlite php5-mysql php5-pgsql supervisor git unzip zip libav-tools imagemagick apache2-utils
RUN apt-get build-dep -y aria2
RUN apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

# Install aria2
RUN mkdir -p /tmp/aria2-compilation
WORKDIR /tmp/aria2-compilation
RUN wget https://github.com/aria2/aria2/releases/download/release-1.23.0/aria2-1.23.0.tar.xz
RUN tar xf aria2-1.23.0.tar.xz
WORKDIR /tmp/aria2-compilation/aria2-1.23.0
RUN ./configure
RUN make && make install

# Enable apache2 modules
RUN a2enmod ssl && a2enmod proxy && a2enmod proxy_http && a2enmod proxy_balancer && a2enmod rewrite

# Clone letsencrypt project
RUN git clone https://github.com/letsencrypt/letsencrypt /opt/letsencrypt

# Fix php output_buffering
RUN sed -i 's/output_buffering = 4096/output_buffering = Off/g' /etc/php5/apache2/php.ini
RUN rm -rf /var/www/html

# Install pydio
WORKDIR "/var/www/pydio"
RUN wget http://netix.dl.sourceforge.net/project/ajaxplorer/pydio/stable-channel/6.2.2/pydio-core-6.2.2.tar.gz
RUN tar xf pydio-core-6.2.2.tar.gz
RUN cp -a pydio-core-6.2.2/* .
RUN rm -rf pydio-core-6.2.2/ pydio-core-6.2.2.tar.gz

# Install aria2
WORKDIR "/var/www/aria2"
RUN git clone https://github.com/ziahamza/webui-aria2.git ./

# Add configs files
ADD ./extra-data/mcrypt.ini /etc/php5/apache2/conf.d/mcrypt.ini
ADD ./extra-data/000-default.conf /etc/apache2/sites-available/000-default.conf
ADD ./extra-data/.htaccess /var/www/pydio/.htaccess
ADD ./extra-data/envvars /etc/apache2/envvars
ADD ./extra-data/supervisord.conf /etc/supervisor/conf.d/supervisord.conf
ADD ./extra-data/start.sh /start.sh

# Fix rights
WORKDIR "/var/www"
RUN chown -R www-data:www-data /var/www

# Expose ports
EXPOSE 80
EXPOSE 6800


CMD ["/start.sh"]
