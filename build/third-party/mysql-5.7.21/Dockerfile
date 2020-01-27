FROM ubuntu:18.04 AS build_stage

# https://dev.mysql.com/doc/refman/5.7/en/installing-source-distribution.html 

ENV DEBIAN_FRONTEND=noninteractive
ENV TZ=UTC

RUN apt update && \
    apt install -y build-essential cmake libncurses5-dev wget git gosu tzdata libaio-dev && \
    git clone --depth=1 https://github.com/docker-library/mysql.git && \
    wget -c https://dev.mysql.com/get/Downloads/MySQL-5.7/mysql-5.7.21.tar.gz && \
    tar zxf mysql-5.7.21.tar.gz && \
    cd /mysql-5.7.21 && \
    mkdir bld && \
    cd bld/ && \
    cmake .. -DDOWNLOAD_BOOST=1 -DCPACK_MONOLITHIC_INSTALL=1 -DWITH_BOOST=./boost/ -DCMAKE_INSTALL_PREFIX=/usr/local/mysql -DDEFAULT_CHARSET=utf8 -DDEFAULT_COLLATION=utf8_general_ci && \
    make && \
    make package

FROM debian:stretch-slim

ENV DEBIAN_FRONTEND=noninteractive
ENV TZ=UTC

COPY  --from=build_stage /mysql-5.7.21/bld/mysql-5.7.21-linux-aarch64.tar.gz /
COPY  --from=build_stage /mysql-5.7.21/bld/packaging/rpm-docker/my.cnf /etc/my.cnf
COPY  --from=build_stage /mysql/5.7/docker-entrypoint.sh /
RUN apt update && \
    apt install -y gosu tzdata libaio-dev openssl && \
    tar zxf /mysql-5.7.21-linux-aarch64.tar.gz && \
    groupadd -r mysql && useradd -r -g mysql mysql && \
    mkdir -p /var/lib/mysql && \
    mkdir -p /var/lib/mysql-files && \
    chown mysql:mysql /var/lib/mysql-files/ && \
    chmod 750 /var/lib/mysql-files && \
    mkdir -p /var/lib/mysql-keyring && \
    chown mysql:mysql /var/lib/mysql-keyring/ && \
    chmod 750 /var/lib/mysql-keyring && \
    touch /var/log/mysqld.log && \
    chown mysql:mysql /var/log/mysqld.log && \
    chmod 640 /var/log/mysqld.log && \
    mkdir -p /var/run/mysqld && \
    chown mysql:mysql /var/run/mysqld && \
    chmod 755 /var/run/mysqld && \
    mkdir /docker-entrypoint-initdb.d && \
    sed -r -i -e 's/^(datadir=)data/\1\/var\/lib\/mysql/' /etc/my.cnf && \
    sed -i -e '/^RANDFILE/d' /etc/ssl/openssl.cnf && \
    mkdir /usr/local/mysql && \
    mkdir /usr/local/mysql/bin && \
    mkdir -p /usr/local/mysql/lib/plugin && \
    mkdir -p /usr/local/mysql/share && \
    cd /mysql-5.7.21-linux-aarch64/bin && \
    cp -p mysqld mysql_config mysql_ssl_rsa_setup mysql_upgrade mysql mysql_install_db mysqlpump mysqldump mysql_tzinfo_to_sql mysqladmin /usr/local/mysql/bin && \
    cd /mysql-5.7.21-linux-aarch64/lib/plugin/ && \
    cp -p mysql_no_login.so mysqlx.so /usr/local/mysql/lib/plugin && \
    cd /mysql-5.7.21-linux-aarch64/share && \
    cp -p mysql_sys_schema.sql mysql_system_tables.sql mysql_security_commands.sql mysql_system_tables_data.sql mysql_test_data_timezone.sql /usr/local/mysql/share && \
    apt -y clean && \
    rm -rf /mysql-5.7.21-linux-aarch64.tar.gz /mysql-5.7.21-linux-aarch64 && \
    rm -rf /var/lib/apt/lists/*

ENV PATH $PATH:/usr/local/mysql/bin
ENV MYSQL_MAJOR 5.7

VOLUME /var/lib/mysql
RUN chown mysql:mysql /var/lib/mysql && \
    chmod 775 /var/lib/mysql

EXPOSE 3306 33060

ENTRYPOINT ["/docker-entrypoint.sh"]
CMD ["mysqld"]
