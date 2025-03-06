
export DOCKER_IMAGE = richliu/armmlek22p4
export DOCKER_IMAGE_TAR = armmlek22p4.tar

help:
	@echo "make [OPTION]"
	@echo ""
	@echo "[OPTIONS]"
	@echo "    build: build the docker image"
	@echo "    daemon: run the docker image as daemon"
	@echo "    run: run the docker image(for test)"
	@echo "    clean: clean the docker image"
	@echo "    distclean: clean all cache when build cache and docker image"
	@echo "    save: save dokcer image as a physical image file"
	@echo "    save-zip: save dokcer image as a physical image file and zip it"
	@echo "    load: load docker image from a physicla image file"
	@echo "    tag: tag current docker image with :latest tag"
	@echo "    push: push the current docker image to docker registry"
	@echo "    pull: pull the docker image from docker registry"

# +------------------------------------------------------------------
# | Build Docker image
# +------------------------------------------------------------------

build:
	docker build -t $(DOCKER_IMAGE) . 2>&1 | tee build.log
	docker images

# run the docker image on background
daemon:
	docker run --rm -d --privileged -p 5901:5901 -p 2222:22 $(DOCKER_IMAGE)

# run the docker image in current bash
run:
	docker run --rm -it \
		-v /tmp/.X11-unix:/tmp/.X11-unix \
		-v /home/ubuntu/corstone300_ampere_lab:/home/ubuntu/corstone300_ampere_lab \
		--volume="/home/$(USER)/.Xauthority:/root/.Xauthority:rw" \
		--privileged \
		--workdir /home/ubuntu \
		-e DISPLAY=:0 \
		-p 2222:22 \
		-p 5901:5901 \
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
