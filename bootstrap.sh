#!/bin/bash
set -x

# Dependencies
apt install -y software-properties-common
apt install -y python-software-properties
apt install -y curl

# Python 3.6
add-apt-repository -y ppa:jonathonf/python-3.6

# Rethinkdb
curl -fsSL https://download.rethinkdb.com/apt/pubkey.gpg | apt-key add -
echo "deb http://download.rethinkdb.com/apt xenial main" | tee /etc/apt/sources.list.d/rethinkdb.list

# Docker
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | apt-key add -
add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable"

# Saltstack
curl -fsSL https://repo.saltstack.com/apt/ubuntu/16.04/amd64/latest/SALTSTACK-GPG-KEY.pub | apt-key add -
add-apt-repository "deb http://repo.saltstack.com/apt/ubuntu/16.04/amd64/latest xenial main"

# Install
apt update
apt install -y unzip
apt install -y apt-transport-https
apt install -y docker-ce
apt install -y rethinkdb
apt install -y python3.6
apt install -y python3.6-dev
apt install -y build-essential
apt install -y python3-distutils
apt install -y salt-master salt-minion

# Compose
curl -Ls https://github.com/docker/compose/releases/download/1.21.2/docker-compose-`uname -s`-`uname -m` -o /usr/local/bin/docker-compose
chmod +x /usr/local/bin/docker-compose

# Terraform
curl -sL https://releases.hashicorp.com/terraform/0.11.7/terraform_0.11.7_linux_amd64.zip
unzip terraform_0.11.7_linux_amd64.zip
mv terraform /usr/bin/terraform
rm -rf terraform_0.11.7_linux_amd64.zip

# Nomad
curl -Ls https://releases.hashicorp.com/nomad/0.8.3/nomad_0.8.3_linux_amd64.zip -o /tmp/nomad.zip
unzip /tmp/nomad.zip -d /tmp/nomad
mv /tmp/nomad/nomad /usr/local/bin/nomad
chmod +x /usr/local/bin/nomad

# Pip
curl -s https://bootstrap.pypa.io/get-pip.py | python -
curl -s https://bootstrap.pypa.io/get-pip.py | python3 -
curl -s https://bootstrap.pypa.io/get-pip.py | python3.6 -

# Pipenv
python3.6 -m pip install pipenv

# Saltstack config
service salt-master stop
service salt-minion stop

tee /etc/salt/master.d/default.conf << END
file_roots:
  base:
    - /vagrant/salt
log_level: debug
auto_accept: True
END

service salt-master start

tee /etc/salt/minion.d/default.conf << END
master: 127.0.0.1
log_level: debug
END

service salt-minion start

# RethinkDB config
tee /etc/rethinkdb/instances.d/rethinkdb.conf <<EOF
runuser=root
rungroup=root
bind=0.0.0.0
driver-port=28015
http-port=28010
EOF

service rethinkdb restart

# Environment variables
cat > /etc/environment <<EOL
PATH="/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin:/usr/games:/usr/local/games"
VIRTUALENV_ALWAYS_COPY=1
PIPENV_VENV_IN_PROJECT=1
PIPENV_IGNORE_VIRTUALENVS=1
EOL
set +x
