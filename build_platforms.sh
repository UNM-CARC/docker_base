PLATFORMS="carc-wheeler tacc latest"
for i in ${PLATFORMS}
do
	git checkout $PLATFORMS \
	&& docker build -t unmcarc/docker_base:${i} . \
	&& docker push unmcarc/docker_base:${i}
done
