FROM centos:7
# Basic MPI development tools
RUN yum -y install gsl-devel openmpi-devel libgfortran gmp-devel zsh openssl-devel perf autoconf build-essential ca-certificates coreutils curl environment-modules git python unzip vim 
RUN yum -y group install "Development Tools"
# Infiniband goodies
RUN yum -y install dapl dapl-utils ibacm infiniband-diags libibverbs libibverbs-devel libibverbs-utils libmlx4 librdmacm librdmacm-utils mstflint opensm-libs perftest qperf rdma
RUN ln -s /usr/lib64/openmpi/bin/* /usr/bin/
# SCL tools for managing python versions and a script to always enable them when we start
RUN yum -y centos-release-scl
RUN yum -y rh-python36 rh-python36-numpy autotools-latest
COPY enablescl.sh /etc/profile.d/enablescl.sh
ENTRYPOINT ["/bin/echo", "In Base CARC Image"]
