FROM centos:latest
MAINTAINER kilimandjango

# First update OS
RUN yum -y update

# Now install squid, enable system service and clean up
RUN yum -y install squid && systemctl enable squid && yum clean -y all

# Copy custom squid.conf to conf directory
COPY squid.conf /etc/squid/squid.conf

# Expose container port
EXPOSE 3128

