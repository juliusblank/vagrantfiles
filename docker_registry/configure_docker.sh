#!/bin/bash

# This script configures the docker daemon in the guest system to allow connections to the insecure
# registry running on 192.168.0.16:5000
# It therefore adds $insec_reg_option to the file /etc/default/docker (if not present) and restarts te daemon

# TODO In case Vagrant did not modify the /etc/default/docker yet, this won't work. Only if Vagrant sets
# value(s) that go into the DOCKER_OPTS in that file, this script will work, as otherwise the line in the
# file won't be active. It is ok as of now, as we always at least set the $no_proxy env var.

insec_reg_option="--insecure-registry=192.168.0.16:5000"
file_content=$(</etc/default/docker)
# see stackoverflow.com/questions/2829613
if test "${file_content#*$insec_reg_option}" == "$file_content"
then
  echo "no --insecure-registry found in /etc/default/docker of guest box. Will add one..."
  service docker stop
  sed -i 's/ ${DOCKER_OPTS}/ --insecure-registry=192.168.0.16:5000 ${DOCKER_OPTS}/' /etc/default/docker
  service docker start
fi

