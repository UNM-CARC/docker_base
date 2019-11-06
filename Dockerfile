# This Dockerfile creates the base image for running containerized applications 
# at UNM CARC. It is constructed using spack, and we are increasingly moving
# elements of it from the CentOS install into spack. The overall approach of 
# this container is to construct a spack environment for the machine on which
# we'll run, and then activate of view of that environment in /usr/local (which
# is otherwise empty on CentOS) to make the contents of it available to programs
# being compiled or run on the container
#
# Containers layers on top of this one are constructed pretty simply:
# 1. activate the spack environment being customized (e.g. wheeler)
# 2. spack add any additional packages desired in the environment
# 3. spack concretize && spack install && spack clean -a that environment
# 4. spack env view regenerate /usr/local to rebuild the view of that
#    environment in /usr/local
#
# The general expectation is that this container and ones layered on top of it
# will be run using Singularity with a cleaned environment and a contained 
# file systems (e.g. singularity run -eC container.sif). The Singularity command
# is responsible for binding in the appropriate environment variables, 
# directories, and files to make this work. I'm currently working on a 
# script to make this easy on CARC systems. README.md has (or will have)
#  more inforamation on what's required of the launcher of these containers 
# in that scenario. 

FROM spack/centos7 AS builder

# Because we use spack and a cleaned environment, the run commands here
# need to be login shells to get the appropriate spack initialiation.
SHELL ["/bin/bash", "-l", "-c"]

RUN yum -y install centos-release-scl openssl-devel
RUN yum -y install devtoolset-8-gcc devtoolset-8-gcc-c++ devtoolset-8-gcc-gfortran
RUN scl enable devtoolset-8 'spack compiler find --scope system'

# We put our general spack build setup for this system in /etc/spack/ and 
# specific build information into environments, not ~/.spack because /root
# may not be available in singularity containers
RUN mkdir -p /etc/spack 
RUN chmod 755 /etc/spack
COPY packages.yaml /etc/spack/

# We do most of our work in /home/docker for the same reason. This just 
# sets up the base environment in which we can build more sophisticated
# containers
RUN mkdir /home/docker
RUN chmod 777 /home/docker 
COPY spack.yaml /home/docker/spack.yaml
WORKDIR /home/docker
RUN spack install \
    && spack compiler find \
    && spack clean -a 
RUN cd /usr/local/bin && strip -s * || exit 0
RUN cd /usr/local/lib && strip -s * || exit 0

FROM spack/centos7 
SHELL ["/bin/bash", "-l", "-c"]
RUN yum -y install centos-release-scl openssl-devel
RUN yum -y install devtoolset-8-gcc devtoolset-8-gcc-c++ devtoolset-8-gcc-gfortran
COPY --from=builder /opt/software /opt/software
COPY --from=builder /home/docker /home/docker
COPY --from=builder /etc/spack /etc/spack
COPY --from=builder /usr/local /usr/local

WORKDIR /home/docker
COPY entrypoint.sh commands.sh ./
RUN chmod +x /home/docker/entrypoint.sh /home/docker/commands.sh

ENV PATH=/usr/local/bin:${PATH}
ENV LD_LIBRARY_PATH=/usr/local/lib:${LD_LIBRARY_PATH}

ENTRYPOINT ["/bin/bash", "-l", "/home/docker/entrypoint.sh"]
CMD ["docker-shell"]
