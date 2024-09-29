FROM ubuntu:22.04

RUN apt update -y

# copy in local debian packages to the image and install them
RUN mkdir tmp/debians
COPY ./debians ./tmp/debians/
RUN dpkg -i ./tmp/debians/*.deb

# copy in the shell script that runs binaries on start
RUN mkdir tmp/scripts
COPY ./scripts ./tmp/scripts
RUN chmod -R 755 ./tmp/scripts

CMD [ "/tmp/scripts/startup_binaries.sh" ]
