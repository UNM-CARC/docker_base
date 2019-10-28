# This Dockerfile creates the base image for running containerized applications 
# at UNM CARC. It is constructed using spack, and we are increasingly moving
# elements of it from the CentOS install into spack. The overall approach of 
# this container is to construct a spack environment for the machine on which
# we'll run, and then activate of view of that environment in /usr/local (which
# is otherwise empty on CentOS) to make the contents of it available to programs
# being compiled or run on the container
#
# Containers layers on top of this one are constructed pretty simply:
# 1. activate the spack environment being customized (e.g. wheeler)
# 2. spack add any additional packages desired in the environment
# 3. spack concretize && spack install && spack clean -a that environment
# 4. spack env view regenerate /usr/local to rebuild the view of that
#    environment in /usr/local
#
# The general expectation is that this container and ones layered on top of it
# will be run using Singularity with a cleaned environment and a contained 
# file systems (e.g. singularity run -eC container.sif). The Singularity command
# is responsible for binding in the appropriate environment variables, 
# directories, and files to make this work. I'm currently working on a 
# script to make this easy on CARC systems. README.md has (or will have)
#  more inforamation on what's required of the launcher of these containers 
# in that scenario. 

FROM spack/centos7

# Because we use spack and a cleaned environment, the run commands here
# need to be login shells to get the appropriate spack initialiation.
SHELL ["/bin/bash", "-l", "-c"]

# Basic MPI development tools and modules for making it available
RUN yum -y install libgfortran gfortran gsl-devel gmp-devel zsh openssl-devel perf autoconf ca-certificates coreutils curl environment-modules git python unzip vim openssh-server
# Not using openmpi3-develsince we're trying to get that from spack
RUN yum -y groupinstall "Development Tools"
# Install Infiniband goodies needed for CARC systems
RUN yum -y install dapl dapl-utils ibacm infiniband-diags libibverbs libibverbs-devel libibverbs-utils libmlx4 librdmacm librdmacm-utils mstflint opensm-libs perftest qperf rdma

# Set up our general spack build setup for this system in /etc/spack/
RUN mkdir -p /etc/spack && chmod 777 /etc/spack
RUN mkdir -p  /home/docker && chmod 777 /home/docker
COPY packages.yaml /etc/spack/

# And then create an environment in which we will run, and will use spack environments
# to make packages visibile to user programs. The specific packages we will use are
# listed in spack.yaml. Further layers will just go to just go
# to /build and "spack add" additional things they want build, then 
# rerun spack install in that environment, and regenerate the 
# view of that environmet in /usr/local
RUN spack compiler find \
    && mkdir /build
COPY spack-wheeler.yaml /build/
RUN spack env create wheeler && spack cd -e wheeler \
    && cp /build/spack-wheeler.yaml ./spack.yaml
RUN spack env activate wheeler \
    && spack concretize \
    && spack install \
    && echo "wheeler" >> /home/docker/environments.txt

RUN spack clean -a

# Now make a view of the default environment for this center available in /usr/local
RUN spack env activate wheeler \
    && spack env view enable /usr/local

# Set up the base entrypoint that gets the default environmnet working by
# running as a login shell and then execing whatever comes next. In general,
# containers built on this should just set CMD to a shell script they define
# which runs the an application.
WORKDIR /home/docker
COPY entrypoint.sh commands.sh ./
RUN chmod +x /home/docker/entrypoint.sh /home/docker/commands.sh

ENTRYPOINT ["/bin/bash", "-l", "/home/docker/entrypoint.sh"]
CMD ["docker-shell"]
