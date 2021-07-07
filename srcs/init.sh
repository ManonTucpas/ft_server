service mysql start
service php7.3-fpm start

# Configure a wordpress database
echo "CREATE DATABASE wordpress;"| mysql -u root --skip-password
echo "GRANT ALL PRIVILEGES ON wordpress.* TO 'root'@'localhost' WITH GRANT OPTION;"| mysql -u root --skip-password
echo "FLUSH PRIVILEGES;"| mysql -u root --skip-password
echo "update mysql.user set plugin='' where user='root';"| mysql -u root --skip-password

#Auto index management

if [ $AUTOINDEX = "on" ]
then
    sed -i -r 's/.*autoindex.*/autoindex on;/g' /etc/nginx/sites-available/default

else
    sed -i -r 's/.*autoindex.*/autoindex off;/g' /etc/nginx/sites-available/default
fi

service nginx start


bash
