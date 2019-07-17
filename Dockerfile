FROM centos
RUN yum -y install wget gsl-devel libgfortran gmp-devel rh-python36 rh-python36-numpy zsh openssl-devel perf autoconf build-essential ca-certificates coreutils curl environment-modules git python unzip vim
RUN yum -y group install "Development Tools"
RUN ln -s /usr/lib64/openmpi/bin/* /usr/bin/
ENTRYPOINT ["/bin/echo", "In Base CARC Image"] 
