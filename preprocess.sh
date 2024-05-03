#!/bin/bash

echo "Applying environment variables"

echo "DATA_SERVER: $DATA_SERVER"
echo "GAME_SERVER: $GAME_SERVER"
echo "DATA_SERVER_ROOT: $DATA_SERVER_ROOT"

jq --arg DATA_SERVER "$DATA_SERVER" '.Backend = $DATA_SERVER' /www/StreamingAssets/DeploymentConfig.json > tmp.$$.json && mv tmp.$$.json /www/StreamingAssets/DeploymentConfig.json
jq --arg GAME_SERVER "$GAME_SERVER" '.Server = $GAME_SERVER' /www/StreamingAssets/DeploymentConfig.json > tmp.$$.json && mv tmp.$$.json /www/StreamingAssets/DeploymentConfig.json

sed -i "s/dmcc-be.int2.lv-aws-x3.xyzapps.xyz/$DATA_SERVER_ROOT/g" /www/index.html

echo "Running nginx"

echo "Running PM2 Command"

# pm2-runtime pm2.json 

# run pm2-runtime with the pm2.json file in daemon mode
pm2-runtime start pm2.json