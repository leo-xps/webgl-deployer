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

# Break Cache
ADD https://www.google.com /time.now

# Download and Unpack build
ARG BUILD_URL
ADD $BUILD_URL ./WebGL.rar
RUN chmod +x ./WebGL.rar
RUN ls -la
RUN unrar x WebGL.rar /unrarfolder/

# delete all rar parts
RUN rm WebGL.rar

# echo DATA_SERVER in dockerfile
ARG DATA_SERVER
ARG DATA_SERVER_ROOT
ARG GAME_SERVER

ENV DATA_SERVER=$DATA_SERVER
ENV DATA_SERVER_ROOT=$DATA_SERVER_ROOT
ENV GAME_SERVER=$GAME_SERVER

COPY DeploymentConfig.json /unrarfolder/WebGL/StreamingAssets/DeploymentConfig.json

# ====================== STAGE 2

# nginx state for serving content
FROM sitespeedio/node:ubuntu-18.04-nodejs10.15.3
 
ARG DEBIAN_FRONTEND=NONINTERACTIVE
ARG DOCKER_VERSION=17.06.0-CE

RUN apt-get update && \
apt-get install -y unrar jq

RUN apt-get update && \
    apt-get install -y -q curl gnupg2
RUN curl http://nginx.org/keys/nginx_signing.key | apt-key add -

RUN apt-get update && \
    apt-get install -y -q nginx

# Copy static assets from builder stage
WORKDIR /www
COPY --from=builder /unrarfolder/WebGL .

# Copy nginx config
WORKDIR /etc/nginx/conf.d
COPY webgl.conf default.conf

RUN npm install pm2 -g


# Go back to static files window
WORKDIR /www
RUN ls -la

EXPOSE 443 80

COPY preprocess.sh ./preprocess.sh
COPY pm2.json ./pm2.json
COPY BOOT.SH ./BOOT.SH
CMD ["./preprocess.sh"]