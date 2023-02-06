#!/bin/bash
set -e

# Mapping to Heroku port
export TYK_GW_LISTENPORT="${PORT:-8080}" 

# Set the delimiter
IFS='@'

#Read the split words into an array based on space delimiter
read -a redisInfo <<< "$REDISCLOUD_URL"

# Set delimiter
IFS=':'

#Read the split words into an array based on space delimiter
read -a redisCredentials <<< "${redisInfo[0]}"
read -a redisAddress <<< "${redisInfo[1]}"

redisUsername=${redisCredentials[1]:2}
redisPassword=${redisCredentials[2]}

export TYK_GW_STORAGE_USERNAME=$redisUsername
export TYK_GW_STORAGE_PASSWORD=$redisPassword
export TYK_GW_STORAGE_HOST="${redisAddress[0]:-localhost}"
export TYK_GW_STORAGE_PORT="${redisAddress[1]:-6379}"

env

${PWD}/tyk start --conf=/opt/tyk-gateway/deployments/tyk-gateway/tyk.conf
