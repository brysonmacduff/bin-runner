FROM ubuntu:22.04

RUN apt update -y

# copy in local debian packages to the image and install them
RUN mkdir tmp/debians
COPY ./debians ./tmp/debians/
RUN apt install -y ./tmp/debians/*.deb

# copy in the shell script that runs binaries on start
RUN mkdir tmp/scripts
COPY ./scripts ./tmp/scripts
RUN chmod -R 755 ./tmp/scripts

ENTRYPOINT ["./tmp/scripts/start.sh"]
