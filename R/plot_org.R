#' Simple organisation plot
#'
#' Bare bones function to plot an organisation style dendrogram from a tidygraph object.
#'
#' Note that the recommended way to plot organisations is using the ggraph package.  Some examples of how to do this
#' are included in the vignettes.  This simple function is provided as a convenience for new users and to use in examples.
#'
#' DEV NOTE: in ggplot2 version 3.0.0 tidyeval is available so should be able to use this rather than aes_string
#'
#' @param x organisation as a tidygraph object (tidygraph)
#' @param fill_var the variable to use as a fill colour for units.  Will either be a metric_id in df or
#' a column in the nodes data frame in the tidygraph object  (metric name)
#' @param df a data frame in org_tall_df format ie summarised metrics for the units in the network
#'  as generated by calc_summary_df. See \code{\link{orgsurveyr-data-formats}} for more information.
#'  If NULL the fill_var comes from the nodes data frame in the tidygraph object (data frame)
#' @param is_circular whether to make the network circular which is useful for larger organisations (logical)
#' @param is_dendrogram whether to make the network a dendrogram or an icicle/starburst plot (logical)
#' @param return_tbl_graph whether to return the constructed tbl_graph object rather than
#'  the plot.  This can be useful if a different plot needs to be constructed
#'  to that provided. Default FALSE (logical)
#'
#' @return ggraph object
#' @import ggraph ggplot2
#' @export
#'
#' @examples
#' library(tidygraph)
#' library(dplyr)
#' library(ggraph)
#'
#' set.seed(1236)
#' tg2 <- create_realistic_org(4,3, prob=0.3, delete_units = TRUE) %>%
#'    simulate_unit_size
#' tg2
#'
#' # plot the organisation using the depth of the unit in the organisation as fill colour
#' \dontrun{
#' plot_org(tg2, fill_var='org_depth') #normal dendrogram
#' plot_org(tg2, fill_var='org_depth', is_circular=TRUE) #circular dendrogram
#'
#' # build on ggraph object using ggraph functionality - ie add unit sizes
#' plot_org(tg2, fill_var='org_depth') + geom_node_text(aes(label=unit_size), color='white')
#' }
#'
#' # can also include aggregated unit information from calc_summary_df
#'
#' # simulate individual data and summarise
#' tg2_indiv_df <- tg2 %>%
#'    simulate_individuals_df() %>%
#'    mutate(test_var2 = purrr::map_dbl(individual_id, ~rnorm(1, 20,3)))
#'
#' summary_df <- calc_summary_df(tg2, tg2_indiv_df, NULL, c('test_var', 'test_var2'), TRUE)
#'
#' # plot the organisation using the cumulative mean of the individual variables
#' \dontrun{
#' plot_org(x=tg2, fill_var = 'test_var', df=summary_df)
#' plot_org(x=tg2, fill_var = 'test_var2', df=summary_df)
#' }

plot_org <- function(x, fill_var = 'org_depth', df=NULL, is_circular = FALSE,
                     is_dendrogram = TRUE, return_tbl_graph = FALSE) {

  check_tbl_graph_is_org(x)
  stopifnot(is.character(fill_var))
  stopifnot(is.logical(is_circular))

  if(!is.null(df)) {

    stopifnot(inherits(df, 'data.frame'))
    check_df_format(df, 'org_tall_df', dev_mode = TRUE)

    df_filtered <- df %>%
      dplyr::filter(metric_id == fill_var) %>%
      tidyr::spread(metric_id, value)

    stopifnot(nrow(df_filtered) > 0)

    tg <- x %>%
      tidygraph::left_join(df_filtered, by='unit_id')

  } else {
    tg <- x
  }

  stopifnot(fill_var %in% (tg %>% tidygraph::activate(nodes) %>%
                             tidygraph::as_tibble() %>% colnames()))

  if(return_tbl_graph) {
    return(tg)
  }

  if(is_dendrogram) {
    #normal dendrogram
    ggraph(tg, 'dendrogram', circular = is_circular) +
      geom_edge_diagonal() +
      geom_node_point(aes_string(fill = fill_var),
                      shape = 21, size = 5) +
      theme_graph()
  } else if (!is_dendrogram & is_circular) {
    #starburst
    ggraph(tg, 'partition', circular = is_circular) +
      geom_node_arc_bar(aes_string(fill = fill_var),
                      size = 0.01) +
      theme_graph()
  } else {
    #icicle
    ggraph(tg, 'partition', circular = is_circular) +
      geom_node_tile(aes_string(fill = fill_var),
                        size = 0.01) +
      theme_graph()
  }

}
