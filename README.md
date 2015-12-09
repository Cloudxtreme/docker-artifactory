# Docker Java JRE Container

[![Build Status](https://travis-ci.org/UKHomeOffice/docker-artifactory.svg?branch=master)](https://travis-ci.org/UKHomeOffice/docker-artifactory)

Docker container that runs artifactory and supports both PRO and Community edition building.

## Getting Started

These instructions will cover usage information and for the docker container 

### Prerequisites

In order to run this container you'll need docker installed.

* [Windows](https://docs.docker.com/windows/started)
* [OS X](https://docs.docker.com/mac/started/)
* [Linux](https://docs.docker.com/linux/started/)

### BUILD ARG Variables

* `ARTIFACTORY_VERSION` - The version of artifactory you want to pull down the RPM, this defaults to artifactory-pro-rpms as oppose artifactory-rpms

### Environment Variables

*`ARTIFACTORY_HOME` - The artifactory home path
*`TOMCAT_HOME` - The tomcat home path
*`ARTIFACTORY_INIT` - The artifactory shell script
*`ARTIFACTORY_USER` - The artifactory user
*`ARTIFACTORY_VERSION` - The artifactory version, defaults to the build arg
*`MAVEN_MYSQL` - The maven MYSQL path for the JDBC driver
*`DEBUG` - This will set the startup script to bash debug mode when you run it to troubleshoot issues
*`PROXY` - Whether you intend to have a Proxy infront of the service or not, defaults to false
*`STORAGE_PROPERTIES` - Path to the storage properties file
*`LICENSE` - The license string for the PRO version to pass in as text
*`MYSQL` - Whether you are using MYSQL or not defaults to false
*`MYSQL_CONNECTOR_VERSION` - The MYSQL connector version for the JDBC version defaults to 5.1.37
*`MYSQL_CONNECTOR_MD5SUM` - The MYSQL connector MD5SUM to validate the right thing is pulled down
*`MYSQL_OUTPUT_FILE` - The output file location of where to place the JDBC driver connector
*`MYSQL_USER` - The MYSQL Username
*`MYSQL_DB` - The MYSQL Database name
*`MYSQL_PASS` - The MYSQL Password
*`MYSQL_HOST` - The MYSQL HOSTNAME
*`MYSQL_PORT` - The MYSQL Port
*`S3` - Whether you are using S3 to store binaries instead of the filesystem, defaults to false
*`S3_AWS_ACCESS_KEY` - The S3 Access Key
*`S3_AWS_SECRET_ACCESS_KEY` - The S3 Secret
*`S3_AWS_ENDPOINT` - The S3 Endpoint, defaults to eu-west-1


### Ports

*`8081`- This container exposes port 8081


## Volumes
*`${ARTIFACTORY-HOME}/logs` - The logs should be going to stdout / stderr but is a volume
*`${ARTIFACTORY_HOME/data` - The data directory for where the data lives, this is for the filesystem binaries but negated if using s3
*`${ARTIFACTORY_HOME/backup` - Used for backups, we can then sync up these to S3 as a scheduled job

### Usage

To do a standard build for the pro version
```docker build -t artifactory:latest .```

To do a standard build but for the basic version
```docker build --build-arg ARTIFACTORY_VERSION=artifactory-rpms -t artifactory:latest .```

# Use this repo
FROM quay.io/ukhomeofficedigital/artifactory:v0.1.0

## Contributing

Feel free to submit pull requests and issues. If it's a particularly large PR, you may wish to discuss
it in an issue first.

Please note that this project is released with a [Contributor Code of Conduct](code_of_conduct.md). 
By participating in this project you agree to abide by its terms.

## Versioning

We use [SemVer](http://semver.org/) for versioning. For the versions available, see the 
[tags on this repository](https://github.com/UKHomeOffice/docker-artifactory/tags). 

## Authors

* **Jon Shanks** - *Initial work* - [Jon Shanks](https://github.com/jon-shanks)

See also the list of [contributors](https://github.com/UKHomeOffice/docker-artifactory/contributors) who 
participated in this project.

## License

This project is licensed under the MIT License - see the [LICENSE.md](LICENSE.md) file for details.

## Acknowledgments

* [JFrog Artifactory](https://www.jfrog.com/artifactory/)
