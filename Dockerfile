FROM centos:latest
MAINTAINER kilimandjango

RUN yum -y install squid && systemctl enable squid && yum clean -y all

COPY squid.conf /etc/squid/squid.conf

EXPOSE 3128

