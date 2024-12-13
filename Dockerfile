FROM composer:latest AS build

WORKDIR /satis

COPY . /satis/

RUN set -eux ; \
  composer install \
    --no-interaction \
    --no-ansi \
    --no-scripts \
    --no-plugins \
    --no-dev \
    --prefer-dist \
    --no-progress \
    --no-suggest \
    --classmap-authoritative

FROM php:8-cli-alpine

COPY --from=mlocati/php-extension-installer /usr/bin/install-php-extensions /usr/local/bin/

RUN set -eux ; \
  apk upgrade --no-cache ; \
  apk add --no-cache --upgrade \
    cronie \
    bash \
    curl \
    git \
    mercurial \
    openssh \
    openssl \
    p7zip \
    subversion \
    unzip \
    zip ; \
  install-php-extensions \
    bz2 \
    sockets \
    zip

ENV COMPOSER_HOME /composer

COPY satis-cron /etc/cron.d/satis-cron
RUN chmod 0644 /etc/cron.d/satis-cron && crontab /etc/cron.d/satis-cron

COPY php-cli.ini /usr/local/etc/php/
COPY --from=build /satis /satis/

WORKDIR /build

CMD ["crond", "-f"]
