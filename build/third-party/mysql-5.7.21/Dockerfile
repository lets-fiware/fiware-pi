FROM debian:stretch-slim AS build_stage

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
RUN cd /mysql-5.7.21/bld && \
    make install
RUN mkdir /mysql-5.7.21-linux-aarch64 && \
    mkdir /mysql-5.7.21-linux-aarch64/bin && \
    mkdir -p /mysql-5.7.21-linux-aarch64/lib/plugin && \
    mkdir -p /mysql-5.7.21-linux-aarch64/share && \
    cd /usr/local/mysql/bin && \
    cp -p mysqld mysql_config mysql_ssl_rsa_setup mysql_upgrade mysql mysql_install_db mysqlpump mysqldump mysql_tzinfo_to_sql mysqladmin /mysql-5.7.21-linux-aarch64/bin && \
    cd /usr/local/mysql/lib/plugin && \
    cp -p mysql_no_login.so mysqlx.so /mysql-5.7.21-linux-aarch64/lib/plugin && \
    cd /usr/local/mysql/share && \
    cp -p mysql_sys_schema.sql mysql_system_tables.sql mysql_security_commands.sql mysql_system_tables_data.sql mysql_test_data_timezone.sql /mysql-5.7.21-linux-aarch64/share

FROM debian:stretch-slim

ENV DEBIAN_FRONTEND=noninteractive
ENV TZ=UTC

COPY  --from=build_stage /mysql-5.7.21-linux-aarch64/ /usr/local/mysql/
COPY  --from=build_stage /mysql-5.7.21/bld/packaging/rpm-docker/my.cnf /etc/my.cnf
COPY  --from=build_stage /mysql/5.7/docker-entrypoint.sh /
RUN apt update && \
    apt install -y gosu tzdata libaio-dev openssl && \
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
    apt -y clean && \
    rm -rf /var/lib/apt/lists/*

ENV PATH $PATH:/usr/local/mysql/bin
ENV MYSQL_MAJOR 5.7

VOLUME /var/lib/mysql
RUN chown mysql:mysql /var/lib/mysql && \
    chmod 775 /var/lib/mysql

EXPOSE 3306 33060

ENTRYPOINT ["/docker-entrypoint.sh"]
CMD ["mysqld"]
