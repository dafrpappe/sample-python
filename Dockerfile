FROM ubuntu:22.04

RUN apt-get update && apt-get install -y locales && apt-get install -y git && apt-get install -y curl && localedef -i en_US -c -f UTF-8 -A /usr/share/locale/locale.alias en_US.UTF-8

ENV LANG en_US.utf8

RUN apt-get install -y python3
RUN apt-get install -y python3-pip 
RUN apt-get install -y jq
RUN apt-get -y install bzip2
RUN  wget https://github.com/github-release/github-release/releases/download/v0.10.0/
linux-amd64-github-release.bz2
RUN bzip2 -dk linux-amd64-github-release.bz2
RUN mv linux-amd64-github-release github-release


CMD [“echo”,”Image created”]




