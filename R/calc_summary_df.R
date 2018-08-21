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
