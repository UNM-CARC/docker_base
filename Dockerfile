FROM spack/centos7
# Basic MPI development tools and modules for making it available
RUN yum -y install libgfortran gfortran gsl-devel gmp-devel zsh openssl-devel perf autoconf ca-certificates coreutils curl environment-modules git python unzip vim openssh-server
# Not using openmpi3-develsince we're trying to get that from spack
RUN yum -y groupinstall "Development Tools"
# Install Infiniband goodies needed for CARC systems
RUN yum -y install dapl dapl-utils ibacm infiniband-diags libibverbs libibverbs-devel libibverbs-utils libmlx4 librdmacm librdmacm-utils mstflint opensm-libs perftest qperf rdma

# For each layer, we make a directory with the spack stuff we want in it. This base
# just hase openmpi
RUN mkdir -p /build/base
WORKDIR /build/base
COPY spack.yaml .
RUN spack install && spack clean -a

# These are copied from the base spack Dockerfile to get things set up properly
WORKDIR /root
SHELL ["/bin/bash", "-l", "-c"]

# TODO: add a command to Spack that (re)creates the package cache
# RUN spack spec hdf5+mpi
#
ENTRYPOINT ["/bin/bash", "/opt/spack/share/spack/docker/entrypoint.bash"]
CMD ["docker-shell"]
