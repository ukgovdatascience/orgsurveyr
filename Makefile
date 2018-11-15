help:
	@echo Makefile commands:
	@echo
	@echo help: print this help message and exit
	@echo build: build the docker image for orgsurveyr
	@echo run:
	@echo     - starts a docker container with the orgsurveyr package installed
	@echo     - to use RStudio go to localhost:8789
	@echo     - to use Shiny go to localhost:3839
	@echo     - your home directory on your host machine will be available at /home/rstudio/hostdata
	@echo     - add new Shiny apps to /home/rstudio/ShinyApps
	@echo
	@echo stop: stops the orgsurveyr docker container
	@echo remove: removes the orgsurveyr docker container


build:
	docker build --file=docker/Dockerfile --tag=orgsurveyr .

run: build
	docker run -d -p 8789:8787 -p 3839:3838 \
		-e DISABLE_AUTH=true \
		--name='orgsurveyr-rstudio' \
		-v ${HOME}:/home/rstudio/hostdata \
		orgsurveyr
	sleep 3;
	open http://localhost:8789/
	open http://localhost:3839/users/rstudio/orgsurveyr/

stop:
	docker stop orgsurveyr-rstudio

start:
	docker start orgsurveyr-rstudio

remove: stop
	docker rm orgsurveyr-rstudio


