#!/bin/bash
currentdir=$(pwd)
echo This Program searchs installed software in the system, then download source code automatically.
echo Distributing customized rootfs is allowed under GPL license.
echo Waiting 5 sec..
sleep 5s

WORK_DIR=./Debian_source_downloader
if [ -d ${WORK_DIR} ]
then
    echo ${WORK_DIR} is exist.
else
    echo Create ${WORK_DIR}
    mkdir ${WORK_DIR}
fi

cd ${WORK_DIR}

pkgcount=($(dpkg -l | grep '^ii' | awk '{print "apt-get source " $2"=" $3 }'))
#> "get_source.txt"
count=0
for eachValue in ${pkgcount[@]}; do
    echo ${eachValue}
    count=$((++count)) 
done

aptscript=($(dpkg -l | grep '^ii' | awk '{print "apt-get source " $2"=" $3 > "get_source.txt"}'))
for eachValue in ${aptscript[@]}; do
    echo ${eachValue}
done

APT_SOURCES=/etc/apt/sources.list
if [[ "$(grep deb-src ${APT_SOURCES})" == "" ]]; then 
    cat ${APT_SOURCES} | sed 's/deb/deb-src/' >> ${APT_SOURCES}
    apt update
fi

while read line
do
    $line
done < ./get_source.txt
cd "$currentdir"

echo "Finished"

