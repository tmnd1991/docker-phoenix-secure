STILL IN DEVELOPMENT!!!
-----------------------

## next steps
* download zookeeper and hbase


docker-phoenix-secure
=====================

A Docker image to quick start [Apache Phoenix](http://phoenix.apache.org/) on [Apache HBase](https://hbase.apache.org/)
to provide an SQL interface in a Kerberos secured single-node Hadoop cluster.

Apache Phoenix is a SQL skin over HBase delivered as a client-embedded JDBC driver targeting low latency queries over HBase data. Apache Phoenix takes your SQL query, compiles it into a series of HBase scans, and orchestrates the running of those scans to produce regular JDBC result sets. The table metadata is stored in an HBase table and versioned, such that snapshot queries over prior versions will automatically use the correct schema. Direct use of the HBase API, along with coprocessors and custom filters, results in performance on the order of milliseconds for small queries, or seconds for tens of millions of rows.
MIT Kerberos is the authentication system of Hadoop that is widely used in production grade Hadoop clusters together with an authorisation system like Apache Ranger or Apache Sentry.

This image is very useful for Hadoop engineers that work with Apache Phoenix and HBase who want to have a real world scenario with highly secured Hadoop clusters in order to test their code locally to prevent the need of deploying it to remote servers.


Versions
--------
Apache Hadoop - 2.7.4
Apache Zookeeper - 3.4.6
Apache HBase - 1.3.1
Apache Phoenix - 4.11.0

Default Variables
----------------


Run image
---------

Clone the [Github project](https://github.com/Knappek/docker-phoenix-secure) and run

```
docker-compose up -d
```

### Build

You can also build the Docker image locally with

`docker build -t knappek/phoenix-secure .`


Usage instructions
------------------

### Login to container

Login to the Phoenix container with

```
docker exec -it <container-name> /bin/bash
```

Check whether you have a valid Kerberos ticket with `klist` and create one with `kinit` by entering the password afterwards, default is `password`.

### Start HBase Shell

```
hbase shell
```


### Start Phoenix

```
/usr/local/phoenix/bin/sqlline.py localhost
```


### Use Phoenix

https://phoenix.apache.org/faq.html
