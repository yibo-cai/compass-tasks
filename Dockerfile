from centos:latest

# repos
COPY misc/compass_install.repo /etc/yum.repos.d/compass_install.repo

RUN rpm -Uvh https://dl.fedoraproject.org/pub/epel/epel-release-latest-7.noarch.rpm && \
    sed -i 's/^mirrorlist=https/mirrorlist=http/g' /etc/yum.repos.d/epel.repo && \
    yum update -y

# packages
RUN yum --enablerepo=compass_install --nogpgcheck install -y python python-devel git amqp python-pip libffi-devel openssl-devel gcc python-setuptools MySQL-python supervisor redis sshpass python-keyczar vim ansible-2.2.1.0

# code
RUN mkdir -p /root/compass-tasks
COPY . /root/compass-tasks
RUN mkdir -p /root/compass-tasks/compass && \
    touch /root/compass-tasks/compass/__init__.py
RUN mv /root/compass-tasks/actions /root/compass-tasks/compass/ && \
    mv /root/compass-tasks/apiclient /root/compass-tasks/compass/ && \
    mv /root/compass-tasks/tasks /root/compass-tasks/compass/ && \
    mv /root/compass-tasks/utils /root/compass-tasks/compass/ && \
    mv /root/compass-tasks/deployment /root/compass-tasks/compass/ && \
    mv /root/compass-tasks/db /root/compass-tasks/compass/ && \
    mv /root/compass-tasks/hdsdiscovery /root/compass-tasks/compass/ && \
    mv /root/compass-tasks/log_analyzor /root/compass-tasks/compass/

# pip
RUN easy_install --upgrade pip && \
    pip install --upgrade pip && \
    pip install --upgrade setuptools && \
    pip install --upgrade Flask

# conf
RUN mkdir -p /etc/compass/ && \
    mkdir -p /etc/compass/machine_list && \
    mkdir -p /etc/compass/switch_list && \
    #cp -rf /root/compass-tasks/conf/* /etc/compass/ && \
    cd /root/compass-tasks && \
    python setup.py install

RUN mkdir -p /root/.ssh; \
    echo "UserKnownHostsFile /dev/null" >> /root/.ssh/config; \
    echo "StrictHostKeyChecking no" >> /root/.ssh/config

COPY supervisord.conf /etc/supervisord.conf
COPY start.sh /usr/local/bin/start.sh
RUN mkdir -p /var/log/compass
RUN mkdir -p /opt/ansible_callbacks
#RUN git clone https://github.com/openstack-ansible/openstack-ansible-modules /opt/openstack-ansible-modules
EXPOSE 6379
VOLUME ["/var/ansible", "/etc/compass/machine_list", "/etc/compass/switch_list"]
ENTRYPOINT ["/bin/bash", "-c"]
CMD ["/usr/local/bin/start.sh"]
