FROM node:14-buster

# Install useful tools and install important libaries
RUN apt-get -y update && \
    apt-get -y install php

# Other PHP7 Extensions
RUN npm install -g gulp-cli && \
    npm install -g sass-migrator 
