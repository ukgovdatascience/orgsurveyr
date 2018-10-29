#' @title Determine format of data frame
#'
#' @description
#' Helper function to determine whether a supplied data frame is of any of the
#' \code{\link{orgsurveyr-data-formats}} defined in the package.
#'
#' @param df query data frame
#' @return string of data frame type
#' @export get_df_format
#'
#' @examples
#' data(tg_org_indiv_df)
#' get_df_format(tg_org_indiv_df)
#'
#' data(tg_org_indiv_minimal_df)
#' get_df_format(tg_org_indiv_minimal_df)
#'
#' data(tg_org_indiv_tall_df)
#' get_df_format(tg_org_indiv_tall_df)
#'
#' data(tg_org_summarised_df)
#' get_df_format(tg_org_summarised_df)
#'
#' data(mtcars)
#' get_df_format(mtcars)
get_df_format <- function(df) {

  compare_df <- function(query_df, template_df, format_id, subset_ok = FALSE) {
    utils::data(list=template_df, envir = environment())
    template_df_format <- purrr::map_chr(get(template_df), class)
    query_df_format <- purrr::map_chr(query_df, class)

    # if we are happy for the template df to represent a subset of the columns in the query df
    if(subset_ok & isTRUE(all(names(template_df_format) %in% names(query_df_format)))) {
      query_df_format <- query_df_format[names(query_df_format) %in% names(template_df_format)]
    }

    if(identical(template_df_format, query_df_format)) {
      return(format_id)
    } else if (identical(names(template_df_format), names(query_df_format)) &
               !identical(unname(template_df_format), unname(query_df_format))) {
      warning(sprintf('%s format but column types incorrect, try data("%s") for an example', format_id, template_df))
      return(format_id)
    } else {
      return(NULL)
    }

  }

  res <- c(compare_df(df, 'tg_org_indiv_minimal_df', 'indiv_df', TRUE),
           compare_df(df, 'tg_org_indiv_tall_df', 'indiv_tall_df', FALSE),
           compare_df(df, 'tg_org_summarised_df', 'org_tall_df', FALSE))

  if(is.null(res)) {
    return('unknown')
  } else {
    return(res)
  }

}
