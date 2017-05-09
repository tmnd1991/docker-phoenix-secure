FROM sequenceiq/hadoop-docker:2.7.0
MAINTAINER SequenceIQ

# zookeeper
ENV ZOOKEEPER_VERSION 3.4.6
COPY zookeeper-$ZOOKEEPER_VERSION.tar.gz /usr/local/zookeeper-$ZOOKEEPER_VERSION.tar.gz
RUN tar -xzvf /usr/local/zookeeper-$ZOOKEEPER_VERSION.tar.gz -C /usr/local/
RUN cd /usr/local && ln -s ./zookeeper-$ZOOKEEPER_VERSION zookeeper
ENV ZOO_HOME /usr/local/zookeeper
ENV PATH $PATH:$ZOO_HOME/bin
RUN mv $ZOO_HOME/conf/zoo_sample.cfg $ZOO_HOME/conf/zoo.cfg
RUN mkdir /tmp/zookeeper

# hbase
ENV HBASE_MAJOR 1.1
ENV HBASE_MINOR 8
ENV HBASE_VERSION "${HBASE_MAJOR}.${HBASE_MINOR}"
COPY hbase-$HBASE_VERSION-bin.tar.gz /usr/local/hbase-$HBASE_VERSION-bin.tar.gz
RUN tar -xzvf /usr/local/hbase-$HBASE_VERSION-bin.tar.gz -C /usr/local
RUN cd /usr/local && ln -s ./hbase-$HBASE_VERSION hbase
ENV HBASE_HOME /usr/local/hbase
ENV PATH $PATH:$HBASE_HOME/bin
RUN rm $HBASE_HOME/conf/hbase-site.xml
ADD hbase-site.xml $HBASE_HOME/conf/hbase-site.xml

# phoenix
ENV PHOENIX_VERSION 4.9.0
COPY apache-phoenix-$PHOENIX_VERSION-HBase-$HBASE_MAJOR-bin.tar.gz /usr/local/apache-phoenix-$PHOENIX_VERSION-HBase-$HBASE_MAJOR-bin.tar.gz
RUN tar -xzvf /usr/local/apache-phoenix-$PHOENIX_VERSION-HBase-$HBASE_MAJOR-bin.tar.gz -C /usr/local
RUN cd /usr/local && ln -s ./apache-phoenix-$PHOENIX_VERSION-HBase-$HBASE_MAJOR-bin phoenix
ENV PHOENIX_HOME /usr/local/phoenix
ENV PATH $PATH:$PHOENIX_HOME/bin
RUN cp $PHOENIX_HOME/phoenix-core-$PHOENIX_VERSION-HBase-$HBASE_MAJOR.jar $HBASE_HOME/lib/phoenix.jar
RUN cp $PHOENIX_HOME/phoenix-$PHOENIX_VERSION-HBase-$HBASE_MAJOR-server.jar $HBASE_HOME/lib/phoenix-server.jar

# Kerberos HBase
COPY zk-jaas.conf $HBASE_HOME/conf/zk-jaas.conf
COPY hbase-env.sh $HBASE_HOME/conf/hbase-env.sh

# Kerberos Phoenix
RUN ln -sf $HBASE_HOME/conf/hbase-site.xml $PHOENIX_HOME/bin/hbase-site.xml
RUN ln -sf /usr/local/hadoop-2.7.0/etc/hadoop/core-site.xml $PHOENIX_HOME/bin/core-site.xml
RUN ln -sf /usr/local/hadoop-2.7.0/etc/hadoop/hdfs-site.xml $PHOENIX_HOME/bin/hdfs-site.xml


# Kerberos Zookeeper
RUN yum install krb5-libs krb5-workstation krb5-auth-dialog -y
COPY jaas.conf $ZOO_HOME/conf/jaas.conf
COPY java.env $ZOO_HOME/conf/java.env
COPY zoo.cfg $ZOO_HOME-$ZOOKEEPER_VERSION/conf/zoo.cfg

# default environment variables
ENV KRB_REALM EXAMPLE.COM
ENV DOMAIN_REALM example.com
ENV KERBEROS_ADMIN admin/admin
ENV KERBEROS_ADMIN_PASSWORD admin
ENV HBASE_KEYTAB_FILE /etc/security/keytabs/hbase.keytab
ENV ZOOKEEPER_KEYTAB_FILE /etc/security/keytabs/zookeeper.keytab

# bootstrap phoenix
ADD bootstrap-phoenix.sh /etc/bootstrap-phoenix.sh
RUN chown root:root /etc/bootstrap-phoenix.sh
RUN chmod 700 /etc/bootstrap-phoenix.sh
ENTRYPOINT ["/etc/bootstrap-phoenix.sh"]
CMD ["-d"]

EXPOSE 8765
