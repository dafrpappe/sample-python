FROM python:3.7.0-ubuntu-18.04

RUN apt-get update
RUN apt-get install -y git
CMD [“echo”,”Image created”]