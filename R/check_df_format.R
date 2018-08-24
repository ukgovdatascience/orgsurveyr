#' @title
#' Checks the format of a data frame
#'
#' @description
#' Helper function to determine whether a supplied data frame is a specific \code{\link{orgsurveyr-data-formats}}
#' defined in the package.  Either returns a boolean or throws a stop.
#'
#' @param df query data frame
#' @param format format to test - see \code{\link{orgsurveyr-data-formats}}
#' @param dev_mode stop if test is false.  Default is FALSE
#' @return string of data frame type
#' @export check_df_format
#'
#' @examples
#' data(tg_org_indiv_df)
#' check_df_format(tg_org_indiv_df, 'indiv_df')
#'
#' data(tg_org_indiv_tall_df)
#' check_df_format(tg_org_indiv_tall_df, 'indiv_tall_df')
#'
#' data(tg_org_summarised_df)
#' check_df_format(tg_org_summarised_df, 'org_tall_df')
#'
#' data(mtcars)
#' check_df_format(mtcars, 'indiv_df')
check_df_format <- function(df, format=NULL, dev_mode=FALSE) {

  stopifnot(is.character(format))

  res <- identical(get_df_format(df), format)

  if(dev_mode & !res) {
    stop(sprintf('data.frame should be in %s format, see ?data_formats', format))
  }

  return(res)

}
