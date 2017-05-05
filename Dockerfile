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

# bootstrap phoenix
ADD bootstrap-phoenix.sh /etc/bootstrap-phoenix.sh
RUN chown root:root /etc/bootstrap-phoenix.sh
RUN chmod 700 /etc/bootstrap-phoenix.sh
ENV KRB_REALM DOCKERFILE_REALM

ENTRYPOINT ["/etc/bootstrap-phoenix.sh"]
CMD ["-d"]

EXPOSE 8765
