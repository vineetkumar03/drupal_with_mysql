FROM php:7.3-apache-stretch
USER root
# Set PHP and System Date Time
ARG ARG_APACHE_LISTEN_PORT=8080
ENV APACHE_LISTEN_PORT=${ARG_APACHE_LISTEN_PORT}
RUN sed -s -i -e "s/80/${APACHE_LISTEN_PORT}/" /etc/apache2/ports.conf /etc/apache2/sites-available/*.conf
EXPOSE ${APACHE_LISTEN_PORT}
RUN echo "date.timezone=Asia/Kolkata" > /usr/local/etc/php/conf.d/date_timezone.ini
RUN echo "Asia/Kolkata" > /etc/timezone; dpkg-reconfigure -f noninteractive tzdata

# Install needed php extensions: ldap
# RUN \
#     apt-get update && \
#     apt-get install libldap2-dev -y && \
#     rm -rf /var/lib/apt/lists/* && \
#     docker-php-ext-configure ldap --with-libdir=lib/x86_64-linux-gnu/ && \
#     docker-php-ext-install ldap

# install the PHP extensions we need
RUN set -ex \
	&& buildDeps=' \
	  libzip-dev \
		libfreetype6-dev \
		libjpeg62-turbo-dev \
		libxpm-dev \
		libvpx-dev \
		libpq-dev \
		libldap2-dev \
	' \
	&& apt-get update && apt-get install -y --no-install-recommends $buildDeps && rm -rf /var/lib/apt/lists/* \
	&& docker-php-ext-configure ldap --with-libdir=lib/x86_64-linux-gnu/ \
    && docker-php-ext-install ldap \
	&& docker-php-ext-configure gd \
	    --with-freetype-dir=/usr/lib/x86_64-linux-gnu/ \
		--with-jpeg-dir=/usr/lib/x86_64-linux-gnu/ \
		--with-xpm-dir=/usr/lib/x86_64-linux-gnu/ \
	&& docker-php-ext-install -j "$(nproc)" gd mbstring opcache bcmath pdo pdo_mysql pdo_pgsql zip


RUN rm /bin/sh && ln -s /bin/bash /bin/sh && \
    apt-get update && apt-get install --no-install-recommends -y \
    curl \
    wget \
    vim \
    unzip \
    mysql-client


# set recommended PHP.ini settings
# see https://secure.php.net/manual/en/opcache.installation.php
RUN { \
		echo 'opcache.memory_consumption=128'; \
		echo 'opcache.interned_strings_buffer=8'; \
		echo 'opcache.max_accelerated_files=4000'; \
		echo 'opcache.revalidate_freq=60'; \
		echo 'opcache.fast_shutdown=1'; \
		echo 'opcache.enable_cli=1'; \
	} > /usr/local/etc/php/conf.d/opcache-recommended.ini

#RUN mkdir -p /var/lib/php/session
#RUN chown -R www-data:www-data /var/lib/php/session

# Configure Session
#RUN { \
#		echo 'session.save_handler = files'; \
#		echo 'session.save_path = "/var/lib/php/session"'; \
#	} > /usr/local/etc/php/conf.d/session.ini

# Config rewrite
 RUN sed -i "s/AllowOverride None/AllowOverride All/g" /etc/apache2/apache2.conf \
     && a2enmod rewrite expires \
     && service apache2 restart

# Enable apache mods
RUN a2enmod rewrite \
&& service apache2 restart

# Set working directory
WORKDIR /var/www/html	 

# https://www.drupal.org/node/3060/release
ENV DRUPAL_VERSION 7.69
ENV DRUPAL_MD5 292290a2fb1f5fc919291dc3949cdf7c
#ENV DRUPAL_VERSION 7.65
#ENV DRUPAL_MD5 d453c23413627594f3f05c984e339706

RUN curl -fSL "https://ftp.drupal.org/files/projects/drupal-${DRUPAL_VERSION}.tar.gz" -o drupal.tar.gz \
	&& echo "${DRUPAL_MD5} *drupal.tar.gz" | md5sum -c - \
	&& tar -xz --strip-components=1 -f drupal.tar.gz \
	&& rm drupal.tar.gz
# DRUSH INSTALLATION:
ENV DRUSH_VERSION 8.1.2
RUN curl -L --silent https://github.com/drush-ops/drush/releases/download/${DRUSH_VERSION}/drush.phar \
  > /usr/local/bin/drush && chmod +x /usr/local/bin/drush
# Update the drupal Contents
ADD source/sites /var/www/html/sites

RUN chown -R www-data:www-data sites

#ADD ldap_certificates/ldap.conf /etc/ldap
#ADD ldap_certificates/ldap-nic.crt /etc/ssl/certs
ADD run.sh /run.sh
RUN chmod 755 /*.sh

# MySQL environment variables
ENV MYSQL_HOST db
ENV MYSQL_ROOT_PASSWORD password
ENV MYSQL_USER root
ENV MYSQL_PASSWORD password
ENV MYSQL_DATABASE drupal_db
ENV SITE_URL http://core.gov.in
#ENV REDIRECT_URL https://example.gov.in
#ENV IS_HTTPS on
#USER root
EXPOSE 80
CMD ["/run.sh"]
