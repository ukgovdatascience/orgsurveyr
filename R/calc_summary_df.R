#' Calculate summary metrics on an organisation
#'
#' @description
#' Given individual level variables and an organisation structure, this function calculates aggregated
#' metrics using either the cumulative approach (all individuals in that unit or its descendents) or the orthodox
#' approach (individuals immediately associated with that unit only).
#'
#' @param tg tbl_graph that passes a check with check_tbl_graph_is_org
#' @param df a data frame with columns named unit_id and invididual_id and
#'  (and optionally individual level variables) with one row per individual
#' @param tall_df a data frame with columns named individual id, metric_id and value with multiple rows per individual
#' @param selected_vars names of variables in df or tall_df (character vector)
#' @param is_cumulative whether to calculate cumulative or orthodox aggregations (logical)
#'
#' @return A tall data frame with three columns: unit_id, metric_id and value.
#' @export
#'
#' @examples
#' library(tidygraph)
#' library(dplyr)
#' set.seed(1231)
#' tg1b <- create_realistic_org(4,3, prob=0.3, delete_units = TRUE) %>% simulate_unit_size
#'
#'\dontrun{
#' plot_org(tg1b) + geom_node_text(aes(label=unit_size), color='white')
#'}
#' tg1b_indiv_df <- tg1b %>%
#'   simulate_individuals_df() %>%
#'   mutate(test_var2 = purrr::map_dbl(individual_id, ~rnorm(1, 20,3)))
#' tg1b_indiv_df
#'
#' tg1b_indiv_tall_df <- tg1b_indiv_df %>%
#'   select(individual_id, test_var, test_var2) %>%
#'   tidyr::gather('metric_id', 'value', -individual_id)
#' tg1b_indiv_tall_df
#'
#' # using wide data frame
#' calc_summary_df(tg1b, tg1b_indiv_df, NULL, 'test_var2', is_cumulative=TRUE)
#' calc_summary_df(tg1b, tg1b_indiv_df, NULL, c('test_var', 'test_var2'), is_cumulative=TRUE)
#' calc_summary_df(tg1b, tg1b_indiv_df, NULL, 'test_var2', is_cumulative=FALSE)
#' calc_summary_df(tg1b, tg1b_indiv_df, NULL, c('test_var', 'test_var2'), is_cumulative=FALSE)
#'
#' # using tall data frame
#' calc_summary_df(tg1b, tg1b_indiv_df, tg1b_indiv_tall_df, 'test_var2', is_cumulative=TRUE)
#' calc_summary_df(tg1b, tg1b_indiv_df, tg1b_indiv_tall_df, c('test_var', 'test_var2'), is_cumulative=TRUE)
#' calc_summary_df(tg1b, tg1b_indiv_df, tg1b_indiv_tall_df, 'test_var2', is_cumulative=FALSE)
#' calc_summary_df(tg1b, tg1b_indiv_df, tg1b_indiv_tall_df, c('test_var', 'test_var2'), is_cumulative=FALSE)

calc_summary_df <- function(tg, df, tall_df=NULL, selected_vars, is_cumulative=FALSE) {

  # determine whether data frame is tall or wide
  if (is.null(tall_df)) {
    message('Using wide data frame format for individual variables')
    df_format <- 'wide'
  } else {
    message('Using tall data frame format for individual variables')
    df_format <- 'tall'
  }

  # expand the individuals data frame for cumulative aggregation if necessary
  if(is_cumulative) {
    agg_df <- generate_cumulative_mapping(tg, df) %>%
      dplyr::rename(unit_id = parent_id)
  } else {
    agg_df <- df %>%
      dplyr::select(unit_id, individual_id)
  }

  # summarise the data according to whether the data frame is tall or wide
  if (df_format == 'wide') {
    clean_df <- df %>%
      dplyr::select(individual_id, dplyr::one_of(selected_vars)) %>%
      dplyr::inner_join(agg_df, by='individual_id') %>%
      tidyr::gather('metric_id', 'value', -unit_id, -individual_id)
  } else {
    clean_df <- tall_df %>%
      dplyr::inner_join(agg_df, 'individual_id') %>%
      dplyr::filter(metric_id %in% selected_vars)
  }

  clean_df %>%
    dplyr::group_by(unit_id, metric_id) %>%
    dplyr::summarise_at('value', mean)

}
