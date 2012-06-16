#!/bin/sh

JETTY_VERSION="8.1.4.v20120524"

cd $OPENSHIFT_DATA_DIR

if [ -d "jetty" ] && [ "`cat jetty/VERSION`" == $JETTY_VERSION ]; then

  echo "Jetty already installed"

else

  echo "Installing Jetty ${JETTY_VERSION}"

  if [ -d "jetty" ]; then
    rm -rf jetty
  fi

  curl -o jetty.tar.gz "http://download.eclipse.org/jetty/stable-8/dist/jetty-distribution-${JETTY_VERSION}.tar.gz"

  tar -xf jetty.tar.gz
  rm jetty.tar.gz

  mv jetty-distribution-${JETTY_VERSION} jetty

  echo $JETTY_VERSION > jetty/VERSION

  rm -rf jetty/contexts/*
  rm -rf jetty/webapps

  curl -o maven.xml "https://raw.github.com/marekjelen/openshift-jetty/master/maven.xml"

fi
