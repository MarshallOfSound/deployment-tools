#!/bin/bash
DIR=$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )

$DIR/vars.sh

export DEPLOY_DIR=$DEPLOY_DIR/beta_deploy

function finish {
	/var/www/ssg/post_deploy.sh
}

$DIR/pre_deploy.sh
$DIR/run_deploy.sh

trap finish EXIT
