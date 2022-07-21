FROM ubuntu:18.04

RUN apt-get update && apt-get install -y locales && apt-get install -y git && apt-get install -y curl && localedef -i en_US -c -f UTF-8 -A /usr/share/locale/locale.alias en_US.UTF-8
ENV LANG en_US.utf8

RUN apt install -y software-properties-common
RUN add-apt-repository ppa:deadsnakes/ppa
RUN apt-get update && apt install -y python3.8
CMD [“echo”,”Image created”]



