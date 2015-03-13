#!/bin/bash
echo Checking the variables are OK...
if [ ! -f $GIT_REPO/src/index.php ]; then
	echo The supplied GIT_REPO variable: $GIR_REPO is not a valid SSG repo
	exit 1
fi

if [ ! "$(ls $DEPLOY_DIR)" ]; then
	if [ -e $DEPLOY_DIR/src/index.php ]; then
		echo The supplied DEPLOY_DIR variable: $DEPLOY_DIR is not a valid target
		echo It is not empty and does not already contain a deployment
		exit 1
	fi
fi

echo Setting up apache
sudo a2enmod rewrite
sudo service apache2 restart

printf "\n"
echo Getting the latest source from the repo
cd $GIT_REPO
git checkout -f $GIT_BRANCH
git fetch
git pull
rm -fR $DEPLOY_DIR/*
rm -fR $DEPLOY_DIR/.??*

printf "\n"
echo Checking out the latest source to the deploy directory
git --work-tree=$DEPLOY_DIR checkout -f $GIT_BRANCH
cd $DEPLOY_DIR

printf "\n"
echo Updating composer dependencies
composer update

printf "\n"
echo Installing composer dependencies
composer install --prefer-source --no-interaction

printf "\n"
echo Setting permissions
chmod -R 757 $DEPLOY_DIR

printf "\n"
echo Checking the database exists
#mysql -u$MYSQL_USER -p$MYSQL_PASSWORD --execute 'CREATE DATABASE IF NOT EXISTS `db_name`'

printf "\n"
echo Importing dev mysql info
#mysql -u$MYSQL_USER -p$MYSQL_PASSWORD db_name < dev_db_dump.sql

printf "\n"
echo Renaming variables
#sed -i "s/getenv('MYSQL_USER')/'$MYSQL_USER'/g" $DEPLOY_DIR/src/app/lib/dbConnection.php

printf "\n"
echo Making Slim a production instance
sed -i "s/'mode' => 'development'/'mode' => 'production'/g" $DEPLOY_DIR/src/index.php
sed -i "s/'debug' => true/'debug' => false/g" $DEPLOY_DIR/src/index.php



printf "\n"
echo Minifying JS Scripts for deploy
yui-compressor -o '.js$:.js' $DEPLOY_DIR/src/js/*.js

printf "\n"
echo Minifying JS Modules for dpeloy
yui-compressor -o '.js$:.js' $DEPLOY_DIR/src/js/modules/*.js

printf "\n"
echo Minifying CSS for deploy
yui-compressor -o '.css$:.css' $DEPLOY_DIR/src/css/*.css

printf "\n"
echo Minifying CSS Layouts for deploy
yui-compressor -o '.css$:.css' $DEPLOY_DIR/src/css/layouts/*.css
