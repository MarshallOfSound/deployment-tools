#!/bin/bash
printf "\n"
echo Cleaning up deployment
NEW='DocumentRoot '$DEPLOY_DIR'/src'
OLD='DocumentRoot '$DIR'/deployment_in_progress'
sudo sed -i "s=$OLD=$NEW=g" /etc/apache2/sites-available/000-default.conf
sudo service apache2 restart

printf "\n"
echo Done
printf "\n"
printf "##################################################\n"
echo Successfully deployed to the webserver
printf "##################################################\n"
printf "\n"
