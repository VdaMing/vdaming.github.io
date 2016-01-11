#!/bin/bash

#install nvm to install node.js
wget -qO- https://raw.github.com/creationix/nvm/master/install.sh | sh

#install node.js
nvm install 4

#install hexo
npm install -g hexo-cli
