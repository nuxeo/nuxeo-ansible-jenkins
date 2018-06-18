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

