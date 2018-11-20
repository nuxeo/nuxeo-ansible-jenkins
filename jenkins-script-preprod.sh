#!/bin/bash -xe

docker login dockerpriv.nuxeo.com:443 -u $JUSER -p $JPASS

echo CLEANUP
docker kill slave-common-preprod slave-pub-preprod slave-priv-preprod || true
docker rm -v slave-common-preprod slave-pub-preprod slave-priv-preprod || true

docker rmi dockerpriv.nuxeo.com:443/nuxeo/jenkins-slavepriv || true
docker rmi dockerpriv.nuxeo.com:443/nuxeo/jenkins-check || true
docker rmi dockerpriv.nuxeo.com:443/nuxeo/jenkins-ondemand || true
docker rmi dockerpriv.nuxeo.com:443/nuxeo/jenkins-multidb || true
docker rmi dockerpriv.nuxeo.com:443/nuxeo/jenkins-it || true
docker rmi dockerpriv.nuxeo.com:443/nuxeo/jenkins-itpriv || true
docker rmi dockerpriv.nuxeo.com:443/nuxeo/jenkins-slave || true
docker rmi dockerpriv.nuxeo.com:443/nuxeo/jenkins-swarm || true
docker rmi nuxeo/jenkins-priv:preprod || true
docker rmi nuxeo/jenkins-pub:preprod || true
docker rmi nuxeo/jenkins-common:preprod || true
docker rmi nuxeo/jenkins-base:preprod || true
docker rmi nuxeo/jenkins-swarm:preprod || true
docker images -a -q |xargs docker rmi -f || true
docker image prune -f

echo BUILDING jenkins-base...
cp ~/.ssh/id_rsa.pub docker/base/files/id_rsa.pub
docker build -t nuxeo/jenkins-base:preprod docker/base

echo BUILDING preprod slaves...
rm -rf venv
virtualenv venv
. venv/bin/activate
pip install --upgrade setuptools
pip install markupsafe
pip install ansible==2.2.0
pip install boto
pip install --upgrade awscli

docker run -d -t -i --add-host unicode.org:164.132.165.173 -p 127.0.0.1:3232:22 --name=slave-common-preprod nuxeo/jenkins-base:preprod
ansible-playbook -i inventory/slave-common/hosts -e "ssh_port=3232" --ssh-extra-args="-p 3232" slave-common.yml
docker commit slave-common-preprod nuxeo/jenkins-common:preprod
docker kill slave-common-preprod
docker rm -v slave-common-preprod

docker run -d -t -i --add-host unicode.org:164.132.165.173 -p 127.0.0.1:4232:22 --name=slave-pub-preprod nuxeo/jenkins-common:preprod
ansible-playbook -i inventory/slave-pub/hosts -e "ssh_port=4232" --ssh-extra-args="-p 4232" slave-pub.yml -v
docker commit slave-pub-preprod nuxeo/jenkins-pub:preprod
docker kill slave-pub-preprod
docker rm -v slave-pub-preprod

docker run -d -t -i --add-host unicode.org:164.132.165.173 -p 127.0.0.1:5232:22 --name=slave-priv-preprod nuxeo/jenkins-common:preprod
ansible-playbook -i inventory/slave-priv/hosts -e "ssh_port=5232" --ssh-extra-args="-p 5232" slave-priv.yml -v
docker commit slave-priv-preprod nuxeo/jenkins-priv:preprod
docker kill slave-priv-preprod
docker rm -v slave-priv-preprod

docker tag nuxeo/jenkins-pub:preprod dockerpriv.nuxeo.com:443/nuxeo/jenkins-slave:preprod
docker tag nuxeo/jenkins-priv:preprod dockerpriv.nuxeo.com:443/nuxeo/jenkins-slavepriv:preprod

docker push dockerpriv.nuxeo.com:443/nuxeo/jenkins-slave:preprod
docker push dockerpriv.nuxeo.com:443/nuxeo/jenkins-slavepriv:preprod

# Pull back the remote IDs
docker pull dockerpriv.nuxeo.com:443/nuxeo/jenkins-slave:preprod
docker pull dockerpriv.nuxeo.com:443/nuxeo/jenkins-slavepriv:preprod

# Docker swarm image NXBT-1770 TestAndPush
docker build -t nuxeo/jenkins-swarm:preprod docker/swarm/
docker tag nuxeo/jenkins-swarm:preprod dockerpriv.nuxeo.com:443/nuxeo/jenkins-swarm:preprod
docker push dockerpriv.nuxeo.com:443/nuxeo/jenkins-swarm:preprod
docker pull dockerpriv.nuxeo.com:443/nuxeo/jenkins-swarm:preprod

docker images dockerpriv.nuxeo.com:443/nuxeo/*:preprod -f "since=nuxeo/jenkins-base" --format "{{.ID}} {{.Repository}}:{{.Tag}}" |tee images.list
