#!/bin/bash

set -e

working_dir=`pwd`

download_dir=$(cd $(dirname "${BASH_SOURCE[0]}") && pwd)

base_dir="$download_dir/centos7/yum"

download_dir+="/centos7/rpm"

mkdir -p $download_dir

if [ -e /bin/docker -o -e /usr/bin/docker -o -e /usr/local/bin/docker ]; then
    if [[ $(docker version -f {{.Client.Version}}) =~ [1-9]\.[1-9][0-9]?\.[0-9]+ ]]; then

install_pkg="
    unzip \
    glibc-common \
    bsdtar \
	# tzdata \
"

# docker run -t --rm -v $download_dir:/tmp/download centos:centos7 \
#     "yum --downloadonly --downloaddir=/tmp/download install $install_pkg"

docker run -t --rm -v $base_dir:/var/cache/yum centos:centos7 \
    yum --downloadonly install $install_pkg

# docker run -t --rm -v $base_dir:/tmp/download centos:centos7 \
#     /bin/bash -c " \
# 	    mkdir -p /var/cache/yum/x86_64 \
#         && ln -s /tmp/download /var/cache/yum/x86_64/7 \
#         && export install_pkg=' \
#             unzip \
#             glibc-common \
#             bsdtar \
#         ' \
# 	    && yum --downloadonly install \$install_pkg \
# 	  "


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
