#!/bin/bash

installCurl()
{
    if ! dpkg -s curl > /dev/null; then

        echo
        echo '------------ Installing "curl package"  ------------'
        echo

        sudo apt-get update > /dev/null
        sudo apt-get -y install curl
    fi
}

installPythonSoftwareProperties()
{
    if ! dpkg -s python-software-properties > /dev/null; then

        echo
        echo '------------ Installing "python-software-properties package" ------------'
        echo

        sudo apt-get update > /dev/null
        sudo apt-get -y install python-software-properties

    fi
}

installOracleJava7()
{
    if ! dpkg -s oracle-java7-installer > /dev/null; then
        
        echo
        echo '------------ Installing "oracle-java7-installer package" [it gonna take ages]  ------------'
        echo
        
        echo | sudo apt-add-repository ppa:webupd8team/java
        sudo add-apt-repository -y ppa:webupd8team/java 
        
        sudo apt-get -q -y update > /dev/null
        
        sudo sh -c "echo debconf shared/accepted-oracle-license-v1-1 select true | debconf-set-selections"
        sudo sh -c "echo debconf shared/accepted-oracle-license-v1-1 seen true | debconf-set-selections"
        
        sudo apt-get -y install oracle-java7-installer 
        
        sudo sh -c "echo -e "\n\nJAVA_HOME=/usr/lib/jvm/java-7-oracle" >> /etc/environment;"
        
    fi
}

installElasticSearch()
{
    if ! dpkg -s elasticsearch > /dev/null; then

        echo
        echo '------------ Installing "elasticsearch package"  ------------'
        echo

        wget $BS_ES_PACKAGE_URL
        sudo dpkg -i $BS_ES_PACKAGE_NAME
        sudo rm $BS_ES_PACKAGE_NAME
    fi
}

transportCustomLoggingConf()
{
    if [ ! -f $BS_ES_PATH_CONF/logging.yml ] && [ -f $BS_ROOT_DIRECTORY/etc/elasticsearch/logging.yml ]; then

        sudo cp $BS_ROOT_DIRECTORY/etc/elasticsearch/logging.yml $BS_ES_PATH_CONF

    elif [ -f $BS_ES_PATH_CONF/logging.yml ] && [ -f $BS_ROOT_DIRECTORY/etc/elasticsearch/logging.yml ]; then

        local destFile=$(sudo md5sum $BS_ES_PATH_CONF/logging.yml)
        local srcFile=$(sudo md5sum $BS_ROOT_DIRECTORY/etc/elasticsearch/logging.yml)

        if [ "$destFile" != "$srcFile" ]; then
            sudo cp $BS_ROOT_DIRECTORY/etc/elasticsearch/logging.yml $BS_ES_PATH_CONF
        fi

    elif [ ! -f $BS_ROOT_DIRECTORY/etc/elasticsearch/logging.yml ]; then

        echo "Error: $BS_ROOT_DIRECTORY/etc/elasticsearch/logging.yml doesn't exists"
        exit 0
    fi
}

transportCustomElasticSearchConf()
{
    if [ ! -f $BS_ES_PATH_CONF/elasticsearch.yml ] && [ -f $BS_ROOT_DIRECTORY/etc/elasticsearch/elasticsearch.yml ]; then

        sudo cp $BS_ROOT_DIRECTORY/etc/elasticsearch/elasticsearch.yml $BS_ES_PATH_CONF

    elif [ -f $BS_ES_PATH_CONF/elasticsearch.yml ] && [ -f $BS_ROOT_DIRECTORY/etc/elasticsearch/elasticsearch.yml ]; then

        local destFile=$(sudo md5sum $BS_ES_PATH_CONF/elasticsearch.yml)
        local srcFile=$(sudo md5sum $BS_ROOT_DIRECTORY/etc/elasticsearch/elasticsearch.yml)

        if [ "$destFile" != "$srcFile" ]; then
            sudo cp $BS_ROOT_DIRECTORY/etc/elasticsearch/elasticsearch.yml $BS_ES_PATH_CONF
        fi

    elif [ ! -f $BS_ROOT_DIRECTORY/etc/elasticsearch/elasticsearch.yml ]; then

        echo "Error: $BS_ROOT_DIRECTORY/etc/elasticsearch/elasticsearch.yml doesn't exists"
        exit 0;
    fi
}

startElasticSearch()
{
    echo
    echo '------------ Running ElasticSearch HELL YEAH!:D  ------------'
    echo

    sudo /usr/share/elasticsearch/bin/elasticsearch -f -Des.config=$BS_ES_PATH_CONF/elasticsearch.yml
}