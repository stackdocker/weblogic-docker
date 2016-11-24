#!/bin/bash -e

CONTEXT_DIR=$(dirname "${BASH_SOURCE}")
DOWNLOAD_DIR=$CONTEXT_DIR

JAVA_TARGET=$DOWNLOAD_DIR/java.tar.gz

# JAVA_URL=http://download.oracle.com/otn-pub/java/8u92-b14/server-jre-8u92-linux-x64.tar.gz
JAVA_URL=http://download.oracle.com/otn-pub/java/jdk/8u112-b15/server-jre-8u112-linux-x64.tar.gz

[[ -d $DOWNLOAD_DIR ]] || mkdir -p $DOWNLOAD_DIR

if [[ 0 -lt $# || ! -f $JAVA_TARGET ]]; then
  # Only worked for java 7/8
  curl -jkSLH "Cookie: oraclelicense=accept-securebackup-cookie" \
    -o $JAVA_TARGET \
    $JAVA_URL
fi
