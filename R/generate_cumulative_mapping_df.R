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
#' NULL
generate_cumulative_mapping <- function(tg, df) {

  check_tbl_graph_is_org(tg)

  #check df is a data frame with unit_id and individual_id columns
  stopifnot(inherits(df, 'data.frame'))
  if (!('unit_id' %in% colnames(df) & 'individual_id' %in% colnames(df))) {
    stop('df should have a unit_id and individual_id column')
  }

  #expand org network into a dataframe of org units with all descendent org units
  tg_expanded_df <- tg %>%
    tidygraph::activate(nodes) %>%
    tidygraph::mutate(child_id = tidygraph::map_bfs_back(dplyr::row_number(), .f = function(node, path, ...) {
      .N()[c(node, path$node),]$unit_id
    })) %>%
    tidygraph::as_tibble() %>%
    dplyr::select(unit_id, child_id) %>%
    tidyr::unnest()

  #map individuals to child org units to generate dataframe with org unit + all descendent individuals
  tg_expanded_df %>%
    dplyr::inner_join(df, by=c('child_id' = 'unit_id')) %>%
    dplyr::transmute(unit_id,individual_id)

}
