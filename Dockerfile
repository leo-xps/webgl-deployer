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

ARG DATA_SERVER_ROOT_TOCHANGE="virtualhq-be.int2.lv-aws-x3.xyzapps.xyz"
ARG DATA_SERVER_ROOT

ARG GAME_SERVER

# Server meta tags
ARG VARIABLE_TITLE=""
ARG VARIABLE_DESCRIPTION=""
ARG VARIABLE_KEYWORDS="meta, virtual, meeting"
ARG VARIABLE_ROBOTS="noindex, nofollow"
ARG VARIABLE_LANGUAGE="en"
ARG VARIABLE_OGTYPE="website"
ARG VARIABLE_OGLOCALE="en_CA"
ARG VARIABLE_OGTITLE=""
ARG VARIABLE_OGURL=""
ARG VARIABLE_OGIMAGE=""
ARG VARIABLE_OGSITENAME=""
ARG VARIABLE_OGDESCRIPTION=""
ARG VARIABLE_TWITTERCARD=""
ARG VARIABLE_TWITTERURL=""
ARG VARIABLE_TWITTERTITLE=""
ARG VARIABLE_TWITTERDESCRIPTION=""
ARG VARIABLE_TWITTERIMAGE=""
ARG VARIABLE_TWITTERSITE=""


# Create a new DeploymentConfig.json file with the new values
RUN jq --arg DATA_SERVER "$DATA_SERVER" '.Backend = $DATA_SERVER' /unrarfolder/WebGL/StreamingAssets/DeploymentConfig.json > tmp.$$.json && mv tmp.$$.json /unrarfolder/WebGL/StreamingAssets/DeploymentConfig.json
RUN jq --arg GAME_SERVER "$GAME_SERVER" '.Server = $GAME_SERVER' /unrarfolder/WebGL/StreamingAssets/DeploymentConfig.json > tmp.$$.json && mv tmp.$$.json /unrarfolder/WebGL/StreamingAssets/DeploymentConfig.json

# Replace a string in /unrarfolder/WebGL/index.html
RUN sed -i "s/$DATA_SERVER_ROOT_TOCHANGE/$DATA_SERVER_ROOT/g" /unrarfolder/WebGL/index.html

# Replace meta tags in /unrarfolder/WebGL/index.html
RUN sed -i "s/VARIABLE_TITLE/$VARIABLE_TITLE/g" /unrarfolder/WebGL/index.html
RUN sed -i "s/VARIABLE_DESCRIPTION/$VARIABLE_DESCRIPTION/g" /unrarfolder/WebGL/index.html
RUN sed -i "s/VARIABLE_KEYWORDS/$VARIABLE_KEYWORDS/g" /unrarfolder/WebGL/index.html
RUN sed -i "s/VARIABLE_ROBOTS/$VARIABLE_ROBOTS/g" /unrarfolder/WebGL/index.html
RUN sed -i "s/VARIABLE_LANGUAGE/$VARIABLE_LANGUAGE/g" /unrarfolder/WebGL/index.html
RUN sed -i "s/VARIABLE_OGTYPE/$VARIABLE_OGTYPE/g" /unrarfolder/WebGL/index.html
RUN sed -i "s/VARIABLE_OGLOCALE/$VARIABLE_OGLOCALE/g" /unrarfolder/WebGL/index.html
RUN sed -i "s/VARIABLE_OGTITLE/$VARIABLE_OGTITLE/g" /unrarfolder/WebGL/index.html
RUN sed -i "s/VARIABLE_OGURL/$VARIABLE_OGURL/g" /unrarfolder/WebGL/index.html
RUN sed -i "s/VARIABLE_OGIMAGE/$VARIABLE_OGIMAGE/g" /unrarfolder/WebGL/index.html
RUN sed -i "s/VARIABLE_OGSITENAME/$VARIABLE_OGSITENAME/g" /unrarfolder/WebGL/index.html
RUN sed -i "s/VARIABLE_OGDESCRIPTION/$VARIABLE_OGDESCRIPTION/g" /unrarfolder/WebGL/index.html
RUN sed -i "s/VARIABLE_TWITTERCARD/$VARIABLE_TWITTERCARD/g" /unrarfolder/WebGL/index.html
RUN sed -i "s/VARIABLE_TWITTERURL/$VARIABLE_TWITTERURL/g" /unrarfolder/WebGL/index.html
RUN sed -i "s/VARIABLE_TWITTERTITLE/$VARIABLE_TWITTERTITLE/g" /unrarfolder/WebGL/index.html
RUN sed -i "s/VARIABLE_TWITTERDESCRIPTION/$VARIABLE_TWITTERDESCRIPTION/g" /unrarfolder/WebGL/index.html
RUN sed -i "s/VARIABLE_TWITTERIMAGE/$VARIABLE_TWITTERIMAGE/g" /unrarfolder/WebGL/index.html
RUN sed -i "s/VARIABLE_TWITTERSITE/$VARIABLE_TWITTERSITE/g" /unrarfolder/WebGL/index.html

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
    