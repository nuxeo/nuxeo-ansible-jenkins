# Swarm 

Docker image based on `jenkins-slave` that embeds [jenkins-swarm-client](https://plugins.jenkins.io/swarm) 

It allows to declare a local machine as a Jenkins slave

## Build Image

`docker build -t nuxeo/swarm docker/swarm`

## Run image

`docker run -itd -e JENKINS_NAME=<Slave name> -e JENKINS_MASTER=<Master URL> -e JENKINS_API_TOKEN=<USER_TOKEN> -e JENKINS_USERNAME=<USERNAME> nuxeo/swarm`

`JENKINS_NAME`: Name of the slave to be registered in the given master

`JENKINS_MASTER`: URL of the Jenkins master

`JENKINS_API_TOKEN`: API TOKEN, browse $JENKINS_MASTER/me/configure

`JENKINS_USERNAME`: Username, browse $JENKINS_MASTER/me/configure

# Run swarm on host 

## Install launcher

`wget --no-cache -q -O - https://raw.githubusercontent.com/nuxeo/nuxeo-ansible-jenkins/feature-NXBT-2358-jenkins-swarm-installer/docker/swarm/files/swarm-installer.sh | env JENKINS_API_SECRET=your-secret sh`

## Adapt to your host

edit env, labels and options files to adapt to your needs in folder ~/swarm-client


## Launch it on demand

`~/swam-client/launcher.sh`

## Launch at boot

add the following line to your crontab

`@reboot /bin/bash -l -c $HOME/swarm-client/launcher.sh`
