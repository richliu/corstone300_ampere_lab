
export DOCKER_IMAGE = richliu/armmlek22p4
export DOCKER_IMAGE_TAR = armmlek22p4.tar

help:
	@echo "+-----------------------------------------------------"
	@echo "| Build Docker Images"
	@echo "+-----------------------------------------------------"
	@echo "\$$ make build"
	@echo "\$$ make run"
	@echo "\$$ make clean"
	@echo "\$$ make distclean"
	@echo "\$$ make save | load"
	@echo "\$$ make push | pull"
	@echo ""

# +------------------------------------------------------------------
# | Build Docker image
# +------------------------------------------------------------------

build:
	docker build -t $(DOCKER_IMAGE) . 2>&1 | tee build.log
	docker images

run:
	docker run --rm -it \
				-v /tmp/.X11-unix:/tmp/.X11-unix \
				--volume="/home/$(USER)/.Xauthority:/root/.Xauthority:rw" \
				--privileged \
				--workdir /home/ubuntu \
				-e DISPLAY=:0 \
				-p 2222:22 \
				$(DOCKER_IMAGE) bash

clean:
	docker image ls
	docker rmi $(DOCKER_IMAGE)
	docker image ls

distclean:
	docker image ls
	docker builder prune --all --force
	docker image ls

# +------------------------------------------------------------------
# | Pull & Push Docker images
# +------------------------------------------------------------------

pull:
	docker pull $(DOCKER_IMAGE)

tag:
	docker tag $(DOCKER_IMAGE):latest localhost:5000/$(DOCKER_IMAGE):latest

# First time run make tag before run make push
# push to local docker regestry, dockerhub is not good for traing lab right now
push:
	docker push localhost:5000/$(DOCKER_IMAGE):latest

# +------------------------------------------------------------------
# | Save & Load Docker images
# +------------------------------------------------------------------

save:
	docker save -o $(DOCKER_IMAGE_TAR) $(DOCKER_IMAGE):latest

save-zip:
	docker save $(DOCKER_IMAGE):latest | gzip $(IMAGE_TAR_FILE).tgz

load:
	docker load --input $(DOCKER_IMAGE_TAR)


# +------------------------------------------------------------------
# | Downloads a test image hello-world and runs it in a container
# | Please run docker login at first time
# +------------------------------------------------------------------

hello:
	docker run hello-world

ubuntu:
	docker login
	docker pull ubuntu:20.04
	docker run -it ubuntu:20.04
