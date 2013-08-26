#!/bin/bash

BS_SPATH=$(readlink -f "$0")

BS_ROOT_DIRECTORY=$(dirname "$BS_SPATH")

BS_ES_PACKAGE_NAME=elasticsearch-0.90.3.deb

BS_ES_PACKAGE_URL=https://download.elasticsearch.org/elasticsearch/elasticsearch/$BS_ES_PACKAGE_NAME

BS_ES_PATH_CONF=/etc/elasticsearch

if [ ! -f $BS_ROOT_DIRECTORY/options.sh ]; then
    echo "ERROR: $BS_ROOT_DIRECTORY/params.sh doesn't exists"
    exit 0
fi

if [ ! -f $BS_ROOT_DIRECTORY/services.sh ]; then
    echo "ERROR: $BS_ROOT_DIRECTORY/services.sh doesn't exists"
    exit 0
fi

source $BS_ROOT_DIRECTORY/options.sh
source $BS_ROOT_DIRECTORY/services.sh


#Installing dependencies
installCurl
installPythonSoftwareProperties
installOracleJava7

#installing and configuring elastic search
installElasticSearch
transportCustomLoggingConf
transportCustomElasticSearchConf

#run elasticsearch
startElasticSearch