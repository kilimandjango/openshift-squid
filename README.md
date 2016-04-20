


**Squid Proxy S2I Docker Image for OpenShift Enterprise v3**
========================================================
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
	 - https://storage.googleapis.com/golang/go1.6.1.linux-amd64.tar.gz
	 - Untar Go package:
 `$ tar -C /usr/local -xzf go$VERSION.$OS-$ARCH.tar.gz`
	 - Add Go path to /etc/bashrc: 
`export PATH=$PATH:/usr/local/go/bin`
	 - Add Go workspace (can be custom) to /etc/bashrc: 
`export GOPATH=$HOME/work`

 - Install S2I:
 `$ go get github.com/openshift/source-to-image`
`$ cd ${GOPATH}/src/github.com/openshift/source-to-image`
  `$ export PATH=$PATH:${GOPATH}/src/github.com/openshift/source-to-image/_output/local/bin/linux/amd64/`
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
 - Test the Docker builder image:
`$ docker run <BUILDER_IMAGE_NAME>`
 - Now build the Docker application image (builder image must be present!), the sourcecode can be in local directory or git repo:
`$ s2i build <sourcecode> <builder_image_name> <output_application_name>` 
 - Test the application image:
`$ docker run <OUTPUT_APPLICATION_IMAGE_NAME>`

Steps on OpenShift
------------------
 - Set up a Git repository with source code and config files in folder /src
 - Optional: Push the local Docker image to the private Docker registry. This way the imagestream is automatically created. The imagestream can then be used in the app creation.
 - Create a new project:
 `$ oc new-project <project_name>`
 - Create a new application:
 `$ oc new-app <repo_name>/<image_name>~https://github.com/openshift/<repo_name>.git`
 - Check with following command if the application is running:
 `$ oc ge pod`

 

