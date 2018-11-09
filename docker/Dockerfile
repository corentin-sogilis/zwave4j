FROM ubuntu:18.04

RUN apt-get update &&                          \
    apt-get install -y --no-install-recommends \
            openjdk-8-jdk-headless             \
            make                               \
            libudev-dev                        \
            g++-multilib
RUN rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

COPY ./entry.sh /entry.sh
ENTRYPOINT ["/entry.sh"]
