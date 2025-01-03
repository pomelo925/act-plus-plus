#!/bin/bash

###### Settings ######
export COMMAND="/bin/bash"
export DISPLAY=:0
#######################

xhost +local:docker
docker compose -p actpp-gpu down --volumes --remove-orphans
docker compose -p actpp-gpu up -d koch-actpp-gpu


