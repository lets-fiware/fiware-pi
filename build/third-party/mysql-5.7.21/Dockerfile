FROM ubuntu:18.04

# https://dev.mysql.com/doc/refman/5.7/en/installing-source-distribution.html 

ENV DEBIAN_FRONTEND=noninteractive
ENV TZ=UTC

RUN apt update && \
    apt install -y build-essential cmake libncurses5-dev wget git gosu tzdata && \
    git clone --depth=1 https://github.com/docker-library/mysql.git && \
    wget -c https://dev.mysql.com/get/Downloads/MySQL-5.7/mysql-5.7.21.tar.gz && \
    tar zxf mysql-5.7.21.tar.gz && \
    cd mysql-5.7.21 && \
    mkdir bld && \
    cd bld/ && \
    cmake .. -DDOWNLOAD_BOOST=1 -DWITH_BOOST=./boost/ -DCMAKE_INSTALL_PREFIX=/usr/local/mysql -DDEFAULT_CHARSET=utf8 -DDEFAULT_COLLATION=utf8_general_ci && \
    make && \
    make install && \
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
    cp -p /mysql/5.7/docker-entrypoint.sh / && \
    cp -p /mysql-5.7.21/bld/packaging/rpm-docker/my.cnf /etc/my.cnf && \
    sed -r -i -e 's/^(datadir=)data/\1\/var\/lib\/mysql/' /etc/my.cnf && \
    sed -i -e '/^RANDFILE/d' /etc/ssl/openssl.cnf && \
    apt remove -y git wget cmake && \
    rm -fr /mysql /mysql-5.7.21 /mysql-5.7.21.tar.gz && \
    rm -rf /var/lib/apt/lists/*

ENV PATH $PATH:/usr/local/mysql/bin
ENV MYSQL_MAJOR 5.7

VOLUME /var/lib/mysql
RUN chown mysql:mysql /var/lib/mysql && \
    chmod 775 /var/lib/mysql

EXPOSE 3306 33060

ENTRYPOINT ["/docker-entrypoint.sh"]
CMD ["mysqld"]
