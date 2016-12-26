#!/bin/bash

set -e

working_dir=`pwd`

download_dir=$(cd $(dirname "${BASH_SOURCE[0]}") && pwd)

download_dir+="/oraclelinux7/rpm"

mkdir -p $download_dir

if [ -e /bin/docker -o -e /usr/bin/docker -o -e /usr/local/bin/docker ]; then
    if [[ $(docker version -f {{.Client.Version}}) =~ [1-9]\.[1-9][0-9]?\.[0-9]+ ]]; then

install_pkg="
    unzip \
    glibc-common \
"

docker run -t --rm -v $download_dir:/tmp/download oraclelinux:7.3 \
    yum --downloadonly --downloaddir=/tmp/download install $install_pkg

    fi
else

basearch=x86_64

### [ol7_latest]
### baseurl=http://yum.oracle.com/repo/OracleLinux/OL7/latest/$basearch/
baseurl=http://public-yum.oracle.com/repo/OracleLinux/OL7/latest/$basearch

install_rpm=" \
	unzip-6.0-16.el7.x86_64.rpm \
" 

for i in $install_rpms; do
    [ ! -f "$download_dir/$i" ] && curl -jkSL "$baseurl/getPackage/$i" -o "$download_dir/$i";
done

fi

cd $working_dir
