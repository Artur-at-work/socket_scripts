#!/bin/bash
#
# Script to download .deb package and all required dependencies
# It uses apt-rdepends which searches dependencies recursively
# This is helpful for airgap environment where have to make sure that all dependecies are met
#
# Packages.gz is created after completion, so this can be used as a local repository
#

PACKAGES="$(cat ./dependencies_list)"
DATE=`date +%d%m%Y`
TARGET_DIR="local_repo"
LOG_FILE="apt_download.${DATE}.log"

mkdir $TARGET_DIR; chmod 777 $TARGET_DIR
pushd $TARGET_DIR
touch $RDEP_TMP
for pkg in $PACKAGES; do
  apt-get download $pkg;
  for dependency in $(apt-rdepends $pkg | grep -v "^ "); do
      apt-get download $dependency 2>>$LOG_FILE;
  done
done

echo "${TARGET_DIR} repo was created"

# init local repo
dpkg-scanpackages -m . /dev/null | gzip -9 > Packages.gz
popd
tar czvf "${TARGET_DIR}".tgz "${TARGET_DIR}"
rm -rf "${TARGET_DIR}"
