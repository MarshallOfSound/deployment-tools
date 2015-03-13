#!/bin/bash
printf "\n"
echo Preparing for deployment
OLD='DocumentRoot '$DEPLOY_DIR'/src'
NEW='DocumentRoot '$DIR'/deployment_in_progress'
sudo sed -i "s=$OLD=$NEW=g" /etc/apache2/sites-available/000-default.conf
sudo service apache2 restart
