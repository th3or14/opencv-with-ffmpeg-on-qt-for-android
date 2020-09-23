#!/bin/bash

DOCKER_IMAGE_NAME="android-opencv-builder:latest"
if [[ "$(docker images -q $DOCKER_IMAGE_NAME 2> /dev/null)" == "" ]]; then
  docker build -t $DOCKER_IMAGE_NAME ./docker
fi

docker run -u $UID:$UID --env HOME=$HOME -v /etc/passwd:/etc/passwd:ro -v /etc/group:/etc/group:ro --tmpfs $HOME:uid=$UID,gid=$UID -v $PWD:$PWD -w $PWD --rm $DOCKER_IMAGE_NAME ./build-wrapper.sh
