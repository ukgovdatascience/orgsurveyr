FROM rocker/verse:3.5.1

# add shiny server
RUN export ADD=shiny && bash /etc/cont-init.d/add

# install linux system dependencies
RUN apt-get update && \
	apt-get install -y libudunits2-dev

# install R dependencies
RUN R -e "install.packages(c('tidygraph', 'ggforce', 'ggraph'), Ncpus=parallel::detectCores())"

# install orgsurveyr
COPY . /orgsurveyr
RUN R -e "devtools::install('/orgsurveyr', dependencies=FALSE, upgrade_dependencies=FALSE, build_vignettes=TRUE)"  && \
	rm -rf /orgsurveyr

#configure shiny server
COPY ./docker/shiny-server.conf /etc/shiny-server/shiny-server.conf
COPY ./inst/shiny/test_viz_app.R /home/rstudio/ShinyApps/orgsurveyr/test_viz/app.R
COPY ./inst/shiny/orgviz_app.R /home/rstudio/ShinyApps/orgsurveyr/orgviz/app.R
RUN chown -hR rstudio:rstudio /home/rstudio/ShinyApps
