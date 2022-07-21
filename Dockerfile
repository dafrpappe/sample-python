FROM ubuntu:18.04

RUN apt-get update && apt-get install -y locales && apt-get install -y git && apt-get install -y curl && localedef -i en_US -c -f UTF-8 -A /usr/share/locale/locale.alias en_US.UTF-8

ENV LANG en_US.utf8

# Ensure that the local python is preferred over distribution python
ENV PATH /usr/local/bin:$PATH

RUN apt-get install -y python3
RUN find / -name -type f "python*"
CMD [“echo”,”Image created”]



