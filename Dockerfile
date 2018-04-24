# docker run -v `pwd`/content/:/data/content/ -v `pwd`/config/config.default.js:/opt/raneto/example/config.default.js -p 3000:3000 -d appsecco/raneto
#
# Reference (https://github.com/sparkfabrik/docker-node-raneto)
# Using official node:slim from the dockerhub (https://hub.docker.com/_/node/)
FROM node:slim
MAINTAINER Madhu Akula <madhu@appsecco.com>

# Change the raneto version based on version you want to use
ENV RANETO_VERSION 0.16.0
ENV RANETO_INSTALL_DIR /opt/raneto

# Get Raneto from sources
RUN cd /tmp \
    && curl -SLO "https://github.com/gilbitron/Raneto/archive/$RANETO_VERSION.tar.gz" \
    && mkdir -p $RANETO_INSTALL_DIR \
    && tar -xzf "$RANETO_VERSION.tar.gz" -C $RANETO_INSTALL_DIR --strip-components=1 \
    && rm "$RANETO_VERSION.tar.gz"


# Installing dependencies
RUN npm install --global gulp-cli pm2

# Entering into the Raneto directory
WORKDIR $RANETO_INSTALL_DIR

# Installing Raneto
RUN npm install \
    && rm -f $RANETO_INSTALL_DIR/example/config.default.js \
    && gulp

# Exposed the raneto default port 3000
EXPOSE 3000

# Starting the raneto
CMD [ "pm2", "start", "/opt/raneto/example/server.js", "--name", "raneto", "--no-daemon" ]
