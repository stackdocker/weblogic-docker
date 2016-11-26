FROM docker.io/centos:centos7
MAINTAINER tangfeixiong <tangfx128@gmail.com>
# Inspired by: Anastas Dancha <anapsix@random.io>, playniuniu@gmail.com, 
# and http://download.oracle.com/otn/nt/middleware/12c/wls/1213/README_WIN_UP3.txt

# ARG java_url="http://download.oracle.com/otn-pub/java/jdk/8u112-b15/server-jre-8u112-linux-x64.tar.gz"
ARG java_package=java.tar.gz
# ARG wls_url="http://download.oracle.com/otn/nt/middleware/12c/12212/fmw_12.2.1.2.0_wls_quick_Disk1_1of1.zip"
ARG wls_package=fmw_12.2.1.2.0_wls_quick_Disk1_1of1.zip
ARG domain_name
ARG admin_username
ARG admin_password

COPY / /tmp/build/

ENV JAVA_HOME=/opt/java \
    MW_HOME=/opt/fmw \
    WL_HOME=/opt/fmw/wlserver \
    DOMIAN_NAME=${domain_name:-mydomain} \
    DOMAIN_HOME=/opt/user_projects/domains/$DOMAIN_NAME \
    ADMIN_PORT="8001" \
    ADMIN_HOST="wlsadmin" \
    NM_PORT="5556" \
    MS_PORT="7001" \
    PATH=$PATH:$JAVA_HOME/bin:$MW_HOME/oracle_common/common/bin:$WL_HOME/common/bin:$DOMAIN_HOME/bin \
    CONFIG_JVM_ARGS="-Dweblogic.security.SSL.ignoreHostnameVerification=true" \
    USER_MEM_ARGS="-Djava.security.egd=file:/dev/./urandom" \
    DEBUG_PORT="8453" \
    DEBUG_FLAG=true \
    PRODUCTION_MODE=dev

RUN INSTALL_PKGS="curl tar" \
  && yum install -y $INSTALL_PKGS \
  && rpm -V $INSTALL_PKGS \
  && yum clean all \
  && /tmp/build/download-oracle-java.sh \
  && mkdir -p $JAVA_HOME \
  && tar -C $JAVA_HOME --strip-components=1 -zxf \
        /tmp/build/download/${java_package:-server-jre-8u112-linux-x64.tar.gz} \
  && cd /tmp/build \
  && $JAVA_HOME/bin/jar xf \
        /tmp/build/download/${wls_package:-fmw_wls_quick.zip} \
  && sed -i "s%/u01/oracle/%$MW_HOME/%;s%inst_group=oracle%inst_group=root%" /tmp/build/oraInst.loc \
  && mkdir -p $MW_HOME \
  && useradd -d /opt/fmw -M -s /bin/bash oracle \
  && chown oracle: $MW_HOME /tmp/build /tmp/build/oraInst.loc /tmp/build/install.file \
  && su -c "$JAVA_HOME/bin/java -jar /tmp/build/fmw_12.2.1.2.0_wls_quick.jar \
        -invPtrLoc /tmp/build/oraInst.loc -jreLoc $JAVA_HOME \
        -ignoreSysPrereqs -force -novalidation ORACLE_HOME=$MW_HOME" - oracle \
  && for i in $(ls /tmp/build/container-scripts/{*.py,*.sh}); do sed -i "s%/u01/oracle/%$MW_HOME/%g" $i; done \ 
  && mv /tmp/build/container-scripts/* $MW_HOME \
  && cd $MW_HOME \
  && PATH=$PATH:$JAVA_HOME/bin:$MW_HOME/oracle_common/common/bin:$WL_HOME/common/bin:$DOMAIN_HOME/bin \
        ADMIN_PASSWORD=${admin_password:-weblogic1234%^&*} \
        $MW_HOME/wlst $MW_HOME/create-wls-domain.py \
  && mkdir -p $DOMAIN_HOME/servers/AdminServer/security \
  && echo -e "username=${admin_username:-weblogic}\npassword=${admin_password:-weblogic1234%^&*}" | tee $DOMAIN_HOME/servers/AdminServer/security/boot.properties \
  && echo -e "\n. $DOMAIN_HOME/bin/setDomainEnv.sh\nexport PATH=$PATH:$DOMAIN_HOME/bin" | tee -a /root/.bashrc \
  && rm -rf /tmp/build \
  && REMOVE_PKGS="unzip wget" \
  && yum erase -y $REMOVE_PKGS \
  && JAVA_STUFF=" \
        README.html \
        THIRDPARTYLICENSEREADME.txt \
        release \
        db \
        include \
        jre/bin/{jjs,keytool,orbd,pack200,policytool,rmid,rmiregistry,servertool,tnameserv,unpack200} \
        jre/lib/ext/{jfxrt.jar,nashorn.jar} \
        jre/lib/{fontconfig.RedHat.*,fontconfig.SuSE.*,fontconfig.Turbo.*} \
        jre/{README,THIRDPARTYLICENSEREADME.txt, Welcome.html} \
        lib/{javaws.jar,deploy*,desktop,*javafx*,*jfx*,oblique-fonts,plugin.jar} \
        man \
        plugin \
  " \
  && for i in $JAVA_STUFF; do rm -rf $JAVA_HOME/$i; done \
  && WLS_STUFF=" \
    configure.cmd \
    README_WIN \
    coherence/bin/{*.cmd,optimize.reg,readme} \
    oracle_common/bin/*.bat \
    oracle_common/common/bin/*.cmd \
    oracle_common/common/modules/datadirect/*.dll \
    oracle_common/common/modules/mysql-connector-java-commercial-5.1.22/{docs,CHANGES,*README*} \
    oracle_common/common/modules/oracle.fmwconfig.common.wls.help/{wl???_de.*,wl???_es.*,wl???_fr.*,wl???_it.*,wl???_ja.*,wl???_ko.*,wl???_pt_BR.*,wl???_zh_TW.*} \
    oracle_common/common/modules/org.apache.ant_1.9.2/bin/{*.bat,*.cmd} \
    oracle_common/common/modules/org.apache.ant_1.9.2/{manual,INSTALL,README,WHATSNEW} \ 
    oracle_common/common/modules/org.apache.maven_3.0.5/bin/*.bat \
    wlserver/common/bin/*.cmd \
    wlserver/server/{db2,informix,sybase} \
    wlserver/server/bin/{international,*.exe,*.dll,*.lib,*.cmd} \
    wlserver/server/include/{aixppc*,hp-ux,lnx_s*,lnxi*,win32} \
    wlserver/server/include/platform/{aixppc*,hp-ux,lnx_s*,lnxi*,win32} \
    wlserver/server/lib/{weblogic-de.*,weblogic-es.*,weblogic-fr.*,weblogic-it.*,weblogic-js.*,weblogic-ko.*,weblogic-pt_BR.*,weblogic-zh_TW.*,wlw-langx-jx.*,wlw-langx-ko.*,wlw-langx-zh_TW.*} \
    wlserver/server/locale/C/{aix-*,hpux-*,linux-i*,linux-s*,solaris-*,win*} \
    wlserver/server/native/linux/i686 \
    wlserver/server/native/win \
    wlserver/sip/server/native/linux/i686 \
    wlserver/sip/server/native/solaris \
  " \
  && for i in $WLS_STUFF; do rm -rf $MW_HOME/$i; done 

# VOLUME $DOMAIN_HOME

EXPOSE $NM_PORT $ADMIN_PORT $MS_PORT $DEBUG_PORT

WORKDIR $DOMAIN_HOME
CMD ["startWebLogic.sh"]
