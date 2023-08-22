#!/bin/bash
# Downloading pip packages specified in requirements.txt
# Useful for airgap environment where python packages need to be supplied offline
#

PACKAGES="$(cat requirements.txt)"
DATE=`date +%d%m%Y`
TARGET_DIR="pips_repo"
LOG_FILE="pip_download_${DATE}.log"
mkdir $TARGET_DIR; chmod 777 $TARGET_DIR
pushd $TARGET_DIR
for pkg in $PACKAGES; do
  apt-get download $pkg;
  pip download $pkg
done

echo "${TARGET_DIR} repo was created"
popd
tar czvf "${TARGET_DIR}".tgz "${TARGET_DIR}"
rm -rf "${TARGET_DIR}"
