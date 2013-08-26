#!/bin/bash

while getopts ":c:p:" opt; do
  case $opt in
    c)
        BS_ES_PATH_CONF=$OPTARG
      ;;
    p)
        BS_ES_PACKAGE_NAME=$OPTARG
      ;;
  esac
done