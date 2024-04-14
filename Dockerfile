FROM php:7.1-apache

# Instalar Composer
RUN curl -sS https://getcomposer.org/download/1.0.0/composer.phar -o /usr/local/bin/composer
RUN chmod +x /usr/local/bin/composer

# Copiar código do aplicativo para o contêiner
COPY . /var/www/html

RUN apt-get update && apt-get install -y \
    git \
    curl \
    zip \
    unzip \
    nano \
    && rm -rf /var/lib/apt/lists/*

RUN composer install --no-interaction --no-scripts --no-progress --prefer-dist

# Configurar ambiente do Apache
ENV APACHE_DOCUMENTROOT /var/www/html
ENV APACHE_RUN_USER www-data
ENV APACHE_RUN_GROUP www-data

# Expor porta 80 para o servidor web
EXPOSE 80

ENV PATH="$PATH:/usr/bin/php"
RUN cp apache/apache2.conf /etc/apache2/
RUN cp apache/000-default.conf /etc/apache2/sites-available/
RUN git config --global --add safe.directory /var/www/html

RUN a2enmod rewrite

# Iniciar o servidor web
CMD apachectl -DFOREGROUND