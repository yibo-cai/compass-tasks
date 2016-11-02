from centos:latest

# repos
COPY misc/compass_install.repo /etc/yum.repos.d/compass_install.repo

RUN rpm -Uvh https://dl.fedoraproject.org/pub/epel/epel-release-latest-7.noarch.rpm && \
    sed -i 's/^mirrorlist=https/mirrorlist=http/g' /etc/yum.repos.d/epel.repo && \
    yum update -y

# packages
RUN yum --enablerepo=compass_install --nogpgcheck install -y python python-devel git amqp python-setuptools python-pip

# code
RUN mkdir -p /root/compass-tasks
COPY . /root/compass-tasks
RUN mkdir -p /root/compass-tasks/compass && \
    touch /root/compass-tasks/compass/__init__.py && \
    mv /root/compass-tasks/{actions,tasks,utils,deployment} /root/compass-tasks/compass/

# pip
RUN easy_install --upgrade pip && \
    pip install --upgrade pip

# conf
RUN mkdir -p /etc/compass/ && \
    cp /root/compass-tasks/conf/celeryconfig /etc/compass/ && \
    cp /root/compass-tasks/conf/setting /etc/compass/ && \
    cd /root/compass-tasks && \
    python setup.py install

COPY start.sh /usr/local/bin/start.sh
VOLUME ["/var/ansible"]
ENTRYPOINT ["/bin/bash", "-c"]
CMD ["/usr/local/bin/start.sh"]
