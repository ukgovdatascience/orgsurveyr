% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/shiny_orgviz.R
\name{orgviz_ui}
\alias{orgviz_ui}
\title{Orgviz shiny UI}
\usage{
orgviz_ui()
}
\value{
shiny ui object
}
\description{
Creates a shiny UI object for the orgviz shiny app
}
\examples{
\dontrun{
library(shiny)

shinyApp(ui = orgviz_ui(),
         server = function(input, output) {
           orgviz_server(input, output, tg = NULL, df = NULL)
         }
)
}
}
