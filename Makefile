help:
	@echo Makefile commands:
	@echo
	@echo help: print this help message and exit
	@echo build: build the docker image for dtfviz
	@echo run:
	@echo     - start a docker container with the orgsurveyr package installed
	@echo     - to connect go to localhost:8789
	@echo     - your home directory on your host machine will be available at /home/rstudio/hostdata
	@echo
	@echo stop: stops the orgsurveyr docker container
	@echo remove: removes the orgsurveyr docker container


build:
	docker build --file=docker/Dockerfile --tag=orgsurveyr .

run: build
	docker run -d -p 8789:8787 \
		-e DISABLE_AUTH=true \
		--name='orgsurveyr-rstudio' \
		-v ${HOME}:/home/rstudio/hostdata \
		orgsurveyr
	open http://localhost:8789/

stop:
	docker stop orgsurveyr-rstudio

start:
	docker start orgsurveyr-rstudio

remove: stop
	docker rm orgsurveyr-rstudio


