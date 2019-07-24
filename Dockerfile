FROM centos:7
# Basic MPI development tools and modules for making it available
RUN yum -y install gsl-devel openmpi3-devel libgfortran gmp-devel zsh openssl-devel perf autoconf ca-certificates coreutils curl environment-modules git python unzip vim 
RUN yum -y groupinstall "Development Tools"
# Install Infiniband goodies needed for CARC systems
RUN yum -y install dapl dapl-utils ibacm infiniband-diags libibverbs libibverbs-devel libibverbs-utils libmlx4 librdmacm librdmacm-utils mstflint opensm-libs perftest qperf rdma

# Install SCL tools for managing python versions and a script to always enable them when we start
RUN yum -y install centos-release-scl
RUN yum -y install rh-python36 rh-python36-numpy 
#autotools-latest
RUN echo "source scl_source enable rh-python36" >> /etc/profile.d/sh.local
#RUN echo "source scl_source enable autotools-latest" >> /etc/profile.d/sh.local
#COPY enablescl.sh /etc/profile.d/enablescl.sh

ENV PATH="/usr/lib64/openmpi3/bin:${PATH}"
# Make sure we're started
ENTRYPOINT ["module", "add", "mpi/openmpi3-x86_64"]
