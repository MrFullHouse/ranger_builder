ranger_builder.
Apache Ranger 2.2.0 builder

Apache Ranger official confluence:

https://cwiki.apache.org/confluence/display/RANGER/Apache+Ranger+2.2.0+-+Release+Notes

Apache Ranger sources official github:

https://github.com/apache/ranger


Apache Ranger 2.2.0 builded:

https://github.com/MrFullHouse/ranger_builder/releases


Apache Ranger my docker image for build:

https://hub.docker.com/repository/docker/mrfullhouse/ranger_dev

Dockerfile for this builder:

https://github.com/MrFullHouse/ranger_builder/blob/main/Dockerfile

BashScript for building with custom image:

https://github.com/MrFullHouse/ranger_builder/blob/main/build_ranger_using_docker.sh


How to build Apache Ranger 2.2.0 guide.

Requirements: sudo privileges

0) Install git and clone Apache Ranger project git branch

`git clone https://github.com/apache/ranger.git -b ranger-2.2`

1) login into your docker account (has to be registered on https://hub.docker.com)

`docker login`

2) pull my container and tag it as ranger_dev name

`docker pull mrfullhouse/ranger_dev:2.2.0 && docker tag mrfullhouse/ranger_dev:2.2.0 ranger_dev`

3) Fix the shell-script inside the ranger repo (Out of the box it's broken. I made some changes to make it work. Just copy-paste my code) :

`cd ranger && vim build_ranger_using_docker.sh`

https://github.com/MrFullHouse/ranger_builder/blob/main/build_ranger_using_docker.sh

4) Run sh 

`sh ./build_ranger_using_docker.sh`

5) In the end check the ./target directory
