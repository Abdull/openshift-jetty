#!/bin/bash
cd ${OPENSHIFT_DATA_DIR}jetty

kill `cat jetty.pid`
