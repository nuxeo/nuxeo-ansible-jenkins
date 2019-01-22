#!/bin/bash -ex
#
# Copy from https://qa.nuxeo.org/jenkins/job/System/job/build-slave-images/
exit 1

docker login dockerpriv.nuxeo.com:443 -u $JUSER -p $JPASS

echo CLEANUP
docker kill slave-common slave-pub slave-priv || true
docker rm -v slave-common slave-pub slave-priv || true

docker rmi dockerpriv.nuxeo.com:443/nuxeo/jenkins-slavepriv || true
docker rmi dockerpriv.nuxeo.com:443/nuxeo/jenkins-check || true
docker rmi dockerpriv.nuxeo.com:443/nuxeo/jenkins-ondemand || true
docker rmi dockerpriv.nuxeo.com:443/nuxeo/jenkins-multidb || true
docker rmi dockerpriv.nuxeo.com:443/nuxeo/jenkins-it || true
docker rmi dockerpriv.nuxeo.com:443/nuxeo/jenkins-itpriv || true
docker rmi dockerpriv.nuxeo.com:443/nuxeo/jenkins-slave || true
docker rmi nuxeo/jenkins-priv || true
docker rmi nuxeo/jenkins-pub || true
docker rmi nuxeo/jenkins-common || true
docker rmi nuxeo/jenkins-base || true
docker images dockerpriv.nuxeo.com:443/nuxeo/* -f "dangling=true" -q | sort -u | xargs -r docker rmi -f


echo BUILDING jenkins-base...
cp ~/.ssh/id_rsa.pub docker/base/files/
docker build -t nuxeo/jenkins-base docker/base

echo BUILDING slaves
rm -rf venv
virtualenv venv
. venv/bin/activate
pip install --upgrade setuptools
pip install markupsafe
pip install ansible==2.2.0
pip install boto
pip install --upgrade awscli

docker run -d -t -i --add-host unicode.org:164.132.165.173 -p 127.0.0.1:2222:22 --name=slave-common nuxeo/jenkins-base
ansible-playbook -i inventory/slave-common/hosts slave-common.yml -v
docker commit slave-common nuxeo/jenkins-common
docker kill slave-common
docker rm -v slave-common

docker run -d -t -i --add-host unicode.org:164.132.165.173 -p 127.0.0.1:2223:22 --name=slave-pub nuxeo/jenkins-common
ansible-playbook -i inventory/slave-pub/hosts slave-pub.yml -v
docker commit slave-pub nuxeo/jenkins-pub
docker kill slave-pub
docker rm -v slave-pub

docker run -d -t -i --add-host unicode.org:164.132.165.173 -p 127.0.0.1:2224:22 --name=slave-priv nuxeo/jenkins-common
ansible-playbook -i inventory/slave-priv/hosts slave-priv.yml -v
docker commit slave-priv nuxeo/jenkins-priv
docker kill slave-priv
docker rm -v slave-priv


docker tag nuxeo/jenkins-pub dockerpriv.nuxeo.com:443/nuxeo/jenkins-slave
docker tag nuxeo/jenkins-pub dockerpriv.nuxeo.com:443/nuxeo/jenkins-it
docker tag nuxeo/jenkins-pub dockerpriv.nuxeo.com:443/nuxeo/jenkins-multidb
docker tag nuxeo/jenkins-pub dockerpriv.nuxeo.com:443/nuxeo/jenkins-ondemand
docker tag nuxeo/jenkins-pub dockerpriv.nuxeo.com:443/nuxeo/jenkins-check
docker tag nuxeo/jenkins-priv dockerpriv.nuxeo.com:443/nuxeo/jenkins-slavepriv
docker tag nuxeo/jenkins-priv dockerpriv.nuxeo.com:443/nuxeo/jenkins-itpriv

docker push dockerpriv.nuxeo.com:443/nuxeo/jenkins-slave
docker push dockerpriv.nuxeo.com:443/nuxeo/jenkins-it
docker push dockerpriv.nuxeo.com:443/nuxeo/jenkins-itpriv
docker push dockerpriv.nuxeo.com:443/nuxeo/jenkins-multidb
docker push dockerpriv.nuxeo.com:443/nuxeo/jenkins-ondemand
docker push dockerpriv.nuxeo.com:443/nuxeo/jenkins-check
docker push dockerpriv.nuxeo.com:443/nuxeo/jenkins-slavepriv

# Pull back the remote IDs
docker pull dockerpriv.nuxeo.com:443/nuxeo/jenkins-slave
docker pull dockerpriv.nuxeo.com:443/nuxeo/jenkins-it
docker pull dockerpriv.nuxeo.com:443/nuxeo/jenkins-itpriv
docker pull dockerpriv.nuxeo.com:443/nuxeo/jenkins-multidb
docker pull dockerpriv.nuxeo.com:443/nuxeo/jenkins-ondemand
docker pull dockerpriv.nuxeo.com:443/nuxeo/jenkins-check
docker pull dockerpriv.nuxeo.com:443/nuxeo/jenkins-slavepriv


docker images dockerpriv.nuxeo.com:443/nuxeo/* -f "dangling=true" -q | sort -u | xargs -r docker rmi -f

docker images dockerpriv.nuxeo.com:443/nuxeo/*:latest -f "since=nuxeo/jenkins-base" --format "{{.ID}} {{.Repository}}:{{.Tag}}" |tee images.list
