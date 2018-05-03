FROM php:7.1-fpm-alpine
WORKDIR "/public_html"

RUN apk update \
    && apk upgrade --update

RUN apk add vim git

RUN adduser -u 1000 -G www-data -s /bin/sh -D fpm_app

RUN set -xe \
    && ( \
        apk add --no-cache \
                libxml2-dev \
                libxslt-dev \
                zlib-dev \
                icu-dev \
                autoconf \
                dpkg-dev dpkg \
                file \
                g++ \
                gcc \
                libc-dev \
                make \
                pkgconf \
                re2c \
    ) \
	## install pdo_mysql
	&& ( \
		docker-php-ext-install 	    pdo_mysql \
		&& docker-php-ext-install 	soap \
		&& docker-php-ext-install 	intl \
		&& docker-php-ext-install 	xsl \
		&& docker-php-ext-install 	zip \
		&& docker-php-ext-install   opcache \
    && docker-php-ext-install   bcmath \
	) \
	## install gd
	&& ( \
		apk add \
			--no-cache \
			freetype \
			libpng \
			libjpeg-turbo \
			freetype-dev \
			libpng-dev \
			libjpeg-turbo-dev\
		&& docker-php-ext-configure gd \
			--with-gd \
			--with-freetype-dir=/usr/include/ \
			--with-png-dir=/usr/include/ \
			--with-jpeg-dir=/usr/include/ \
		&& docker-php-ext-install gd \
		&& apk del \
			--no-cache \
			freetype-dev \
			libpng-dev \
			libjpeg-turbo-dev \
	) \
	## install mcrypt
	&& ( \
		apk add \
			--no-cache \
			libmcrypt-dev \
			libltdl \
		&& docker-php-ext-configure mcrypt \
			--with-mcrypt \
		&& docker-php-ext-install  mcrypt \
	)

RUN pecl install xdebug-2.6.0 \
  && docker-php-ext-enable xdebug

RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/bin --filename=composer

# Install n98
RUN curl -L -o n98-magerun2.phar https://files.magerun.net/n98-magerun2.phar \
  && mv n98-magerun2.phar /usr/local/bin/mage \
  && chmod +x /usr/local/bin/mage

COPY fpm-entrypoint /usr/local/bin/

USER fpm_app

ENTRYPOINT ["fpm-entrypoint"]

CMD ["php-fpm", "-F"]
