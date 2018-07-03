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
RUN usermod -a -G ssl-cert jenkins 
COPY ${SWARM:-.}/files/swarm-installer.sh /tmp
RUN sudo -u jenkins /tmp/swarm-installer.sh /opt/jenkins
COPY ${SWARM:-.}/files/swarm-launcher.sh /etc/my_init.d/30-swarm-launcher.sh
# fix postgres
RUN rm -fr /etc/ssl/private && mkdir /etc/ssl/private && chmod 710 /etc/ssl/private && chown root:ssl-cert /etc/ssl/private && DEBIAN_FRONTEND="noninteractive" dpkg-reconfigure ssl-cert
