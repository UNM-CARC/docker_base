FROM centos:7
# Basic MPI development tools
RUN yum -y install gsl-devel openmpi3-devel libgfortran gmp-devel zsh openssl-devel perf autoconf ca-certificates coreutils curl environment-modules git python unzip vim 
RUN yum -y groupinstall "Development Tools"
# Infiniband goodies
RUN yum -y install dapl dapl-utils ibacm infiniband-diags libibverbs libibverbs-devel libibverbs-utils libmlx4 librdmacm librdmacm-utils mstflint opensm-libs perftest qperf rdma
RUN ln -s /usr/lib64/openmpi/bin/* /usr/bin/
# SCL tools for managing python versions and a script to always enable them when we start
RUN yum -y install centos-release-scl
RUN yum -y install rh-python36 rh-python36-numpy autotools-latest
COPY enablescl.sh /etc/profile.d/enablescl.sh
ENTRYPOINT ["/bin/echo", "In Base CARC Image"]
