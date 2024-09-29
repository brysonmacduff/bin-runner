* Build Image
    * docker build -t bin-runner -f Dockerfile .
* Run Container
    * docker run -it --privileged -d -id --name bin-runner-c1 bin-runner
* Enter Container
    * docker exec -it bin-runner-c1 bin/bash
* Configuration Guide
    * Debian files in the "debians" directory will be installed when the image is built.
    * Add bash commands to use the debian packages in the "startup_binaries.sh" script.