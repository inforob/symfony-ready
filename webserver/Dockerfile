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

# Install packages and PHP extensions
RUN apt update && apt install

# Php-cs-fixer
RUN wget https://cs.symfony.com/download/php-cs-fixer-v3.phar -O php-cs-fixer
RUN chmod a+x php-cs-fixer
RUN mv php-cs-fixer /usr/local/bin/php-cs-fixer

# Symfony installer
RUN wget wget https://get.symfony.com/cli/installer -O - | bash
RUN mv /root/.symfony/bin/symfony /usr/local/bin/symfony

COPY shell/localhost.sh /opt/localhost.sh
COPY shell/script.sh /opt/script.sh
COPY vhost/template /etc/apache2/sites-available
COPY vhost/vhost.conf /opt/docker/etc/httpd/vhost.conf

WORKDIR /var/www/