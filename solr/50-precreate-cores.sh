#!/bin/bash
#
# docker-entrypoint-initdb file for creating multiple solr cores
set -e

/opt/docker-solr/scripts/precreate-core hydra-development /myconfig
/opt/docker-solr/scripts/precreate-core hydra-test /myconfig
