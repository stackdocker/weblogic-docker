#!/bin/bash -e

usage() {
        echo "Usage: $0 [-f] -a <auth key>
        -f        Force to download or overwrite existed. optional
        -a        The (auth key) from Oracle download site
" >/dev/stderr
        exit 1
}


[[ 0 -eq $# ]] && usage

CONTEXT_DIR=$(dirname "${BASH_SOURCE}")
DOWNLOAD_DIR=$CONTEXT_DIR
FORCE_DL=false
AUTH_PARAM=

WLS_URL=http://download.oracle.com/otn/nt/middleware/12c/12212/fmw_12.2.1.2.0_wls_quick_Disk1_1of1.zip
# WLS_URL=http://download.oracle.com/otn/nt/middleware/12c/122110/fmw_12.2.1.1.0_wls_quick_Disk1_1of1.zip
# WLS_URL=http://download.oracle.com/otn/nt/middleware/12c/1221/fmw_12.2.1.0.0_wls_quick_Disk1_1of1.zip
# WLS_URL=http://download.oracle.com/otn/nt/middleware/12c/wls/1213/wls1213_dev_update3.zip

WLS_TARGET=$DOWNLOAD_DIR/${WLS_URL##*/}

while getopts "fa:" opt; do
        case $opt in
                f)
                        FORCE_DL=true
                        ;;
                a)
                        AUTH_PARAM=$OPTARG
                        ;;
                \?)
                        usage
                        ;;
        esac
done                  

if [[ -z $AUTH_PARAM ]]; then
        usage
fi

[[ -d $DOWNLOAD_DIR ]] || mkdir -p $DOWNLOAD_DIR

if [[ true = $FORCE_DL || ! -f $WLS_TARGET ]]; then
  # Only worked for java 7/8
  wget -c -O $WLS_TARGET ${WLS_URL}\?AuthParam=${AUTH_PARAM}
fi
