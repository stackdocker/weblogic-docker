## Content

### _sample.war_

download from

    [tangfx@localhost weblogic-docker]$ curl -jkSL https://raw.githubusercontent.com/oracle/docker-images/master/OracleWebLogic/samples/1221-appdeploy/container-scripts/sample.war -o 12.1.3/sample.war

### WebLogic 12.1.3

How to

    [vagrant@localhost weblogic-docker]$ docker build --no-cache -t tangfeixiong/weblogic:domain_12.1.3-serverjre7-ol7 -f 12.1.3/Dockfile.wls1213_dev_update3%2E3%2Ezip.oraclelinux%3A7%2E3 .


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
