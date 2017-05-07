#!/bin/bash

: ${HADOOP_PREFIX:=/usr/local/hadoop}

rm /tmp/*.pid

# installing libraries if any - (resource urls added comma separated to the ACP system variable)
cd $HADOOP_PREFIX/share/hadoop/common ; for cp in ${ACP//,/ }; do  echo == $cp; curl -LO $cp ; done; cd -

# replace values with environment variables
sed -i "s/EXAMPLE.COM/${KRB_REALM}/g" $HBASE_HOME/conf/hbase-site.xml
sed -i "s/EXAMPLE.COM/${KRB_REALM}/g" /etc/krb5.conf
sed -i "s/example.com/${DOMAIN_REALM}/g" /etc/krb5.conf

kadmin -p admin/admin -w admin -q "addprinc -randkey hbase/$(hostname -f)@${KRB_REALM}"
kadmin -p admin/admin -w admin -q "xst -k hbase.keytab hbase/$(hostname -f)"
mkdir -p /etc/security/keytabs
mv hbase.keytab /etc/security/keytabs
chown hbase:hbase /etc/security/keytabs
chmod 400 /etc/security/keytabs

service sshd start
$HADOOP_PREFIX/sbin/start-dfs.sh
$HADOOP_PREFIX/sbin/start-yarn.sh
$ZOO_HOME/bin/zkServer.sh start
$HBASE_HOME/bin/start-hbase.sh

if [[ $1 == "-d" ]]; then
  while true; do sleep 1000; done
fi

if [[ $1 == "-bash" ]]; then
  /bin/bash
fi

if [[ $1 == "-sqlline" ]]; then
  /usr/local/phoenix/hadoop2/bin/sqlline.py localhost
fi
