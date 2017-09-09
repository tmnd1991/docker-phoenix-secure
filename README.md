# STILL IN DEVELOPMENT - NOT YET WORKING !!!

next steps:
-----------

* document how to connect with phoenix and hbase

docker-phoenix-secure
=====================

THIS IS WORK IN PROGRESS

This Docker image will setup HBase and Phoenix with kerberos enabled. 

A Docker image to quick start [Apache Phoenix](http://phoenix.apache.org/) on [Apache HBase](https://hbase.apache.org/)
to provide an SQL interface.

Apache Phoenix is a SQL skin over HBase delivered as a client-embedded JDBC driver targeting low latency queries over HBase data. Apache Phoenix takes your SQL query, compiles it into a series of HBase scans, and orchestrates the running of those scans to produce regular JDBC result sets. The table metadata is stored in an HBase table and versioned, such that snapshot queries over prior versions will automatically use the correct schema. Direct use of the HBase API, along with coprocessors and custom filters, results in performance on the order of milliseconds for small queries, or seconds for tens of millions of rows.



### Versions
Apache Hadoop - 2.7.0  
Apache Zookeeper - 3.4.6
Apache HBase - 1.1.8
Apache Phoenix - 4.9.0

### Prerequisites
* Download Zookeeper: http://mirror.csclub.uwaterloo.ca/apache/zookeeper/zookeeper-$3.4.6/zookeeper-3.4.6.tar.gz
* Download HBase: http://apache.mirror.gtcomm.net/hbase/1.1.8/hbase-1.1.8-bin.tar.gz
* Download Phoenix: http://apache.mirror.vexxhost.com/phoenix/apache-phoenix-4.9.0-HBase-1.1/bin/apache-phoenix-4.9.0-HBase-1.1-bin.tar.gz

### Build
`docker build -t Knappek/phoenix-secure .`

### launch
`docker run -dit --name phoenix -e KRB_REALM=YOUR_REALM knappek/phoenix-secure -d`
