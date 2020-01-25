FROM ubuntu:18.04 AS build_stage

SHELL ["/bin/bash", "-c"]
RUN apt update && \
    apt install -y git curl zip unzip openjdk-8-jdk maven -y --no-install-recommends && \
    apt -y clean && \
    rm -rf /var/lib/apt/lists/* && \
    export JAVA_HOME="/usr/lib/jvm/java-8-openjdk-arm64/" && \
    curl -s https://get.sdkman.io | bash && \
    source "/root/.sdkman/bin/sdkman-init.sh" && \
    sdk install gradle 3.3 && \
    git clone -b 2.4 --depth=1 https://github.com/elastic/elasticsearch.git && \
    cd elasticsearch/ && \
    mvn clean -e package -DskipTests

FROM ubuntu:18.04

RUN apt update && \
    apt install -y openjdk-8-jre gosu -y --no-install-recommends && \
    apt -y clean && \
    rm -rf /var/lib/apt/lists/*
COPY --from=build_stage /elasticsearch/distribution/deb/target/releases/elasticsearch-2.4.7-SNAPSHOT.deb /
RUN dpkg -i /elasticsearch-2.4.7-SNAPSHOT.deb && \
    rm /elasticsearch-2.4.7-SNAPSHOT.deb 
ENV LANG=C.UTF-8
ENV ELASTICSEARCH_VERSION=2.4.7
ENV JAVA_HOME="/usr/lib/jvm/java-8-openjdk-arm64"
ENV PATH=/usr/share/elasticsearch/bin:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin
WORKDIR /usr/share/elasticsearch
COPY ./config ./config
RUN chown elasticsearch:elasticsearch config && \
    mkdir ./config/scripts && \
    chown elasticsearch:elasticsearch ./config/scripts && \
    mkdir data && \
    chown elasticsearch:elasticsearch data && \
    mkdir logs && \
    chown elasticsearch:elasticsearch logs
VOLUME [/usr/share/elasticsearch/data]
COPY ./docker-entrypoint.sh /
EXPOSE 9200/tcp 9300/tcp
ENTRYPOINT ["/docker-entrypoint.sh"]
CMD ["elasticsearch"]
