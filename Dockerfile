FROM php:7.4.12-fpm-alpine

MAINTAINER Alu alu@dingdang-software.com

#国内repo源，让本地构建速度更快。
#RUN sed -i 's/dl-cdn.alpinelinux.org/mirrors.ustc.edu.cn/g' /etc/apk/repositories

#安装GD依赖库
RUN apk add --no-cache --virtual .build-deps \
		freetype-dev \
		libjpeg-turbo-dev \
		libpng-dev \
		libmcrypt-dev \
		bzip2-dev

#添加php源码中的扩展
RUN set -ex \
	&& docker-php-ext-configure gd \
		--with-freetype=/usr/include/freetype2/freetype \
		--with-jpeg=/usr/include \
	&& docker-php-ext-install -j5 gd bcmath opcache iconv pdo pdo_mysql mysqli sockets calendar bz2 zip

#redis属于pecl扩展，需要使用pecl命令来安装，同时需要添加依赖的库
RUN apk add --no-cache --virtual .phpize-deps $PHPIZE_DEPS \
	&& pecl install redis-5.2.0 \
	&& docker-php-ext-enable redis \
	&& apk del .phpize-deps

