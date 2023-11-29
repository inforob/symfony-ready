FROM webdevops/php-apache-dev:8.2

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

# Install Tidy
RUN apt-get update \
    && apt-get install -y libtidy-dev \
    && docker-php-ext-install tidy \
    && docker-php-ext-enable tidy

# Php-cs-fixer
RUN wget https://cs.symfony.com/download/php-cs-fixer-v3.phar -O php-cs-fixer
RUN chmod a+x php-cs-fixer
RUN mv php-cs-fixer /usr/local/bin/php-cs-fixer
RUN php-cs-fixer self-update

# Symfony CLI
RUN printf "deb [trusted=yes] https://repo.symfony.com/apt/ /" > /etc/apt/sources.list.d/symfony-cli.list
RUN apt update && apt install symfony-cli

COPY shell/localhost.sh /opt/localhost.sh
COPY shell/script.sh /opt/script.sh
COPY vhost/template /etc/apache2/sites-available
COPY vhost/vhost.conf /opt/docker/etc/httpd/vhost.conf

# SSH
RUN mkdir -p /home/$user/.ssh
COPY .ssh/ /home/$user/.ssh/
RUN chown -R $user:$user /home/$user/.ssh/
RUN echo "    IdentityFile ~/.ssh/desktop" >> /etc/ssh/ssh_config

# SSL
RUN a2enmod ssl && a2enmod rewrite
RUN mkdir -p /etc/apache2/ssl/certs/
COPY ./ssl/certs/selfsigned.crt /etc/apache2/ssl/certs/selfsigned.crt

RUN mkdir -p /etc/apache2/ssl/private/
COPY ./ssl/private/selfsigned.key /etc/apache2/ssl/private/selfsigned.key

COPY vhost/vhost-ssl.conf /etc/apache2/sites-available


WORKDIR /var/www/projects