FROM php:7.1.15-fpm-alpine

MAINTAINER Alu alu@xdreport.com

#国内repo源，让本地构建速度更快。
RUN sed -i 's/dl-cdn.alpinelinux.org/mirrors.ustc.edu.cn/g' /etc/apk/repositories

#安装GD依赖库
RUN apk add --no-cache --virtual .build-deps \
		freetype-dev \
		libjpeg-turbo-dev \
		libpng-dev \
		libmcrypt-dev

#添加php源码中的扩展，添加gd,mysqli,pdo-mysql,opcache,gettext,mcrypt等扩展
RUN set -ex \
	&& docker-php-ext-configure gd \
		--with-freetype-dir=/usr/include/freetype2/freetype \
		--with-jpeg-dir=/usr/include \
		--with-png-dir=/usr/include \
	&& docker-php-ext-install gd bcmath zip opcache iconv mcrypt pdo pdo_mysql mysqli 

#redis属于pecl扩展，需要使用pecl命令来安装，同时需要添加依赖的库
RUN apk add --no-cache --virtual .phpize-deps $PHPIZE_DEPS \
	&& pecl install redis-3.1.2 swoole-4.0.4 \
	&& docker-php-ext-enable redis \
	&& apk del .phpize-deps

