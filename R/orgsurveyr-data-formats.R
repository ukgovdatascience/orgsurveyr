
#' @title Data formats used in the orgsurveyr package
#'
#' @description
#' The orgsurveyr package works with the following data frame formats:
#' \describe{
#'  \item{indiv_df}{Data frame with one row per individual in the organisation and variables as multiple columns (wide)}
#'  \item{indiv_tall_df}{Data frame with multiple rows per individual in the organisation but a fixed number of columns (tall)}
#'  \item{org_tall_df}{Data frame with multiple rows per unit in the organisation and a fixed number of columns (tall)}
#'  }
#' The \code{\link{get_df_format}} and \code{\link{check_df_format}} functions can be used to determine and check the data frame format.
#'
#' @examples
#'
#' # examine the tbl_graph object the data relates to
#' data(tg_org)
#' tidygraph::as_tbl_graph(tg_org)
#'
#' # indiv_df example
#' data(tg_org_indiv_df)
#' dplyr::tbl_df(tg_org_indiv_df)
#'
#' # indiv_tall_df example
#' data(tg_org_indiv_tall_df)
#' dplyr::tbl_df(tg_org_indiv_tall_df)
#'
#' # org_tall_df example
#' data(tg_org_summarised_df)
#' dplyr::tbl_df(tg_org_summarised_df)
#'
#' @name orgsurveyr-data-formats
#' @aliases data-formats
NULL
