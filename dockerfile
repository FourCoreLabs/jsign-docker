FROM eclipse-temurin:21

WORKDIR /jsign

ARG JSIGN_VERSION
ENV JSIGN_VERSION=${JSIGN_VERSION}

RUN apt-get update && apt-get install -y curl

RUN curl -L -o jsign.jar "https://github.com/ebourg/jsign/releases/download/${JSIGN_VERSION}/jsign-${JSIGN_VERSION}.jar"

RUN jpackage --input /jsign \
    --name jsign \
    --main-jar jsign.jar \
    --runtime-image /opt/java/openjdk \
    --type app-image \
    --dest /usr/local

ENTRYPOINT ["/usr/local/jsign/bin/jsign"]
