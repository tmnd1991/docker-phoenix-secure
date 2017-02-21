#!/bin/bash

: ${HADOOP_PREFIX:=/usr/local/hadoop}
: ${ZOO_HOME:=$1}
: ${HBASE_HOME:=$2}
: ${KRB_REALM:=$3}

rm /tmp/*.pid

# installing libraries if any - (resource urls added comma separated to the ACP system variable)
cd $HADOOP_PREFIX/share/hadoop/common ; for cp in ${ACP//,/ }; do  echo == $cp; curl -LO $cp ; done; cd -

sed -i "s/YOUR-REALM.COM/${KRB_REALM}/g" $HBASE_HOME/conf/hbase-site.xml


echo "test" >> /tmp/test.txt
echo $KRB_REALM >> /tmp/test.txt
echo $ZOO_HOME >> /tmp/test.txt
echo "ende" >> /tmp/test.txt

service sshd start
$HADOOP_PREFIX/sbin/start-dfs.sh
$HADOOP_PREFIX/sbin/start-yarn.sh
$ZOO_HOME/bin/zkServer.sh start
$HBASE_HOME/bin/start-hbase.sh

if [[ $4 == "-d" ]]; then
  while true; do sleep 1000; done
fi

if [[ $4 == "-bash" ]]; then
  /bin/bash
fi

if [[ $4 == "-sqlline" ]]; then
  /usr/local/phoenix/hadoop2/bin/sqlline.py localhost
fi
