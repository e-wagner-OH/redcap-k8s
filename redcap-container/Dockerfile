FROM php:8.2-apache
LABEL maintainer="Eric Wagner <eric.wagner@ohiohealth.com>"
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
    # libmagickwand-dev \
    ghostscript \
    unzip \
    && rm -rf /var/lib/apt/lists/*


RUN touch /var/log/msmtp.log && ln -sf /dev/stdout /var/log/msmtp.log && chown apache:apache /var/log/msmtp.log

# RUN printf "\n" | pecl install imagick

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
    # docker-php-ext-enable imagick; \
    docker-php-ext-install -j "$(nproc)" \
        gd \
        mysqli \
        mbstring \
        xml \
        zip

RUN a2enmod headers setenvif rewrite log_forensic proxy proxy_http proxy_balancer lbmethod_byrequests

# for testing
# COPY --chown=48:48 webapp/test-database.php /var/www/html/redcap/database.php
# RUN sed -i 's~<policy domain="coder" rights="none" pattern="PDF" />~<policy domain="coder" rights="read | write" pattern="PDF" />~' /etc/ImageMagick-6/policy.xml

# Update the default Apache configuration to listen on port 8080
RUN sed -i 's/Listen 80/Listen 8080/' /etc/apache2/ports.conf && \
    sed -i 's/<VirtualHost \\*:80>/<VirtualHost *:8080>/' /etc/apache2/sites-available/000-default.conf

# Expose the new port
EXPOSE 8080

# Copy REDCap zip file
COPY redcap14.7.2.zip /tmp/redcap.zip

# Unzip and set permissions
RUN unzip /tmp/redcap.zip -d /var/www/html && \
    chown -R 48:48 /var/www/html

# adding an OH cert to the container to fix a curl 60 error
# COPY derp.pem /usr/local/share/ca-certificates/ohiohealthcrt.pem
COPY ohcert.pem /etc/ssl/certs/ohiohealthcrt.pem
RUN sudo update-ca-certificates --fresh

ENV CURL_CA_BUNDLE=/etc/ssl/certs/ca-certificates.crt
ENV SSL_CERT_FILE=/etc/ssl/certs/ca-certificates.crt

USER 48:48