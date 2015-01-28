#!/bin/bash

# This script configures the docker daemon in the guest system to allow connections to the insecure
# registry running on 192.168.0.16:5000
# It therefore adds $insec_reg_option to the file /etc/default/docker (if not present) and restarts te daemon

# TODO In case Vagrant did not modify the /etc/default/docker yet, this won't work. Only if Vagrant sets
# value(s) that go into the DOCKER_OPTS in that file, this script will work, as otherwise the line in the
# file won't be active. It is ok as of now, as we always at least set the $no_proxy env var.

cleanup_containers() {
  echo "found `docker ps -q | wc -l` running containers. kill them..."
  docker kill `docker ps -q` > /dev/null 2>&1
  echo "cleanup `docker ps -aq | wc -l` old containers..."
  docker rm `docker ps -aq` > /dev/null 2>&1
}

cleanup_containers

echo "run docker registry container..."
docker run -d --name="docker-registry" -p 5000:5000 -e STORAGE_PATH=/registry -v /docker/registry:/registry registry

