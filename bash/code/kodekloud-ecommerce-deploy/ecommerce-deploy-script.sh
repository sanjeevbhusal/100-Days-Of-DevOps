#!/bin/bash
# This script automates the deployement of a ecommerce application built using LAMP stack.


# -------------------------------------------------------------------- Functions --------------------------------------------------------------


################################
# Prints a colored message (red/green) on terminal
# Arguments:
#    Color. eg: red or green
#    Message. eg: "database server is working perfectly" 
################################
function print_colored_message() {
  COLOR=$1
  message=$2
  NO_COLOR_CODE="\033[0m"
  
  case $COLOR in
    "green") COLOR="\033[0;32m" ;;
    "red") COLOR="\033[0;31m" ;;
  esac

  echo -e "${COLOR} $message ${NO_COLOR_CODE}"
}

################################
# Checks the service running status. Error out and exist the script if the service is not running. Prints the appropriate message on the terminal.
# Arguments:
#    Service Name. eg: httpd, maridb etc
################################
function check_service_status() {
  service_name=$1

  is_service_active=$(sudo systemctl is-active "$service_name")
  if [ "$is_service_active" = "active" ] 
  then
    print_colored_message "green" "$service_name Service is active"
  else
    print_colored_message "red" "$service_name Service activation failed"
    exit 1
  fi
}


################################
# Checks if a port is opened in firewall rules. Error out and exist if the port is not opened. Prints the appropriate message on the terminal.
# Arguments:
#    Port. eg: 80, 3306 etc
################################
function check_port_opened() {
  port=$1

  ports=$(sudo firewall-cmd --list-all --zone=public | grep ports)
  if [[ $ports = *$port* ]]
  then
    print_colored_message "green" "Port $port has been opened succesfully."
  else
    print_colored_message "red" "Port $port opening failed"
    exit 1
  fi

}


# ---------------------------------------------------------------Firewall Service Installation and Configuration ----------------------------------
# install firewall
print_colored_message "green" "Installing Firewalld"
sudo yum install -y firewalld 

# start firewall
print_colored_message green "Starting Firewalld"
sudo service firewalld start 
sudo systemctl enable firewalld

# check if service is active
check_service_status firewalld



# -----------------------------------------------------------------Database Server Installation and Configuration ---------------------------------------------------

# install database-server
print_green_message "green" "Installing Database Server"
sudo yum install -y mariadb-server

# modify default settings such as port  
# sudo vi /etc/my.cnf

# start database server
print_green_message "green" "Starting Database Server"
sudo service mariadb start
sudo systemctl enable mariadb

# check if service is active
check_service_status mariadb


# create a sql file that has all the commands needed to setup database, user and associated permissions
print_colored_message "green" "Creating a sqlfile that contains commands for creating new database, new user and setting up associated permissions"
cat > configure-db.sql <<-EOF
CREATE DATABASE ecomdb;
CREATE USER 'ecomuser'@'localhost' IDENTIFIED BY 'ecompassword';
GRANT ALL PRIVILEGES ON *.* TO 'ecomuser'@'localhost';
FLUSH PRIVILEGES;
EOF

# invoke that file
print_colored_message "green" "Invoking that file"
mysql -uroot < configure-db.sql

# create a sql f in /var/www/htmlile that has all the commands needed to load fake data in the database
print_colored_message "green" "Creating a sqlfile that contains commands for loading fake data into the database"
cat > db-load-script.sql <<-EOF
USE ecomdb;
CREATE TABLE products (id mediumint(8) unsigned NOT NULL auto_increment,Name varchar(255) default NULL,Price varchar(255) default NULL, ImageUrl varchar(255) default NULL,PRIMARY KEY (id)) AUTO_INCREMENT=1;
INSERT INTO products (Name,Price,ImageUrl) VALUES ("Laptop","100","c-1.png"),("Drone","200","c-2.png"),("VR","300","c-3.png"),("Tablet","50","c-5.png");
EOF

# invoke that file
print_colored_message "green" "Invoking that file"
mysql -uroot < db-load-script.sql


# check if database, tables, dummy data is configured properly
db_results=$(sudo mysql -e "use ecomdb; select * from products;")
if [[ $db_results = *Laptop* ]]
then
  print_colored_message "green" "Data has been loaded succesfully"
else
  print_colored_message "red" "Data loading failed"
  exit 1
fi


# configure firewall for database
print_colored_message "green" "Configuring Firewall rules for database"
sudo firewall-cmd --permanent --zone=public --add-port=3306/tcp
sudo firewall-cmd --reload

# check port status
check_port_opened 3306

# --------------------------------------------------------Webserver and application Installtion/Configuration -----------------------------------

# install php, webserver and other dependencies
print_colored_message "green" "Installing Webserver"
sudo yum install -y httpd php php-mysql

# configure httpd to serve index.php instead of index.html
print_colored_message "green" "Configuring httpd to serve index.php instead of index.html"
sudo sed -i 's/index.html/index.php/g' /etc/httpd/conf/httpd.conf

# start httpd
print_colored_message "green" "start httpd"
sudo service httpd start
sudo systemctl enable httpd

# check if service is active
check_service_status httpd

# clone the code repository into the right location
print_colored_message "green" "clone the repository"
sudo yum install -y git
sudo git clone https://github.com/kodekloudhub/learning-app-ecommerce.git /var/www/html/

# update index.php to conncect to database on localhost
print_colored_message "green" "update index.php file to connect to localhost database"
sudo sed -i 's/172.20.1.101/localhost/g' /var/www/html/index.php

# configure firewall for webserver
print_colored_message "green" "Configuring Firewall rules for httpd"
sudo firewall-cmd --permanent --zone=public --add-port=80/tcp
sudo firewall-cmd --reload

# check port status
check_port_opened 80



# ----------------------------------------------------------Test if the application is running as expected ------------------------------------------

print_colored_message "green" "Testing the application"
webpage=$(curl http://localhost)

# check if application is running
if [[ "$webpage" = *Laptop* ]]
then
  print_colored_message "green" "Test Succesfull. Application is running"
else
  print_colored_message "red" "Test Failed"
fi

