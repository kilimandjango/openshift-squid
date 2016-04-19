FROM centos:latest
MAINTAINER kilimandjango

# Set ENV to use in the assemble script

# First update OS
RUN yum -y update

# Now install squid, enable system service and clean up
RUN yum -y install squid && systemctl enable squid && yum clean -y all

# Set labels used in OpenShift to describe the builder images

# Although this is defined in openshift/base-centos7 image it's repeated here
# to make it clear why the following COPY operation is happening
# Copy the S2I scripts from ./.sti/bin/ to /usr/local/sti

# Copy custom squid.conf and blockwebsites.lst to conf directory
COPY ./etc/squid.conf /etc/squid/squid.conf
COPY ./etc/blockwebsites.lst /etc/squid/blockwebsites.lst

# Drop the root user and make user 1001 to owner of /etc/squid
#RUN chown -R 1001:1001 /etc/squid

# Set the default user for the image, the user itself was created in the base image
#USER 1001

# Expose container port
EXPOSE 3128

# Set the default CMD to print the usage of the image if someone does the docker run
#CMD ["usage"]
