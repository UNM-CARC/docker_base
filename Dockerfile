FROM spack/centos:7
# Basic MPI development tools and modules for making it available
RUN yum -y install libgfortran gfortran gsl-devel gmp-devel zsh openssl-devel perf autoconf ca-certificates coreutils curl environment-modules git python unzip vim openssh-server
# Not using openmpi3-develsince we're trying to get that from spack
RUN yum -y groupinstall "Development Tools"
# Install Infiniband goodies needed for CARC systems
RUN yum -y install dapl dapl-utils ibacm infiniband-diags libibverbs libibverbs-devel libibverbs-utils libmlx4 librdmacm librdmacm-utils mstflint opensm-libs perftest qperf rdma

# Install SCL tools for managing python versions and a script to always enable them when we start
#RUN yum -y install centos-release-scl
#RUN yum -y install rh-python36 rh-python36-numpy 
#autotools-latest
#RUN echo "source scl_source enable rh-python36" >> /etc/profile.d/sh.local
#RUN echo "source scl_source enable autotools-latest" >> /etc/profile.d/sh.local
#COPY enablescl.sh /etc/profile.d/enablescl.sh

#ENV PATH="/usr/lib64/openmpi3/bin:${PATH}"

#RUN sed -i \
#      's/$spack\(.*\)/"${GITHUB_WORKSPACE}\/spack\1"/' \
#      /spack/etc/spack/defaults/config.yaml && \
#    sed -i \
#      's/misc_cache: .*/misc_cache: "${GITHUB_WORKSPACE}\/spack\/misc_cache"/' \
#      /spack/etc/spack/defaults/config.yaml

ENV SPACK_ROOT=/spack
ENV PATH=$PATH:/spack/bin

WORKDIR /build
COPY spack.yaml .
RUN spack install && spack clean -a
RUN spack compiler find --scope defaults
# Make sure we're started
# ENTRYPOINT ["module", "add", "mpi/openmpi3-x86_64"]
#ENTRYPOINT ["/bin/bash", "Base Image"]
ADD entrypoint.sh /
ENTRYPOINT ["/entrypoint.sh"]
