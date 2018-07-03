installDir=$(realpath ${1:-$HOME})

cat <<EOF | patch -d/ -p0
diff -u -N -r swarm.labels $installDir/swarm-client/conf/swarm.labels
--- $installDir/swarm-client/conf/swarm.labels	1970-01-01 01:00:00.000000000 +0100
+++ $installDir/swarm-client/conf/swarm.labels	2018-06-29 14:26:21.000000000 +0200
@@ -0,0 +1,1 @@
+swarm
\ No newline at end of file
diff -u -N -r swarm.opts $installDir/conf/swarm-client/swarm.opts
--- $installDir/swarm-client/conf/swarm.opts	1970-01-01 01:00:00.000000000 +0100
+++ $installDir/swarm-client/conf/swarm.opts	2018-06-29 14:26:21.000000000 +0200
@@ -0,0 +1,9 @@
+[ "\$JENKINS_API_TOKEN" != "" ] && echo \$JENKINS_API_TOKEN > $installDir/swarm-client/conf/jenkins.secret
+opts="-master \${JENKINS_MASTER:-https://qa.nuxeo.org/jenkins}"
+opts="\$opts -fsroot /opt/jenkins"
+opts="\$opts -executors 1"
+opts="\$opts -name \${JENKINS_NAME:-\$(hostname)}"
+opts="\$opts -deleteExistingClients  -disableClientsUniqueId -retry 3 --showHostName -pidFile $installDir/swarm-client/instance.pid"
+opts="\$opts -username \${JENKINS_USERNAME:-jenkins} -passwordFile $installDir/swarm-client/conf/jenkins.secret"
+opts="\$opts -labelsFile $installDir/swarm-client/conf/swarm.labels"
+#opts="\$opts --toolLocation java-7-sun=/usr/lib/jvm/java-7/ --toolLocation java-8-oracle=/usr/lib/jvm/java-8/"
diff -u -N -r $installDir/swarm-client/conf/swarm.env swarm.env
--- $installDir/swarm-client/conf/swarm.env	1970-01-01 01:00:00.000000000 +0100
+++ $installDir/swarm-client/conf/swarm.env      2018-06-29 16:41:20.661429829 +0200
@@ -0,0 +1,33 @@
+DISPLAY=:1
+NX_DB_PASS=nuxeo
+NX_DB_USER=nuxeo
+NX_MSSQL_DB_ADMINNAME=master
+NX_MSSQL_DB_ADMINPASS=nuxeo
+NX_MSSQL_DB_ADMINUSER=sa
+NX_MSSQL_DB_HOST=squirrel
+NX_MSSQL_DB_NAME=\($hostname)
+NX_MSSQL_DB_PORT=1433
+NX_MYSQL_DB_ADMINNAME=mysql
+NX_MYSQL_DB_ADMINPASS=nuxeo
+NX_MYSQL_DB_ADMINUSER=root
+NX_MYSQL_DB_HOST=saratoga
+NX_MYSQL_DB_NAME=\$(hostname)
+NX_MYSQL_DB_PORT=3306
+NX_ORACLE10G_DB_ADMINNAME=nuxeo
+NX_ORACLE10G_DB_ADMINPASS=nuxeo
+NX_ORACLE10G_DB_ADMINUSER=sys
+NX_ORACLE10G_DB_HOST=blackrock
+NX_ORACLE10G_DB_NAME=nuxeo
+NX_ORACLE10G_DB_PORT=1521
+NX_ORACLE11G_DB_ADMINNAME=nuxeo
+NX_ORACLE11G_DB_ADMINPASS=nuxeo
+NX_ORACLE11G_DB_ADMINUSER=sys
+NX_ORACLE11G_DB_HOST=obsidian
+NX_ORACLE11G_DB_NAME=nuxeo
+NX_ORACLE11G_DB_PORT=1521
+NX_PGSQL_DB_ADMINNAME=template1
+NX_PGSQL_DB_ADMINPASS=nuxeo
+NX_PGSQL_DB_ADMINUSER=nxadmin
+NX_PGSQL_DB_HOST=saratoga
+NX_PGSQL_DB_NAME=\$(hostname)
+NX_PGSQL_DB_PORT=5432
diff -u -N -r $installDir/swarm-client/conf/jenkins.secret jenkins.secret
--- $installDir/swarm-client/conf/jenkins.secret	1970-01-01 01:00:00.000000000 +0100
+++ $installDir/swarm-client/conf/jenkins.secret	2018-06-29 14:26:21.000000000 +0200
@@ -0,0 +1 @@
+${JENKINS_API_SECRET:-You should provide a secret}
diff -u -N -r $installDir/swarm-client/launcher.sh launcher.sh
--- $installDir/swarm-client/launcher.sh	1970-01-01 01:00:00.000000000 +0100
+++ $installDir/swarm-client/launcher.sh	2018-06-29 14:26:21.000000000 +0200
@@ -0,0 +1,6 @@
+#!/bin/bash -x
+set -a
+source $installDir/swarm-client/conf/swarm.env
+set +a
+source $installDir/swarm-client/conf/swarm.opts
+exec java -Djava.util.logging.config.file=$installDir/swarm-client/conf/logging.properties -jar $installDir/swarm-client/swarm-client.jar \$opts
diff -u -N -r $installDir/swarm-client/conf/logging.properties logging.properties
--- $installDir/swarm-client/conf/logging.properties	1970-01-01 01:00:00.000000000 +0100
+++ $installDir/swarm-client/conf/logging.properties	2018-06-29 15:38:36.000000000 +0200
@@ -0,0 +1,59 @@
+############################################################
+#  	Default Logging Configuration File
+#
+# You can use a different file by specifying a filename
+# with the java.util.logging.config.file system property.  
+# For example java -Djava.util.logging.config.file=myfile
+############################################################
+
+
+# example launch of Swarm Client with labelsFile and logging
+#
+# java -Djava.util.logging.config.file=./logging.properties -jar swarm-client-jar-with-dependencies.jar -master http://10.211.55.12:8080 -labelsFile ~/labels.txt 
+
+
+############################################################
+#  	Global properties
+############################################################
+
+# "handlers" specifies a comma separated list of log Handler 
+# classes.  These handlers will be installed during VM startup.
+# Note that these classes must be on the system classpath.
+# By default we only configure a ConsoleHandler, which will only
+# show messages at the INFO and above levels.
+# handlers= java.util.logging.ConsoleHandler
+
+# To also add the FileHandler, use the following line instead.
+handlers= java.util.logging.FileHandler, java.util.logging.ConsoleHandler
+
+# Default global logging level.
+# This specifies which kinds of events are logged across
+# all loggers.  For any given facility this global level
+# can be overriden by a facility specific level
+# Note that the ConsoleHandler also has a separate level
+# setting to limit messages printed to the console.
+.level= INFO
+
+############################################################
+# Handler specific properties.
+# Describes specific configuration info for Handlers.
+############################################################
+
+# default file output is in user's home directory.
+java.util.logging.FileHandler.pattern = $installDir/swarm-client/swarm-%u.log
+java.util.logging.FileHandler.limit = 1000000
+java.util.logging.FileHandler.count = 10
+java.util.logging.FileHandler.formatter = java.util.logging.SimpleFormatter
+
+# Limit the message that are printed on the console to INFO and above.
+java.util.logging.ConsoleHandler.level = CONFIG
+java.util.logging.ConsoleHandler.formatter = java.util.logging.SimpleFormatter
+java.util.logging.SimpleFormatter.format=%1$tY-%1$tm-%1$td %1$tH:%1$tM:%1$tS %4$s %2$s %5$s%6$s%n
+
+############################################################
+# Facility specific properties.
+# Provides extra control for each logger.
+############################################################
+
+# For example, set the com.xyz.foo logger to only log SEVERE
+# messages:
EOF

set -x
wget -q https://maven.nuxeo.org/nexus/service/local/repositories/vendor-releases/content/org/jenkins-ci/plugins/swarm-client/3.12/swarm-client-3.12-remoting-2-59-2.jar -O $installDir/swarm-client/swarm-client.jar
chmod +x $installDir/swarm-client/launcher.sh
set +x
