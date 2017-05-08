#!/bin/bash

: ${HADOOP_PREFIX:=/usr/local/hadoop}

rm /tmp/*.pid

# installing libraries if any - (resource urls added comma separated to the ACP system variable)
cd $HADOOP_PREFIX/share/hadoop/common ; for cp in ${ACP//,/ }; do  echo == $cp; curl -LO $cp ; done; cd -

# replace values with environment variables
# HBase with kerberos enabled
sed -i "s/EXAMPLE.COM/${KRB_REALM}/g" $HBASE_HOME/conf/hbase-site.xml
sed -i "s#/etc/security/keytabs/hbase.keytab#${HBASE_KEYTAB_FILE}#g" $HBASE_HOME/conf/hbase-site.xml
sed -i "s/EXAMPLE.COM/${KRB_REALM}/g" /etc/krb5.conf
sed -i "s/example.com/${DOMAIN_REALM}/g" /etc/krb5.conf
sed -i "s#/etc/security/keytabs/hbase.keytab#${HBASE_KEYTAB_FILE}#g" $HBASE_HOME/conf/zk-jaas.conf
sed -i "s#/etc/hbase/conf/hbase-env.sh#${HBASE_HOME}/conf/hbase-env.sh#g" $HBASE_HOME/conf/hbase-env.sh


# Zookeeper with Kerberos enabled
sed -i "s/fully.qualified.domain.name/$(hostname -f)/g" $ZOO_HOME/conf/jaas.conf
sed -i "s/EXAMPLE.COM/${KRB_REALM}/g" $ZOO_HOME/conf/jaas.conf
sed -i "s#/etc/security/keytabs/zookeeper.keytab#${ZOOKEEPER_KEYTAB_FILE}#g" $ZOO_HOME/conf/jaas.conf
sed -i "s#/etc/zookeeper/conf/jaas.conf#$ZOO_HOME/conf/jaas.conf#g" $ZOO_HOME/conf/java.env

# create hbase kerberos principal and keytab
kadmin -p ${KERBEROS_ADMIN} -w ${KERBEROS_ADMIN_PASSWORD} -q "addprinc -randkey hbase/$(hostname -f)@${KRB_REALM}"
kadmin -p ${KERBEROS_ADMIN} -w ${KERBEROS_ADMIN_PASSWORD} -q "xst -k hbase.keytab hbase/$(hostname -f)"
mkdir -p /etc/security/keytabs
mv hbase.keytab /etc/security/keytabs
chmod 400 /etc/security/keytabs/hbase.keytab

# create zookeeper principal and keytab
kadmin -p ${KERBEROS_ADMIN} -w ${KERBEROS_ADMIN_PASSWORD} -q "addprinc -randkey zookeeper/$(hostname -f)@${KRB_REALM}"
kadmin -p ${KERBEROS_ADMIN} -w ${KERBEROS_ADMIN_PASSWORD} -q "xst -k zookeeper.keytab zookeeper/$(hostname -f)"
mkdir -p /etc/security/keytabs
mv zookeeper.keytab /etc/security/keytabs
chmod 400 /etc/security/keytabs/zookeeper.keytab

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
