FROM knappek/hadoop-secure:2.7.4
MAINTAINER knappek

# zookeeper
ENV ZOOKEEPER_VERSION 3.4.10
RUN curl -s http://mirror.csclub.uwaterloo.ca/apache/zookeeper/zookeeper-$ZOOKEEPER_VERSION/zookeeper-$ZOOKEEPER_VERSION.tar.gz | tar -xz -C /usr/local/
#COPY local_files/zookeeper-$ZOOKEEPER_VERSION.tar.gz /usr/local/zookeeper-$ZOOKEEPER_VERSION.tar.gz
#RUN tar -xzvf /usr/local/zookeeper-$ZOOKEEPER_VERSION.tar.gz -C /usr/local/
RUN cd /usr/local && ln -s ./zookeeper-$ZOOKEEPER_VERSION zookeeper
ENV ZOO_HOME /usr/local/zookeeper
ENV PATH $PATH:$ZOO_HOME/bin
RUN mkdir /tmp/zookeeper

# hbase
ENV HBASE_MAJOR 1.3
ENV HBASE_MINOR 2.1
ENV HBASE_VERSION "${HBASE_MAJOR}.${HBASE_MINOR}"
RUN curl -s http://apache.mirror.gtcomm.net/hbase/$HBASE_MAJOR.$HBASE_MINOR/hbase-$HBASE_MAJOR.$HBASE_MINOR-bin.tar.gz | tar -xz -C /usr/local/
#COPY local_files/hbase-$HBASE_VERSION-bin.tar.gz /usr/local/hbase-$HBASE_VERSION-bin.tar.gz
#RUN tar -xzvf /usr/local/hbase-$HBASE_VERSION-bin.tar.gz -C /usr/local
RUN cd /usr/local && ln -s ./hbase-$HBASE_VERSION hbase
ENV HBASE_HOME /usr/local/hbase
ENV PATH $PATH:$HBASE_HOME/bin
RUN rm $HBASE_HOME/conf/hbase-site.xml
COPY config_files/hbase-site.xml $HBASE_HOME/conf/hbase-site.xml

# phoenix
RUN yum install python-argparse.noarch -y
ENV PHOENIX_VERSION 4.14.1
RUN curl -s http://apache.mirror.vexxhost.com/phoenix/apache-phoenix-$PHOENIX_VERSION-HBase-$HBASE_MAJOR/bin/apache-phoenix-$PHOENIX_VERSION-HBase-$HBASE_MAJOR-bin.tar.gz | tar -xz -C /usr/local/
#COPY local_files/apache-phoenix-$PHOENIX_VERSION-HBase-$HBASE_MAJOR-bin.tar.gz /usr/local/apache-phoenix-$PHOENIX_VERSION-HBase-$HBASE_MAJOR-bin.tar.gz
#RUN tar -xzvf /usr/local/apache-phoenix-$PHOENIX_VERSION-HBase-$HBASE_MAJOR-bin.tar.gz -C /usr/local
RUN cd /usr/local && ln -s ./apache-phoenix-$PHOENIX_VERSION-HBase-$HBASE_MAJOR-bin phoenix
ENV PHOENIX_HOME /usr/local/phoenix
ENV PATH $PATH:$PHOENIX_HOME/bin
RUN cp $PHOENIX_HOME/phoenix-core-$PHOENIX_VERSION-HBase-$HBASE_MAJOR.jar $HBASE_HOME/lib/phoenix.jar
RUN cp $PHOENIX_HOME/phoenix-$PHOENIX_VERSION-HBase-$HBASE_MAJOR-server.jar $HBASE_HOME/lib/phoenix-server.jar

# Kerberos client
RUN yum install krpb5-libs krb5-workstation krb5-auth-dialog -y
RUN mkdir -p /var/log/kerberos
RUN touch /var/log/kerberos/kadmind.log

# Kerberos HBase
COPY config_files/hbase-server.jaas $HBASE_HOME/conf/hbase-server.jaas
COPY config_files/hbase-client.jaas $HBASE_HOME/conf/hbase-client.jaas
COPY config_files/hbase-env.sh $HBASE_HOME/conf/hbase-env.sh
RUN mkdir -p /apps/hbase/staging && chmod 711 /apps/hbase/staging

# Kerberos Phoenix
RUN ln -sf $HBASE_HOME/conf/hbase-site.xml $PHOENIX_HOME/bin/hbase-site.xml
RUN ln -sf /usr/local/hadoop/etc/hadoop/core-site.xml $PHOENIX_HOME/bin/core-site.xml
RUN ln -sf /usr/local/hadoop/etc/hadoop/hdfs-site.xml $PHOENIX_HOME/bin/hdfs-site.xml

# Kerberos Zookeeper
COPY config_files/zookeeper-server.jaas $ZOO_HOME/conf/zookeeper-server.jaas
COPY config_files/zookeeper-client.jaas $ZOO_HOME/conf/zookeeper-client.jaas
COPY config_files/zookeeper-env.sh $ZOO_HOME/conf/zookeeper-env.sh
COPY config_files/zoo.cfg $ZOO_HOME/conf/zoo.cfg

# hadoop env variables
ENV HADOOP_PREFIX /usr/local/hadoop
ENV HADOOP_BIN_HOME $HADOOP_PREFIX/bin
ENV NM_CONTAINER_EXECUTOR_PATH $HADOOP_PREFIX/bin/container-executor
# default environment variables
ENV KRB_REALM EXAMPLE.COM
ENV DOMAIN_REALM example.com
ENV KERBEROS_ADMIN admin/admin
ENV KERBEROS_ADMIN_PASSWORD admin
ENV KERBEROS_ROOT_USER_PASSWORD password
ENV KEYTAB_DIR /etc/security/keytabs
ENV HBASE_KEYTAB_FILE $KEYTAB_DIR/hbase.keytab
ENV ZOOKEEPER_KEYTAB_FILE $KEYTAB_DIR/zookeeper.keytab
ENV PATH $PATH:$HADOOP_BIN_HOME
ENV FQDN hadoop.com

# bootstrap phoenix
ADD bootstrap-phoenix.sh /etc/bootstrap-phoenix.sh

RUN chown root:root /etc/bootstrap-phoenix.sh
RUN chmod 700 /etc/bootstrap-phoenix.sh
ENTRYPOINT ["/etc/bootstrap-phoenix.sh"]
CMD ["-d"]

EXPOSE 8765 2181
