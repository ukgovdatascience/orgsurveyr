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
