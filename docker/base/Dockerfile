# test deployment target
#
# VERSION               0.0.1

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



FROM       phusion/baseimage:0.11
MAINTAINER Nuxeo Packagers <packagers@nuxeo.com>

RUN echo "deb http://eu-west-1.ec2.archive.ubuntu.com/ubuntu/ bionic main restricted universe multiverse" > /etc/apt/sources.list
RUN echo "deb http://eu-west-1.ec2.archive.ubuntu.com/ubuntu/ bionic-updates main restricted universe multiverse" >> /etc/apt/sources.list
RUN echo "deb http://eu-west-1.ec2.archive.ubuntu.com/ubuntu/ bionic-backports main restricted universe multiverse" >> /etc/apt/sources.list
RUN echo "deb http://security.ubuntu.com/ubuntu bionic-security main restricted universe multiverse" >> /etc/apt/sources.list

RUN echo "ttf-mscorefonts-installer msttcorefonts/accepted-mscorefonts-eula select true" | debconf-set-selections

ENV DEBIAN_FRONTEND noninteractive
RUN apt-get update || true
RUN apt-get -q -y dist-upgrade
RUN apt-get -q -y install locales unzip sudo
RUN locale-gen en_US.UTF-8
RUN dpkg-reconfigure locales
RUN update-locale LANG=en_US.UTF-8
RUN apt-get install -q -y postgresql libpq-dev python-psycopg2 libreoffice imagemagick poppler-utils ffmpeg2theora ufraw libwpd-tools git redis-server redis-tools rsync xvfb x11vnc fluxbox ttf-mscorefonts-installer iproute2

# Updating fonts
RUN fc-cache -f -v

#RUN git clone https://github.com/nuxeo/ffmpeg-nuxeo.git
#ENV BUILD_YASM true
#RUN cd ffmpeg-nuxeo && ./build-all.sh true
#RUN rm -rf ffmpeg-nuxeo

RUN sed -i 's/daemonize yes/daemonize no/g' /etc/redis/redis.conf
RUN mkdir /etc/service/redis
ADD ${BASE:-.}/files/redis /etc/service/redis/run
RUN chmod +x /etc/service/redis/run

# Add sudoer user
RUN useradd -d /home/ubuntu -m -s /bin/bash ubuntu
RUN echo "\nubuntu ALL=(ALL) NOPASSWD:ALL" >> /etc/sudoers

# Add jenkins user
RUN useradd -d /opt/jenkins -m -s /bin/bash jenkins

RUN mkdir /etc/service/xvfb
ADD ${BASE:-.}/files/xvfb /etc/service/xvfb/run
RUN chmod +x /etc/service/xvfb/run

RUN mkdir /etc/service/x11vnc
ADD ${BASE:-.}/files/x11vnc /etc/service/x11vnc/run
RUN chmod +x /etc/service/x11vnc/run

RUN mkdir /etc/service/fluxbox
ADD ${BASE:-.}/files/fluxbox /etc/service/fluxbox/run
RUN chmod +x /etc/service/fluxbox/run

RUN mkdir /home/ubuntu/.ssh
ADD ${BASE:-.}/files/id_rsa.pub /home/ubuntu/.ssh/authorized_keys
RUN chown -R ubuntu:ubuntu /home/ubuntu/.ssh
RUN chmod 0600 /home/ubuntu/.ssh/authorized_keys
RUN chmod 0700 /home/ubuntu/.ssh

RUN echo "UsePAM yes" >> /etc/ssh/sshd_config
RUN echo "PermitUserEnvironment yes" >> /etc/ssh/sshd_config
RUN rm -f /etc/service/sshd/down

EXPOSE 22

RUN touch /etc/service/cron/down

ADD ${BASE:-.}/files/rc.local /etc/rc.local
RUN chmod +x /etc/rc.local

CMD ["/sbin/my_init"]

