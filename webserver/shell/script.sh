#!/bin/bash

# This script creates a new project (or site) under /var/sites and creates
# new virtual host for that site. With the options a site can also
# install the latest version of Laravel directly.
# This script was originally based on the following script by @Nek from
# Coderwall: https://coderwall.com/p/cqoplg
if [[ $1 == "--url" && $# -eq 1 ]] || [[ $# -eq 0 ]]; then
	echo "this script need a argument "
	exit 1
fi
# Display the usage information of the command.
create-project-usage() {
cat <<"USAGE"
Usage: create-project [OPTIONS] <name>
	-v, --vhost       Create a vhost for project
	-c, --clone       Clone a git repository from url
	-h, --help        Show this help screen
	-u, --url         Specify a local address, default is http://name.it
	-r, --remove      Remove a Virtual Host
	--list            List the current virtual host


Examples:

	create-project symfony
	create-project --url symfony.es
	create-project --remove symfony.es
USAGE
exit 0
}

# Remove a project and its Virtual Host.
project-remove() {
	echo "Removing $url from /etc/hosts."

	cp /etc/hosts ~/hosts.new
  sed -i '/'$url'/d' ~/hosts.new
  cp -f ~/hosts.new /etc/hosts

	echo "Disabling and deleting the $name virtual host."
	a2dissite $name
	rm /etc/apache2/sites-available/$name.conf
	service apache2 restart
	# delete root directory
	if [ -d "$docroot" ]; then
    rm -r /var/www/projects/$name
    echo "Project has been removed."
	fi
	exit 0
}

# Clone a project from a git repository
clone-project() {
	echo "cloning project...: "$url
	git clone $url $repo
	exit 0
}

# Create a vhost
create-vhost() {
  root="$docroot/public"
  log_error="$docroot/var/log/apache_error.log"
	echo "create vhost for project...: "$url

	echo -e "\nCreating the new $name Virtual Host with DocumentRoot: $root"

	cp /etc/apache2/sites-available/template /etc/apache2/sites-available/$name.conf
	sed -i 's/template.email/'$email'/g' /etc/apache2/sites-available/$name.conf
	sed -i 's/template.url/'$url'/g' /etc/apache2/sites-available/$name.conf
	sed -i 's#template.docroot#'$root'#g' /etc/apache2/sites-available/$name.conf
	sed -i 's#template.error#'$log_error'#g' /etc/apache2/sites-available/$name.conf

	echo "Adding $url to the /etc/hosts file..."

	# http://blog.jonathanargentiero.com/docker-sed-cannot-rename-etcsedl8ysxl-device-or-resource-busy/
	cp /etc/hosts ~/hosts.new
	sed -i '1s/^/127.0.0.1       '$url'\n/' ~/hosts.new
	cp -f ~/hosts.new /etc/hosts

	a2ensite $name
	service apache2 restart

	echo -e "\nYou can now browse to your Virtual Host at http://$url"

	exit 0
}

# List the available and enabled virtual hosts.
project-list() {
	echo "Available virtual hosts:"
	ls -l /etc/apache2/sites-available/
	echo "Enabled virtual hosts:"
	ls -l /etc/apache2/sites-enabled/
	exit 0
}

# Define and create default values.
name="${!#}"
repo="/var/www/projects/$3"
email="webmaster@localhost"
url="$name.it"
docroot="/var/www/projects/$name"

# Loop to read options and arguments.
while [ $1 ]; do
	case "$1" in
		'--vhost'|'-v')
			url="$2"
			create-vhost;;
		'--clone'|'-c')
			url="$2"
			clone-project;;
		'--list')
			project-list;;
		'--help'|'-h')
			create-project-usage;;
		'--remove'|'-r')
			url="$2"
			project-remove;;
		'--url'|'-u')
			url="$2"

	esac
	shift
done

# Check if the docroot exists, if it does not exist then we'll create it.
if [ ! -d "$docroot" ]; then
	echo "Creating $docroot project..."
   	symfony new --dir=$docroot --version=5.4.*
    log_error="$docroot/var/log/apache_error.log"
    root="$docroot/public"
    chmod +rwx docroot
fi

echo -e "\nCreating the new $name Virtual Host with DocumentRoot: $root"

cp /etc/apache2/sites-available/template /etc/apache2/sites-available/$name.conf
sed -i 's/template.email/'$email'/g' /etc/apache2/sites-available/$name.conf
sed -i 's/template.url/'$url'/g' /etc/apache2/sites-available/$name.conf
sed -i 's#template.docroot#'$root'#g' /etc/apache2/sites-available/$name.conf
sed -i 's#template.error#'$log_error'#g' /etc/apache2/sites-available/$name.conf

echo "Adding $url to the /etc/hosts file..."

# http://blog.jonathanargentiero.com/docker-sed-cannot-rename-etcsedl8ysxl-device-or-resource-busy/
cp /etc/hosts ~/hosts.new
sed -i '1s/^/127.0.0.1       '$url'\n/' ~/hosts.new
cp -f ~/hosts.new /etc/hosts

a2ensite $name
service apache2 restart

echo -e "\nYou can now browse to your Virtual Host at http://$url"

exit 0