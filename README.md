## Content

### Experimental

How to

    [tangfx@localhost weblogic-docker]$ cd experimental && docker build -t tangfeixiong/weblogic -f Dockerfile.wls12130.centos7 .

Offline 

    [tangfx@localhost weblogic-docker]$ ls experimental/download/
    download-centos-rpm.sh   download-oracle-wls.sh  unzip-6.0-15.el7.x86_64.rpm
    download-oracle-java.sh  java.tar.gz             wls.zip

### WebLogic 12.2.1.2

`Makefile`

    [tangfx@localhost 12.2.1.2]$ make

Alternative: `make centos`, `make oraclelinux`

Directly `docker build`

    [tangfx@localhost 12.2.1.2]$ dockr build -t <your>/<image>:<tag> -f <centos|oraclelinux>/Dockerfile .

Size

    [tangfx@localhost weblogic-docker]$ docker images
    REPOSITORY                                       TAG                         IMAGE ID            CREATED             SIZE
    tangfeixiong/weblogic                            latest                      2cc9509477a3        34 minutes ago      1.292 GB

