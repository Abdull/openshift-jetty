cd $OPENSHIFT_REPO_DIR
# the following exports are not needed, as the /usr/bin/mvn script already sets sensible exports
# export JAVA_HOME=/usr/lib/jvm/java
# export M2_HOME=/etc/alternatives/maven-3.0

export PATH=$JAVA_HOME/bin:$M2_HOME/bin:$PATH

mvn --global-settings ${OPENSHIFT_DATA_DIR}maven.xml --version
mvn --global-settings ${OPENSHIFT_DATA_DIR}maven.xml clean package -Popenshift -DskipTests
