#' Create an example shiny app
#'
#' Creates an example shiny application file which can be used as a template to create
#' shiny apps with different configurations for deployment on a shiny server.
#'
#' @param path Location where the file should be created. Defaults to the user's home directory
#'
#' @return creates an example shiny app file
#' @export
#'
#' @examples
#' \dontrun{
#' # create the example shiny app
#' make_shiny_app()
#'
#' # then edit and copy to the correct location
#' mv ~/example_shiny_app.R ~/ShinyApps/my_app/app.R
#' }
make_shiny_app <- function(path='~') {
  example_path <- system.file('shiny/test_viz_app.R', package='orgsurveyr')
  dest <- file.path(path, 'example_shiny_app.R')
  file.copy(example_path, dest)
  message(paste('Example shiny app created at ', dest))
}
