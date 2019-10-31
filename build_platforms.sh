BRANCHES="carc-wheeler tacc master"
for i in ${BRANCHES}
do
	if [ $i = "master" ];
	then
		TAG=latest
	else
		TAG=$i
	fi
	echo "Building branch ${i} as unmcarc/docker_base:${TAG}"
	git checkout ${i} \
	&& docker build -t unmcarc/docker_base:${TAG} . \
	&& docker push unmcarc/docker_base:${TAG}
done
