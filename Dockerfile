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

# Setup the CARC spack configuration used by containers. This should include 
# core compilers, job launch, and network fabric parts for CARC systems.
# For now, the spack.yaml just uses gcc-4.8.5 from core CentOS and Openmpi
# and turns on hierarchical modules
RUN mkdir -p /build/base
WORKDIR /build/base
COPY modules.yaml /opt/spack/etc/spack/modules.yaml
COPY spack.yaml .
RUN spack install && spack clean -a

# Set up the base entrypoint that gets the default environmnet working by
# running as a login shell and then execing whatever comes next. In general,
# containers built on this should just set CMD to a shell script they define
# which runs module commands and then an application.
RUN chmod 777 /root
WORKDIR /root
COPY entrypoint.sh .
RUN ["chmod", "+x", "/root/entrypoint.sh"]
ENTRYPOINT ["/bin/bash", "-l", "/root/entrypoint.sh"]
CMD ["/bin/bash"]
