#!/bin/sh

cd ${OPENSHIFT_DATA_DIR}jetty

if [ -e webapps ]; then
  rm webapps
fi

ln -s ${OPENSHIFT_REPO_DIR}deployments webapps

CMD="java -jar start.jar -Djetty.host=$OPENSHIFT_INTERNAL_IP -Djetty.port=$OPENSHIFT_INTERNAL_PORT"

nohup $CMD > $OPENSHIFT_LOG_DIR/server.log 2>&1 &
