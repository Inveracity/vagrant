#!/bin/bash

# Dependencies
apt install -y software-properties-common
apt install -y python-software-properties
apt install -y curl

# Python 3.8
add-apt-repository -y ppa:deadsnakes/ppa

# Docker
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | apt-key add -
add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable"

# Golang
add-apt-repository -y ppa:longsleep/golang-backports

# gcloud and kubectl
echo "deb http://packages.cloud.google.com/apt cloud-sdk-$(lsb_release -c -s) main" | sudo tee -a /etc/apt/sources.list.d/google-cloud-sdk.list
curl https://packages.cloud.google.com/apt/doc/apt-key.gpg | sudo apt-key add -

# Install
apt update
apt install -y unzip
apt install -y apt-transport-https
apt install -y docker-ce
apt install -y python3.8
apt install -y python3.8-distutils
apt install -y python3.8-dev
apt install -y build-essential
apt install -y golang-go
apt install -y google-cloud-sdk
apt install -y kubectl

# Compose
curl -Ls https://github.com/docker/compose/releases/download/1.25.4/docker-compose-`uname -s`-`uname -m` -o /usr/local/bin/docker-compose
chmod +x /usr/local/bin/docker-compose

# Pip
curl -s https://bootstrap.pypa.io/get-pip.py | python -
curl -s https://bootstrap.pypa.io/get-pip.py | python3 -
curl -s https://bootstrap.pypa.io/get-pip.py | python3.8 -

# Pipenv
python3.8 -m pip install pipenv

# Environment variables
cat > /etc/environment <<EOL
PATH="/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin:/usr/games:/usr/local/games"
VIRTUALENV_ALWAYS_COPY=1
PIPENV_VENV_IN_PROJECT=1
PIPENV_IGNORE_VIRTUALENVS=1
LC_ALL=C.UTF-8
LANG=C.UTF-8
EOL
