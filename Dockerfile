# This Dockerfile creates the base image for running containerized applications 
# at UNM CARC. It is constructed using spack, and we are increasingly moving
# elements of it from CE

FROM spack/centos7

# Because we use packages and a cleaned environment, the run commands here
# need to be login shells to get the appropriate paths.
SHELL ["/bin/bash", "-l", "-c"]

# Basic MPI development tools and modules for making it available
RUN yum -y install libgfortran gfortran gsl-devel gmp-devel zsh openssl-devel perf autoconf ca-certificates coreutils curl environment-modules git python unzip vim openssh-server
# Not using openmpi3-develsince we're trying to get that from spack
RUN yum -y groupinstall "Development Tools"
# Install Infiniband goodies needed for CARC systems
RUN yum -y install dapl dapl-utils ibacm infiniband-diags libibverbs libibverbs-devel libibverbs-utils libmlx4 librdmacm librdmacm-utils mstflint opensm-libs perftest qperf rdma

# TODO - we should move some of these to spack, and those that aren't from spack should be whitelisted in the
# packages.yaml

# Set up our general spack build setup for this system in /etc/spack/
RUN mkdir -p /etc/spack
RUN chmod 755 /etc/spack
COPY packages.yaml /etc/spack/

# And then create an environment in which we will run, and will use spack environments
# to make packages visibile to user programs. The specific packages we will use are
# listed in spack.yaml. Further layers will just go to just go
# to /build and "spack add" additional things they want build and then 
# rerun spack install in that environment. In addition, we can use different environments
# for different CARC systems in the same container if we want.
RUN spack compiler find \
    && mkdir /build
COPY spack-wheeler.yaml /build/
RUN spack env create wheeler && spack cd -e wheeler \
    && cp /build/spack-wheeler.yaml ./spack.yaml
RUN spack env activate wheeler \
    && spack concretize \
    && spack install \
    && spack clean -a

# Set up the base entrypoint that gets the default environmnet working by
# running as a login shell and then execing whatever comes next. In general,
# containers built on this should just set CMD to a shell script they define
# which runs the an application, because their environment will be setup by
# the spack env actviate command they're using.
RUN mkdir /home/docker && chmod 777 /home/docker
WORKDIR /home/docker
COPY entrypoint.sh .
RUN ["chmod", "+x", "/home/docker/entrypoint.sh"]
ENTRYPOINT ["/bin/bash", "-l", "/home/docker/entrypoint.sh"]
CMD ["/bin/bash"]
