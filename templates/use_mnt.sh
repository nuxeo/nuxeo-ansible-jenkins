#!/bin/bash
#
# Initializing script for making use of /mnt
#
# (C) Copyright 2013 Nuxeo SA (http://nuxeo.com/) and contributors.
#
# All rights reserved. This program and the accompanying materials
# are made available under the terms of the GNU Lesser General Public License
# (LGPL) version 2.1 which accompanies this distribution, and is available at
# http://www.gnu.org/licenses/lgpl.html
#
# This library is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU
# Lesser General Public License for more details.
#
# Contributors:
#   Julien Carsique
#

mkdir /mnt/repository /mnt/workspace
chown jenkins:jenkins /mnt/repository /mnt/workspace
ln -s /mnt/repository ~jenkins/.m2/repository
ln -s /mnt/workspace ~jenkins/workspace
