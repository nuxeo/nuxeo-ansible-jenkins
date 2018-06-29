installDir=$HOME/swarm-client

patch -p0 <<EOF
diff -u -N -r swarm-client/swarm.labels $installDir/swarm.labels
--- swarm-client/swarm.labels	1970-01-01 01:00:00.000000000 +0100
+++ swarm-client/swarm.labels	2018-06-29 14:26:21.000000000 +0200
@@ -0,0 +1,1 @@
+OSXSLAVE
\ No newline at end of file
diff -u -N -r swarm-client/swarm.opts $installDir/swarm.opts
--- swarm-client/swarm.opts	1970-01-01 01:00:00.000000000 +0100
+++ swarm-client/swarm.opts	2018-06-29 14:26:21.000000000 +0200
@@ -0,0 +1,6 @@
+opts="-master https://qa.nuxeo.org/jenkins"
+opts="\$opts -name $(hostname)"
+opts="\$opts -deleteExistingClients  -disableClientsUniqueId -retry 3 --showHostName -pidFile $installDir/instance.pid"
+opts="\$opts -username jenkins -passwordFile $installDir/jenkins.secret"
+opts="\$opts -labelsFile $installDir/swarm.labels"
+opts="\$opts --toolLocation java-7-sun=/Library/Java/JavaVirtualMachines/1.7.0.jdk/Contents/Home/ --toolLocation java-8-oracle=/Library/Java/JavaVirtualMachines/jdk1.8.0_40.jdk/Contents/Home/"
diff -u -N -r $installDir/jenkins.secret swarm-client/jenkins.secret
--- swarm-client/jenkins.secret	1970-01-01 01:00:00.000000000 +0100
+++ swarm-client/jenkins.secret	2018-06-29 14:26:21.000000000 +0200
@@ -0,0 +1 @@
+${JENKINS_API_SECRET:-You should provide a secret}
diff -u -N -r $installDir/launcher.sh swarm-client/launcher.sh
--- swarm-client/launcher.sh	1970-01-01 01:00:00.000000000 +0100
+++ swarm-client/launcher.sh	2018-06-29 14:26:21.000000000 +0200
@@ -0,0 +1,4 @@
+#!/bin/bash
+
+source $installDir/swarm.opts
+exec java -Djava.util.logging.config.file=$installDir/logging.properties -jar $installDir/swarm-client.jar \$opts
diff -u -N -r $installDir/logging.properties swarm-client/logging.properties
--- swarm-client/logging.properties	1970-01-01 01:00:00.000000000 +0100
+++ swarm-client/logging.properties	2018-06-29 15:38:36.000000000 +0200
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
+java.util.logging.FileHandler.pattern = $installDir/swarm-%u.log
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

wget -q https://maven.nuxeo.org/nexus/service/local/repositories/vendor-releases/content/org/jenkins-ci/plugins/swarm-client/3.12/swarm-client-3.12-remoting-2-59-2.jar -O $installDir/swarm-client.jar
chmod +x $installDir/launcher.sh

echo "Launch swarm @ reboot by editing your crontab with the following line"
echo "@reboot /bin/bash -l -c $installDir/launcher.sh"
