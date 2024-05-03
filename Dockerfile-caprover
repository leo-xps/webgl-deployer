# Multi-stage
# 1) Unrar
# 2) nginx stage to serve frontend assets

# ====================== STAGE 1

# Name the node stage "builder"
FROM ubuntu:bionic AS builder

RUN apt-get update && \
apt-get install -y unrar jq

# Set working directory
WORKDIR /unrarfolder
COPY version ./
ADD https://www.google.com /time.now
ADD https://minio-api.int2.lv-aws-x3.xyzapps.xyz/landvault-deployments/virtualhq/mobile/WebGL.rar ./WebGL.rar
RUN chmod +x ./WebGL.rar
RUN ls -la
RUN unrar x WebGL.rar /unrarfolder/
# delete all rar parts
RUN rm WebGL.rar

ARG DATA_SERVER
ARG GAME_SERVER

COPY DeploymentConfig.json /unrarfolder/WebGL/StreamingAssets/DeploymentConfig.json

# echo DATA_SERVER in dockerfile
ARG DATA_SERVER
ARG DATA_SERVER_ROOT
ARG GAME_SERVER

COPY DeploymentConfig.json /unrarfolder/WebGL/StreamingAssets/DeploymentConfig.json

# echo DATA_SERVER in dockerfile
RUN echo $DATA_SERVER
RUN echo $DATA_SERVER_ROOT
RUN echo $GAME_SERVER

# Create a new DeploymentConfig.json file with the new values
RUN jq --arg DATA_SERVER "$DATA_SERVER" '.Backend = $DATA_SERVER' /unrarfolder/WebGL/StreamingAssets/DeploymentConfig.json > tmp.$$.json && mv tmp.$$.json /unrarfolder/WebGL/StreamingAssets/DeploymentConfig.json
RUN jq --arg GAME_SERVER "$GAME_SERVER" '.Server = $GAME_SERVER' /unrarfolder/WebGL/StreamingAssets/DeploymentConfig.json > tmp.$$.json && mv tmp.$$.json /unrarfolder/WebGL/StreamingAssets/DeploymentConfig.json

# Replace a string in /unrarfolder/WebGL/index.html
RUN sed -i "s/dmcc-be.int2.lv-aws-x3.xyzapps.xyz/$DATA_SERVER_ROOT/g" /unrarfolder/WebGL/index.html

# ====================== STAGE 2

# nginx state for serving content
FROM nginx:alpine

# Copy static assets from builder stage
WORKDIR /www
COPY --from=builder /unrarfolder/WebGL .

# Copy nginx config
WORKDIR /etc/nginx/conf.d
COPY webgl.conf default.conf

# Go back to static files window
WORKDIR /www
RUN ls -la