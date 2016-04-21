


**Squid Proxy S2I Docker Image for OpenShift Enterprise v3**
========================================================
 The procedure described in the following steps shows the approach to create a S2I capable Docker image with sourcecode injected from a Git repository. The resulting Docker image can be run on any Docker Daemon or it can be pushed to a private Docker registry and then be referenced by an OpenShift application as an imagestream.
 
 The underlying example is a Squid proxy which can control traffic from other Docker containers to the outside.
 
 You can directly use the Git repository, create a Docker builder image and push it to the private Docker registry to create the imagestream. Afterwards you can create a new app in OpenShift and reference the imagestream and the Git repository. The procedure is described in **"How to use the Git repository"**. 
 If you want to create your own application image continue at **"S2I installation routine"**.

What is inside the git repository
---------------------------------
 - .s2i scripts: 
	- assemble
	- run
	- save-artifacts
	- usage
 - Sourcecode in /src folder
 - Dockerfile
 - Makefile

How to use the Git repository
-----------------------------
 1. Clone the git repository:
 `$ git clone https://github.com/<repo_name>`
 2. Build the Docker builder image:
 `$ docker build -t <docker_image>`
 3. Push the Docker builder image to the private Docker registry to create a new imagestream.
 4. Create a new application in Openshift and reference the imagestream (created in step 3) and the git repository:
`$ oc new-app <repo_name>/<image_name>~https://github.com/openshift/<repo_name>.git`
  

S2I installation routine
------------------------
 - Install Docker version 1.8.2 (this version is currently used in OpenShift)
 - Install Go version 1.6.1
	 - Download recent package:
https://storage.googleapis.com/golang/go1.6.1.linux-amd64.tar.gz
	 - Untar Go package:
`$ tar -C /usr/local -xzf go$VERSION.$OS-$ARCH.tar.gz`
	 - Add Go path to /etc/bashrc: 
`export PATH=$PATH:/usr/local/go/bin`
	 - Add Go workspace (can be custom) to /etc/bashrc: 
`export GOPATH=$HOME/work`

 - Install S2I:
	 - Get source-to-image:

`$ go get github.com/openshift/source-to-image`
	 - Change to directory (GOPATH must be set before):

`$ cd ${GOPATH}/src/github.com/openshift/source-to-image`
	 - Export s2i bin to PATH:

`$ export PATH=$PATH:${GOPATH}/src/github.com/openshift/source-to-image/_output/local/bin/linux/amd64/`
	 - This script sets up a go workspace locally and builds all go components:    

`$ hack/build-go.sh`

Customise Docker builder image
---------------------------
 - Create the S2I structure with all mandatory files in a target directory:
 `$ S2I create <builder_image_name> <target_directory>`
 
 - Edit the Dockerfile according to your needs, e.g.:
 `yum install <package> && yum update && yum clean all -y`
 
 - Edit .sti/bin/assemble file, copy config files, etc..
 - Edit .sti/bin/run file, start up the application, e.g.:
 `exec squid -f /etc/squid/squid.conf -N` 

Create Docker builder image
---------------------------
 - Build the Docker builder image:
`$ docker build -t <BUILDER_IMAGE_NAME>`
 - Now build the Docker application image (builder image must be present!), the sourcecode can be in local directory or git repo:
`$ s2i build <sourcecode> <builder_image_name> <output_application_name>` 
 - Test the application image:
`$ docker run -p <port>:<port> <OUTPUT_APPLICATION_IMAGE_NAME>`

Create the application in OpenShift
------------------
 - Set up a Git repository with source code and config files in folder /src
 - Optional: Push the local Docker image to the private Docker registry. This way the imagestream is automatically created. The imagestream can then be used in the app creation.
 - Create a new project:
 `$ oc new-project <project_name>`
 - Create a new application:
 `$ oc new-app <repo_name>/<image_name>~https://github.com/openshift/<repo_name>.git`
 - Check with following command if the application is running:
 `$ oc get pod`

Use the application in OpenShift
------------------
- Log into your project:
 `$ oc project <project_name>`
- Get the service ip address of the pod (needed when the application should be accessed by other pods):
 `$ oc get service`
- Scale up the application to more replicas (traffic will be distributed over the internal loadbalancer, the pod addresses are stored in the service pool):
 `$ oc get dc`
 `$ oc scale up dc <dc_name> --replicas=2`

Configuration of iptables
------------------
- Configure iptables to redirect traffic to the Squid proxy:
`$ iptables -t nat -A PREROUTING -p tcp --dport 80 -j REDIRECT --to 3128 -w`
- Test the Squid proxy:
`$ curl --proxy http://<service_ip_addr>:3128 http://www.google.com`
 

