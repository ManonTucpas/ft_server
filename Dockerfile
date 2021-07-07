FROM debian:buster

RUN apt-get update

RUN apt-get install nginx -y

RUN apt-get install vim -y

RUN apt-get -y install wget

COPY ./srcs/index.html /var/www/html/

#location where webserver finds files for web pages when web browser requests
WORKDIR /var/www/html/

# Install MariaDB
RUN apt-get install mariadb-server -y

# Install PHP
RUN apt-get install -y php7.3
RUN apt-get install -y php-mysql
RUN apt-get install -y php-pdo
RUN apt-get install -y php-fpm
RUN apt-get install -y php-cli
RUN apt-get install -y php-curl php-gd php-intl php-json php-mbstring php-xml php-zip 

# Install phpmyadmin
RUN wget https://files.phpmyadmin.net/phpMyAdmin/5.0.4/phpMyAdmin-5.0.4-all-languages.tar.gz
RUN tar -xvf phpMyAdmin-5.0.4-all-languages.tar.gz
RUN rm -rf phpMyAdmin-5.0.4-all-languages.tar.gz
RUN mv phpMyAdmin-5.0.4-all-languages phpmyadmin

# Install WP
RUN wget https://wordpress.org/latest.tar.gz
RUN tar -xvf latest.tar.gz && rm -rf latest.tar.gz

# Declare port for webserver
EXPOSE 80 443

# To run the file need to copy it
#COPY ./srcs/init.sh /

COPY ./srcs/default /etc/nginx/sites-available/default

COPY ./srcs/config.inc.php phpmyadmin

COPY ./srcs/wp-config.php /

# SSL Certificate Setting
RUN openssl req -x509 -nodes -days 365 -subj "/CN=mlecuyer" -newkey rsa:2048 -keyout /etc/ssl/nginx-mykey.key -out /etc/ssl/nginx-mycert.crt;

COPY ./srcs/init.sh /

# Change Authorization
RUN chown -R www-data:www-data *
RUN chmod -R 755 /var/www/*

# Init bash and nginx
CMD ["bash","/init.sh"]
