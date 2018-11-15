FROM rocker/verse:3.5.1

# install linux system dependencies
RUN apt-get update && \
	apt-get install -y libudunits2-dev

# install R dependencies
RUN R -e "install.packages(c('tidygraph', 'ggforce', 'ggraph'), Ncpus=parallel::detectCores())"

COPY . /orgsurveyr

RUN R CMD INSTALL /orgsurveyr && \
	rm -rf /orgsurveyr

