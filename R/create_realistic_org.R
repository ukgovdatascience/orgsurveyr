#' Create a realistic organisation
#'
#' Create an organisation where each unit starts with a specified number of child units up until
#' a maximum depth, but where units are then randomly removed according to probabilities set in either
#' a single value for all units, a value per unit depth or a user defined function of depth.
#'
#' @param n_children number of child units per parent unit (integer)
#' @param max_depth integer maximum depth of organisation (integer)
#' @param prob  probability that a unit is deleted to create an irregular organisation.
#' If a vector is provided that is the same length as max_depth then a different probability can be assigned to different
#' levels of the organisation (double or vector of doubles)
#' @param .f function of depth that generates probability that a unit is removed (NOT IMPLEMENTED) (function of x)
#' @param delete_units retains intermediate variables and doesn't delete units - useful to understand how the function
#' is working (logical)
#'
#' @return tidygraph object
#' @export
#' @importFrom magrittr %>%
#'
#' @examples
#' set.seed(1234)
#' tg1a <- create_realistic_org(4,3, prob=0.3)
#' tg1a
#'
#' \dontrun{
#' plot_org(tg1a, fill_var='depth')
#' }
#'
#' set.seed(1234)
#' tg1b <- create_realistic_org(4,3, prob=0.3, delete_units=FALSE)
#' tg1b
#'
#' \dontrun{
#' plot_org(tg1b, fill_var='to_delete')
#' }
#'
#' set.seed(1234)
#' tg2a <- create_realistic_org(4,3, prob=c(0.2, 0.4, 0.6))
#' tg2a
#' \dontrun{
#' plot_org(tg2a, fill_var='depth')
#' }
#'
#' set.seed(1234)
#' tg2b <- create_realistic_org(4,3, prob=c(0.2, 0.4, 0.6), delete_units=FALSE)
#' tg2b
#' \dontrun{
#' plot_org(tg2b, fill_var='to_delete')
#' }
create_realistic_org <- function(n_children = 4, max_depth = 3, prob=0.3, .f=NULL, delete_units=TRUE) {

  stopifnot(length(prob) %in% c(1, max_depth))
  if(!is.null(.f)) stop('Use of function to define deletion probability not implemented yet')
  stopifnot(is.logical(delete_units))

  if (length(prob) == 1 & is.null(.f)) {
    prob_df <- tibble::data_frame(depth=0:max_depth, prob_deletion=prob)
  } else if (length(prob) == max_depth & is.null(.f)) {
    prob_df <- tibble::data_frame(depth=0:max_depth, prob_deletion=c(0,prob))
  } else if (is.function(.f)) {
    prob_df <- tibble::data_frame(depth=0:max_depth) %>%
      mutate(prob_deletion = .f(depth))
  }

  out <- create_regular_org(n_children, max_depth) %>%
    tidygraph::mutate(unit_id = dplyr::row_number(),
                      depth = tidygraph::bfs_dist(1)) %>%
    tidygraph::inner_join(prob_df, by='depth') %>%
    tidygraph::mutate(branch_delete = rbinom(nrow(tidygraph::.N()), 1, prob_deletion),
                      to_delete = tidygraph::map_bfs_dbl(1, .f = function(node, path, ...) {
                        max(tidygraph::.N()[c(node, path$node),]$branch_delete)
                      }))

  if (delete_units) {
    out <- out %>%
      tidygraph::filter(to_delete == 0) %>%
      tidygraph::select(unit_id, depth)
  }

  return(out)

}
