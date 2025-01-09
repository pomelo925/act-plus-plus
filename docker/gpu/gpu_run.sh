#!/bin/bash

###### Commands ######
export COMMAND="/bin/bash"
export DISPLAY=:0
#######################

xhost +local:docker

## Remove all containers under group actpp-gpu
# docker compose -p actpp-gpu down --volumes --remove-orphans

docker compose -p actpp-gpu up -d koch-actpp-gpu