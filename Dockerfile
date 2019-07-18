FROM centos
RUN yum -y install wget gsl-devel openmpi-devel libgfortran gmp-devel rh-python36 rh-python36-numpy zsh openssl-devel perf autoconf build-essential ca-certificates coreutils curl environment-modules git python unzip vim centos-release-scl
RUN yum -y group install "Development Tools"
RUN yum -y install dapl dapl-utils ibacm infiniband-diags libibverbs libibverbs-devel libibverbs-utils libmlx4 librdmacm librdmacm-utils mstflint opensm-libs perftest qperf rdma
RUN ln -s /usr/lib64/openmpi/bin/* /usr/bin/
ENTRYPOINT ["/bin/echo", "In Base CARC Image"]
