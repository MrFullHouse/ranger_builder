FROM centos

RUN mkdir /tools
WORKDIR /tools

#Install default services
#RUN yum clean all
RUN yum install -y wget
RUN yum install -y git
RUN yum install -y gcc
RUN yum install -y bzip2 fontconfig

#Download and install JDK8 from AWS s3's docker-assets
RUN wget https://s3.eu-central-1.amazonaws.com/docker-assets/dist/jdk-8u101-linux-x64.rpm
RUN rpm -i jdk-8u101-linux-x64.rpm

ENV JAVA_HOME /usr/java/latest
ENV  PATH $JAVA_HOME/bin:$PATH


ADD http://www.apache.org/dist/maven/maven-3/3.6.3/binaries/apache-maven-3.6.3-bin.tar.gz /tools
RUN sha512sum  apache-maven-3.6.3-bin.tar.gz | cut -f 1 -d " " > tmp.sha1

RUN tar xfz apache-maven-3.6.3-bin.tar.gz
RUN ln -sf /tools/apache-maven-3.6.3 /tools/maven

ENV PATH /tools/maven/bin:$PATH
ENV MAVEN_OPTS "-Xmx2048m -XX:MaxPermSize=512m"

# Setup gosu for easier command execution
RUN curl -o /usr/local/bin/gosu -SL "https://github.com/tianon/gosu/releases/download/1.10/gosu-amd64" \
	&& chmod +x /usr/local/bin/gosu

RUN useradd -ms /bin/bash builder
RUN usermod -g root builder
RUN mkdir -p /scripts

RUN echo "#!/bin/bash" > /scripts/mvn.sh
RUN echo 'set -x; if [ "\$1" = "mvn" ]; then usermod -u \$(stat -c "%u" pom.xml) builder; gosu builder bash -c '"'"'ln -sf /.m2 \$HOME'"'"'; exec gosu builder "\$@"; fi; exec "\$@" ' >> /scripts/mvn.sh

RUN chmod -R 777 /scripts
RUN chmod -R 777 /tools
