cd $OPENSHIFT_REPO_DIR

export JAVA_HOME=/etc/alternatives/java_sdk_1.6.0
export M2_HOME=/etc/alternatives/maven-3.0
export PATH=$JAVA_HOME/bin:$M2_HOME/bin:$PATH

mvn --global-settings ${OPENSHIFT_DATA_DIR}maven.xml --version
mvn --global-settings ${OPENSHIFT_DATA_DIR}maven.xml clean package -Popenshift -DskipTests
