# docker_base
Base Docker Image for CDSE containers running at CARC. In the future, this
should turn into a general docker container for CARC systems, perhaps 
tagged by CARC system, that knows the details of CARC fabrics, job launcher, 
and other system information. This container assumes it runs in a cleaned 
environment with appropriate environment variables and directories bound into
the container.
