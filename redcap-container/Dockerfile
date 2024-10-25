FROM php:8.2-apache
# FROM php:8.0-apache
LABEL maintainer="Eric Wagner <eric.wagner@ohiohealth.com>"
# EXPOSE 8080
USER root
RUN groupadd --system -g 48 apache && \
    useradd --system --create-home --home-dir /home --no-log-init -g 48 -u 48 apache

RUN apt-get update -qq && \
    apt-get -yq --no-install-recommends install \
    sudo \
    msmtp-mta \
    libpng-dev \
    libzip-dev \
    libxml2-dev \
    libfreetype6-dev \
    libjpeg62-turbo-dev \
    libonig-dev \
    libxpm-dev \
    libmagickwand-dev \
    ghostscript \
    unzip \
    && rm -rf /var/lib/apt/lists/*


RUN touch /var/log/msmtp.log && ln -sf /dev/stdout /var/log/msmtp.log && chown apache:apache /var/log/msmtp.log

RUN printf "\n" | pecl install imagick

# Copy the zip file to the container
# COPY redcap14.7.2.zip /tmp/redcap.zip

# Unzip the contents to the desired directory and set ownership
# RUN unzip /tmp/redcap.zip -d /var/www/html && \
#     chown -R 48:48 /var/www/html/redcap

# RUN unzip /tmp/redcap.zip -d /var/www/html/derp && \
#     # mv /var/www/html/redcap/* /var/www/html/ && \
#     # rmdir /var/www/html/redcap && \
#     chown -R 48:48 /var/www/html

# COPY --chown=48:48 info.php /var/www/html/redcap/info.php

# setup some docker default capabilities
RUN set -eux; \
    docker-php-ext-configure gd --enable-gd --with-freetype --with-jpeg; \
    docker-php-ext-configure zip; \
    docker-php-ext-enable imagick; \
    docker-php-ext-install -j "$(nproc)" \
        gd \
        mysqli \
        mbstring \
        xml \
        zip

RUN a2enmod headers setenvif rewrite log_forensic proxy proxy_http proxy_balancer lbmethod_byrequests

# add the docker-php-entrypoint script to the container so it can be ran
# COPY --chown=48:48 docker-php-entrypoint /usr/local/bin/

# for testing
# COPY --chown=48:48 webapp/test-database.php /var/www/html/redcap/database.php
RUN sed -i 's~<policy domain="coder" rights="none" pattern="PDF" />~<policy domain="coder" rights="read | write" pattern="PDF" />~' /etc/ImageMagick-6/policy.xml

# FROM php:8.2-apache

# Update the default Apache configuration to listen on port 8080
RUN sed -i 's/Listen 80/Listen 8080/' /etc/apache2/ports.conf && \
    sed -i 's/<VirtualHost \\*:80>/<VirtualHost *:8080>/' /etc/apache2/sites-available/000-default.conf

# Expose the new port
EXPOSE 8080

# finish setting up the crontab for REDCap
# RUN echo "%apache ALL=(root) NOPASSWD:/usr/sbin/cron" >> /etc/sudoers.d/apache
# RUN sed -i -e '/pam_loginuid.so/s/^/#/' /etc/pam.d/cron && \
#     chmod 0644 /etc/crontab && \
#     echo "* * * * * /usr/local/bin/php /var/www/html/redcap/cron.php >> /tmp/cron.log 2>&1" >> /etc/cron.d/redcap-cron && \
#     crontab -u apache /etc/cron.d/redcap-cron && \
#     chmod u+s /usr/sbin/cron

#COPY --chown=48:48 webapp/redcap_connect_dumb_error.php /var/www/html/redcap/redcap_connect.php
# switch back to the apache user
# Copy the zip file to the container
COPY redcap14.7.2.zip /tmp/redcap.zip

# RUN touch /tmp/derp

# RUN ls -al /tmp

# RUN touch /var/www/html/derp

# RUN ls -al /var/www/html

RUN unzip /tmp/redcap.zip -d /var/www/html && \
    # mv /var/www/html/redcap/* /var/www/html/ && \
    # rmdir /var/www/html/redcap && \
    chown -R 48:48 /var/www/html

USER 48:48