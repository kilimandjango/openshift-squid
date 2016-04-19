FROM centos:latest
MAINTAINER kilimandjango

# First update OS
RUN yum -y update

# Now install squid, enable system service and clean up
RUN yum -y install squid && systemctl enable squid && yum clean -y all

# Set labels used in OpenShift to describe the builder images
LABEL io.k8s.description="Platform for serving fancy proxy services" \
      io.k8s.display-name="Squid Proxy" \
      io.openshift.expose-services="3128" \
      io.openshift.tags="builder,squid"

# Although this is defined in openshift/base-centos7 image it's repeated here
# to make it clear why the following COPY operation is happening
LABEL io.openshift.s2i.scripts-url=image:///usr/local/sti
# Copy the S2I scripts from ./.sti/bin/ to /usr/local/sti
COPY ./.sti/bin/ /usr/local/sti

# Copy custom squid.conf to conf directory
COPY ./etc/squid.conf /etc/squid/squid.conf

# Drop the root user and make user 1001 to owner of /etc/squid
RUN chown -R 1001:1001 /etc/squid

# Set the default user for the image, the user itself was created in the base image
USER 1001

# Expose container port
EXPOSE 3128

# Set the default CMD to print the usage of the image if someone does the docker run
CMD ["usage"]
