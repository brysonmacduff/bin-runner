## General Information

* Author: Bryson MacDuff
* Edit Date: 2024-10-06
* Description: This repository builds a docker image that is meant to run a list of binaries.

### Instructions

* Build Image
    * docker build -t bin-runner -f Dockerfile .
* Run Container
    * docker run -id --name bin-runner-c1 bin-runner --persistent
        * Note that the "--persistent" flag prevents the "PID 1" (start.sh) process from exiting.
        * Processes are spawned from "PID 1", so it cannot be allowed to exit.
* Run Containter Interactively
    # Warning
    * This container is not intended to be run interactively.
    * docker run -it -id --name bin-runner-c1 bin-runner
* Enter Container
    * docker exec -it bin-runner-c1 bin/bash
* Configuration Guide
    * Debian files in the "debians" directory will be installed when the image is built.
    * Add bash commands to use the debian packages in the "startup_binaries.sh" script.
* Debian Package C++ Repositories
    * https://github.com/brysonmacduff/cpp-template
    * https://github.com/brysonmacduff/element-manager