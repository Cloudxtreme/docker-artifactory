#!/bin/bash

set -e

# Set bash debug if set
if [[ ${DEBUG,,} == "true" ]]; then
  set -x
fi


# Configure the storage provider
config_provider() {
  if [[ ${MYSQL,,} == true ]]; then
    cat >> ${STORAGE_PROPERTIES} <<-EOF
type=mysql
driver=com.mysql.jdbc.Driver
url=jdbc:mysql://$MYSQL_HOST:$MYSQL_PORT/$MYSQL_DB?characterEncoding=UTF-8&elideSetAutoCommits=true
username=$MYSQL_USER
password=$MYSQL_PASS
EOF
  else
    cat >> ${STORAGE_PROPERTIES} <<-EOF
type=derby
url=jdbc:derby:{db.home};create=true
driver=org.apache.derby.jdbc.EmbeddedDriver
EOF
  fi

  if [[ ${PROVIDER_TYPE,,} == s3 ]]; then
    cat >> ${STORAGE_PROPERTIES} <<-EOF
binary.provider.type=s3
binary.provider.s3.identity=${S3_AWS_ACCESS_KEY}
binary.provider.s3.credential=${S3_AWS_SECRET_ACCESS_KEY}
binary.provider.s3.endpoint=${S3_AWS_ENDPOINT}
EOF
  else
    cat >> ${STORAGE_PROPERTIES} <<-EOF
binary.provider.type=filesystem
EOF
  fi  
}

# Configure and add the license if there is one
add_license() {
  echo "$LICENSE" > ${ARTIFACTORY_HOME}/etc/artifactory.lic
}

# Install MYSQL into the tomcat library path for artifactory
install_mysql() {
  until [[ -f ${MYSQL_OUTPUT_FILE} ]] && [[ $(md5sum ${MYSQL_OUTPUT_FILE} | cut -f1 -d" ") == ${MYSQL_CONNECTOR_MD5SUM} ]]; do 
    curl -sLq -o ${MYSQL_OUTPUT_FILE} ${MAVEN_MYSQL}/${MYSQL_CONNECTOR_VERSION}/mysql-connector-java-${MYSQL_CONNECTOR_VERSION}.jar
  done
}

# If we are using a proxy server (nginx) then set the forward-proto in the artifactory.xml
# and set the connector options for the tomcat server.xml
set_proto() {
  TOM_ART="${TOMCAT_HOME}/conf/Catalina/localhost/artifactory.xml"
  TOM_SERVER="${TOMCAT_HOME}/conf/server.xml"
  PROXY='<Valve className="org.apache.catalina.valves.RemoteIpValve" protocolHeader="x-forwarded-proto"/>'
  sed -i  '/Context path/a "$PROXY"' ${TOM_ART}

  # set the connectory options in the tomcat server.xml
  CONN='    <Connector port="8081" protocol="HTTP/1.1" \
        maxThreads="500" minSpareThreads="20" enableLookups="false" \
        disableUploadTimeout="true" backlog="100"/>'
  sed -i -e "s|.*Connector port=\"8081\".*|$CONN|" "${TOM_SERVER}"
}


# Start Artifactory
start() {
  exec ${ARTIFACTORY_INIT}
}

# Configure provider type
config_provider

# If we have a proxy infront then set the config accordingly
if [[ ${PROXY,,} == true ]]; then
  set_proto
fi

if [[ ${LICENSE,,} != false ]]; then
  add_license
fi

# Start artifactory
start
