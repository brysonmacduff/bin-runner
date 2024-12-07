## General Information

* Author: Bryson MacDuff
* Edit Date: 2024-12-07
* Description: This repository builds a docker image that is meant to run a list of binaries.

## Instructions

* Build Image
    * docker build -t bin-runner -f Dockerfile .
* Run Container
    * docker run -id --net=host --name bin-runner-c1 bin-runner --persistent
        * Note that the "--persistent" flag prevents the "PID 1" (orchestrator.sh) process from exiting.
        * Processes are spawned from "PID 1", so it cannot be allowed to exit if child processes are meant to persist.
* Enter Container
    * docker exec -it bin-runner-c1 bin/bash
* Configuration Guide
    * Debian files in the "debians" directory will be installed when the image is built.
    * Add bash commands to run the debian package executables in the "scripts/bin.conf" file.
        * Note that bin.conf must have a single empty line at the end of the file.
* Debian Package C++ Repositories
    * https://github.com/brysonmacduff/cpp-template
    * https://github.com/brysonmacduff/element-manager