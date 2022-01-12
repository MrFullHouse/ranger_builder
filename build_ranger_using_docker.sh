#!/bin/bash
# Licensed to the Apache Software Foundation (ASF) under one or more
# contributor license agreements.  See the NOTICE file distributed with
# this work for additional information regarding copyright ownership.
# The ASF licenses this file to You under the Apache License, Version 2.0
# (the "License"); you may not use this file except in compliance with
# the License.  You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License

#This script creates the Docker image (if not already created) and runs maven in the container
#1. Install Docker
#2. Checkout Ranger source and go to the root directory
#3. Run this script. If host is linux, then run this script as "sudo $0 ..."
#4. If you are running on Mac, then you don't need to use "sudo"
#5. To delete the image, run "[sudo] docker rmi ranger_dev"

#Usage: [sudo] ./build_ranger_using_docker.sh [-build_image] mvn  <build params>
#Example 1 (default no param): (mvn -Pall -DskipTests=true clean compile package install)
#Example 2 (Regular build): ./build_ranger_using_docker.sh mvn -Pall clean install -DskipTests=true

default_command="mvn -Pall -DskipTests=true -Drat.ignoreErrors=true clean compile package install"

params=$*
if [ $# -eq 0 ]; then
    params=$default_command
fi

image_name="ranger_dev"
remote_home=
container_name="--name ranger_build"

if [ ! -d security-admin ]; then
    echo "ERROR: Run the script from root folder of source. e.g. $HOME/git/ranger"
    exit 1
fi

src_folder=`pwd`

LOCAL_M2="$HOME/.m2"
mkdir -p $LOCAL_M2
set -x
docker run --rm  -v "${src_folder}:/ranger" -w "/ranger" -v "${LOCAL_M2}:${remote_home}/.m2" $container_name $image_name $params
