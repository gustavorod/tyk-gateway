#!/bin/bash
set -e

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

export TYK_PMP_ANALYTICSSTORAGECONFIG_USERNAME=$redisUsername
export TYK_PMP_ANALYTICSSTORAGECONFIG_PASSWORD=$redisPassword
export TYK_PMP_ANALYTICSSTORAGECONFIG_HOST="${redisAddress[0]:-tyk-redis}"
export TYK_PMP_ANALYTICSSTORAGECONFIG_PORT="${redisAddress[1]:-6379}"

env

${PWD}/tyk-pump --conf=/opt/tyk-gateway/deployments/tyk-pump/pump.conf
