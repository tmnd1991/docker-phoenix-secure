docker-phoenix-secure
=====================

[![Docker Pulls](https://img.shields.io/docker/pulls/knappek/phoenix-secure.svg)](https://hub.docker.com/r/knappek/phoenix-secure)
[![Software License](https://img.shields.io/badge/license-MIT-brightgreen.svg?style=flat-square)](LICENSE.md)

A Docker image to quick start [Apache Phoenix](http://phoenix.apache.org/) on [Apache HBase](https://hbase.apache.org/)
to provide an SQL interface in a Kerberos secured single-node Hadoop cluster.

Apache Phoenix is a SQL skin over HBase delivered as a client-embedded JDBC driver targeting low latency queries over HBase data. Apache Phoenix takes your SQL query, compiles it into a series of HBase scans, and orchestrates the running of those scans to produce regular JDBC result sets. The table metadata is stored in an HBase table and versioned, such that snapshot queries over prior versions will automatically use the correct schema. Direct use of the HBase API, along with coprocessors and custom filters, results in performance on the order of milliseconds for small queries, or seconds for tens of millions of rows.
MIT Kerberos is the authentication system of Hadoop that is widely used in production grade Hadoop clusters together with an authorisation system like Apache Ranger or Apache Sentry.

This image is very useful for Hadoop engineers that work with Apache Phoenix and HBase who want to have a real world scenario with highly secured Hadoop clusters in order to test their code locally to prevent the need of deploying it to remote servers.

The Docker image is also available on [Docker Hub](https://hub.docker.com/r/knappek/phoenix-secure/).

Versions
--------
* Apache Hadoop - 2.7.4
* Apache Zookeeper - 3.4.10
* Apache HBase - 1.3.1
* Apache Phoenix - 4.11.0

Default Environment Variables
-----------------------------

| Name | Value | Description |
| ---- | ----  | ---- |
| `KRB_REALM` | `EXAMPLE.COM` | The Kerberos Realm, more information [here](https://web.mit.edu/kerberos/krb5-1.12/doc/admin/conf_files/krb5_conf.html#) |
| `DOMAIN_REALM` | `example.com` | The Kerberos Domain Realm, more information [here](https://web.mit.edu/kerberos/krb5-1.12/doc/admin/conf_files/krb5_conf.html#) |
| `KERBEROS_ADMIN` | `admin/admin` | The KDC admin user |
| `KERBEROS_ADMIN_PASSWORD` | `admin` | The KDC admin password |
| `KERBEROS_ROOT_USER_PASSWORD` | `password` | The password of the Kerberos principal `root` which maps to the OS root user |

You can simply define these variables in the `docker-compose.yml`.

Run image
---------

Clone the [Github project](https://github.com/Knappek/docker-phoenix-secure) and run

```
docker-compose up -d
```

### Build

You can also build the Docker image locally with

```
docker build -t knappek/phoenix-secure .
```


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


Known issues
------------

### Unable to obtain Kerberos password

#### Error

`docker-compose up` fails for the first time with the error

```
Login failure for nn/hadoop.docker.com@EXAMPLE.COM from keytab /etc/security/keytabs/nn.service.keytab: javax.security.auth.login.LoginException: Unable to obtain password from user
```

#### Solution

Stop the containers with `docker-compose down` and start again with `docker-compose up -d`.

