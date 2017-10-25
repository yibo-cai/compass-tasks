#!/bin/bash
##############################################################################
# Copyright (c) 2016-2017 HUAWEI TECHNOLOGIES CO.,LTD and others.
#
# All rights reserved. This program and the accompanying materials
# are made available under the terms of the Apache License, Version 2.0
# which accompanies this distribution, and is available at
# http://www.apache.org/licenses/LICENSE-2.0
##############################################################################
set -x
COMPASS_DIR=${BASH_SOURCE[0]%/*}

rpm -Uvh https://dl.fedoraproject.org/pub/epel/epel-release-latest-7.noarch.rpm
sed -i 's/^mirrorlist=https/mirrorlist=http/g' /etc/yum.repos.d/epel.repo
yum update -y

yum --nogpgcheck install -y python python-devel git amqp python-pip libffi-devel openssl-devel gcc python-setuptools MySQL-python supervisor redis sshpass python-keyczar vim ansible-2.2.1.0 libyaml-devel make

mkdir -p $COMPASS_DIR/compass
touch $COMPASS_DIR/compass/__init__.py
mv $COMPASS_DIR/{actions,apiclient,tasks,utils,deployment,db,hdsdiscovery,log_analyzor} \
$COMPASS_DIR/compass/

easy_install --upgrade pip
pip install --upgrade pip
pip install --upgrade setuptools
pip install --upgrade Flask

mkdir -p /etc/compass/
mkdir -p /etc/compass/machine_list
mkdir -p /etc/compass/switch_list
mkdir -p /var/log/compass
mkdir -p /opt/ansible_callbacks
mkdir -p /root/.ssh;
echo "UserKnownHostsFile /dev/null" >> /root/.ssh/config;
echo "StrictHostKeyChecking no" >> /root/.ssh/config

cd $COMPASS_DIR
python setup.py install
cp supervisord.conf /etc/supervisord.conf
cp start.sh /usr/local/bin/start.sh

yum clean all

set -x
