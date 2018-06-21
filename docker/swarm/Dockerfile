#
# (C) Copyright 2018 Nuxeo (http://nuxeo.com/) and others.
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#
# Contributors:
#     slacoin
#     atimic
#


FROM dockerpriv.nuxeo.com:443/nuxeo/jenkins-slave
RUN wget https://maven.nuxeo.org/nexus/service/local/repositories/vendor-releases/content/org/jenkins-ci/plugins/swarm-client/3.12/swarm-client-3.12-remoting-2-59-2.jar -O /opt/jenkins/bin/swarm-client.jar
COPY ${SWARM:-.}/files/swarm.sh /opt/jenkins/bin/swarm-client.sh
RUN chmod +x /opt/jenkins/bin/swarm-client.sh
CMD [ "/sbin/my_init", "--", "/opt/jenkins/bin/swarm-client.sh" ]

