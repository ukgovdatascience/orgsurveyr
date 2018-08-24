#' Generate Cumulative Mapping
#'
#' Takes an organisation as a tbl_graph object and a data frame that maps individuals to units
#' and returns a data frame that maps an organisational unit to all individuals within that unit.
#'
#' For example, if an organisation is split into four departments, and each department has four teams,
#' an employee is affiliated not just to their immediate team, but also their department and the organisation
#' as a whole.
#'
#' The output dataframe serves as a basis for calculating unit level summaries that include all individuals
#' affiliated to that unit.
#'
#' @param tg tbl_graph that passes a check with check_tbl_graph_is_org
#' @param df a data frame with columns named unit_id and invididual_id
#'
#' @return tbl_df
#' @export
#'
#' @examples
#'
#' library(dplyr)
#' set.seed(1234)
#' tg_ex1 <- create_realistic_org(n_children = 4, max_depth = 3, prob=0.3)
#' tg_ex1 <- simulate_unit_size(tg_ex1)
#' df <- simulate_individuals_df(tg_ex1)
#'
#' map_df <- generate_cumulative_mapping(tg_ex1, df)
#' map_df
#'
#' #use the map to calculate cumulative means
#' df %>%
#' inner_join(map_df, by='individual_id') %>%
#'  group_by(parent_id) %>%
#'  summarise(cum_test_var = mean(test_var),
#'            cum_n = n())

generate_cumulative_mapping <- function(tg, df) {

  check_tbl_graph_is_org(tg)

  #check df is a data frame with unit_id and individual_id columns
  stopifnot(inherits(df, 'data.frame'))
  check_df_format(df, 'indiv_df', dev_mode = TRUE)

  #expand org network into a dataframe of org units with all descendent org units
  tg_expanded_df <- tg %>%
    tidygraph::activate(nodes) %>%
    tidygraph::mutate(child_id = tidygraph::map_bfs_back(dplyr::row_number(), .f = function(node, path, ...) {
      tidygraph::.N()[c(node, path$node),]$unit_id
    })) %>%
    tidygraph::as_tibble() %>%
    dplyr::select(unit_id, child_id) %>%
    tidyr::unnest()

  #map individuals to child org units to generate dataframe with org unit + all descendent individuals
  tg_expanded_df %>%
    dplyr::inner_join(df, by=c('child_id' = 'unit_id')) %>%
    dplyr::transmute(parent_id=unit_id, individual_id)

}
