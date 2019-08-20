FROM spack/centos7
# Basic MPI development tools and modules for making it available
RUN yum -y install libgfortran gfortran gsl-devel gmp-devel zsh openssl-devel perf autoconf ca-certificates coreutils curl environment-modules git python unzip vim openssh-server
# Not using openmpi3-develsince we're trying to get that from spack
RUN yum -y groupinstall "Development Tools"
# Install Infiniband goodies needed for CARC systems
RUN yum -y install dapl dapl-utils ibacm infiniband-diags libibverbs libibverbs-devel libibverbs-utils libmlx4 librdmacm librdmacm-utils mstflint opensm-libs perftest qperf rdma

COPY spack.yaml .
RUN spack install && spack clean -a

# Make sure we're started
# Getting rid of the entrypoint and using the default one from spack. Need to look what that entrypoint does...
