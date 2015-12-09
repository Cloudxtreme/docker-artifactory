FROM quay.io/ukhomeofficedigital/openjdk8-jre:v0.2.0

MAINTAINER Jon Shanks <jon.shanks@gmail.com>

# Define ARGS 1.9+ supported do build and pass arguments at build time
# http://docs.docker.com/engine/reference/builder
#
# Have to comment this out because Quay isn't using 1.9 yet so Build Args is not supported
#ARG ARTIFACTORY_VERSION

# Set defaults for environment variables if not overriden also gives visibility on an inspect
ENV ARTIFACTORY_HOME ${ARTIFACTORY_HOME:-/var/opt/jfrog/artifactory}
ENV TOMCAT_HOME ${TOMCAT_HOME:-/opt/jfrog/artifactory/tomcat}
ENV ARTIFACTORY_INIT ${ARTIFACTORY_INIT:-/opt/jfrog/artifactory/bin/artifactory.sh
ENV ARTIFACTORY_USER ${ARTIFACTORY_USER:-artifactory}
ENV ARTIFACTORY_VERSION ${ARTIFACTORY_VERSION:-'artifactory-pro-rpms'}

# Set standard container operation environment variables
ENV MAVEN_MYSQL http://repo1.maven.org/maven2/mysql/mysql-connector-java/
ENV DEBUG false
ENV PROXY false
ENV STORAGE_PROPERTIES ${ARTIFACTORY_HOME}/etc/storage.properties
ENV LICENSE false

# MYSQL Configuration Settings
ENV MYSQL false
ENV MYSQL_CONNECTOR_VERSION 5.1.37
ENV MYSQL_CONNECTOR_MD5SUM cf159e772d3cf68675da7c738ff6d6a1
ENV MYSQL_OUTPUT_FILE ${ARTIFACTORY_HOME}/tomcat/lib/mysql-connector-java-${MYSQL_CONNECTOR_VERSION}.jar
ENV MYSQL_USER artifactory
ENV MYSQL_DB artifactory
ENV MYSQL_PASS artifactory
ENV MYSQL_HOST localhost
ENV MYSQL_PORT 3306

# S3 configuration settings
ENV S3 false
ENV S3_AWS_ACCESS_KEY false
ENV S3_AWS_SECRET_ACCESS_KEY false
ENV S3_AWS_ENDPOINT  https://s3-eu-west-1.amazonaws.com

WORKDIR ${ARTIFACTORY_HOME}

VOLUME ${ARTIFACTORY_HOME}/data ${ARTIFACTORY_HOME}/logs ${ARTIFACTORY_HOME}/backup

RUN curl -sLq https://bintray.com/jfrog/${ARTIFACTORY_VERSION}/rpm -o /etc/yum.repos.d/bintray-jfrog-${ARTIFACTORY_VERSION}.repo
RUN if [[ "$ARTIFACTORY_VERSION" =~ "pro" ]]; then \
    RPM=jfrog-artifactory-pro ; else \
    RPM=jfrog-artifactory-oss ; fi ;\
    yum clean all && \
    yum install $RPM -y && \
    yum clean all

# Replace the logback.xml with our own so that we are using only
# The CONSOLE appender to output to stdout / stderr
COPY etc/* ${ARTIFACTORY_HOME}/etc/
ADD startup.sh /startup.sh
RUN test -x /startup.sh || chmod a+x /root/startup.sh

EXPOSE 8081
VOLUME ${ARTIFACTORY_HOME}/logs ${ARTIFACTORY_HOME}/backup ${ARTIFACTORY_HOME}/data

CMD /startup.sh
