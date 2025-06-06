FROM php:8.1-apache

# Install MariaDB server and PHP MySQL extension
RUN apt-get update && \
    apt-get install -y mariadb-server && \
    apt-get install -y micro && \
    docker-php-ext-install mysqli && \
    mkdir -p /var/run/mysqld && \
    chmod 777 /var/run/mysqld /etc/mysql /var/lib/mysql

COPY . /var/www/html/
RUN chmod -R 777 /var/www/html/uploads

# Copy and set init script
COPY db.sql /docker-entrypoint-initdb.sql

EXPOSE 80
EXPOSE 3306

# Launch both services (MariaDB and Apache) correctly
CMD ["sh", "-c", "mysqld_safe & sleep 5 && mysql -u root < /docker-entrypoint-initdb.sql && apache2-foreground"]
