FROM webdevops/php-apache-dev:7.4

ARG email
ARG user

ENV BUILD_DEPS \
        build-essential \
        libsasl2-dev \
        libssl-dev \
        python-minimal \
        zlib1g-dev

RUN apt-get update && apt-get install -y --no-install-recommends ${BUILD_DEPS}

RUN git config --global user.email $email
RUN git config --global user.name $user

RUN wget https://get.symfony.com/cli/installer -O - | bash
RUN mv /root/.symfony/bin/symfony /usr/local/bin/symfony

COPY ./vhost/template /etc/apache2/sites-available
COPY ./vhost/vhost.conf /opt/docker/etc/httpd/vhost.conf
COPY ./shell/script.sh /opt/script.sh
COPY ./composer/composer.json /opt/composer.json

WORKDIR /var/www/projects