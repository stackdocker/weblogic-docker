#!/bin/bash

set -e

working_dir=`pwd`

download_dir=$(cd $(dirname "${BASH_SOURCE[0]}") && pwd)

base_dir="$download_dir/opensuse13.2/zypp/packages"

download_dir+="/opensuse13.2/rpm"

mkdir -p $base_dir $download_dir

if [ -e /bin/docker -o -e /usr/bin/docker -o -e /usr/local/bin/docker ]; then
    if [[ $(docker version -f {{.Client.Version}}) =~ [1-9]\.[1-9][0-9]?\.[0-9]+ ]]; then

install_pkg="
    glibc-locale \
	glibc-i18ndata \
	timezone \
	net-tools \
	curl \
    unzip \
    bsdtar \
"

docker run -t --rm -v $base_dir/packages:/tmp/packages opensuse:13.2 \
    zypper --non-interactive --pkg-cache-dir=/tmp/packages install --download-only $install_pkg

# docker run -t --rm -v $base_dir:/var/cache/zypp opensuse:13.2 \
#     zypper --non-interactive install --download-only install $install_pkg

    fi
else

basearch=x86_64

baseurl=http://mirror.centos.org/centos/7/os/$basearch/Packages/
updateurl=http://mirror.centos.org/centos/7/updates/$basearch/Packages/

install_rpm=" \
	lzo-2.06-8.el7.x86_64.rpm \
	unzip-6.0-15.el7.x86_64.rpm \
" 

for i in $install_rpms; do
    [ ! -f "$download_dir/$i" ] && curl -jkSL "${baseurl}$i" -o "$download_dir/$i";
done

install_rpm=" \
	bsdtar-3.1.2-10.el7_2.x86_64.rpm \
	libarchive-3.1.2-10.el7_2.x86_64.rpm \
" 

for i in $install_rpms; do
    [ ! -f "$download_dir/$i" ] && curl -jkSL "${updateurl}$i" -o "$download_dir/$i";
done

fi

cd $working_dir
