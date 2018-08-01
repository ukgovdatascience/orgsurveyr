#' Create a realistic organisation
#'
#' Create an organisation where each unit starts with a specified number of child units up until
#' a maximum depth, but where units are then randomly removed according to probabilities set in either
#' a single value for all units, a value per unit depth or a user defined function of depth.
#'
#' @param n_children integer
#' @param max_depth integer
#' @param prob double or vector of doubles
#' @param .f function of x
#' @param keep_creation_vars logical
#'
#' @return tidygraph object
#' @export
#' @importFrom magrittr %>%
#'
#' @examples
#' tg1 <- create_realistic_org(4,3, prob=0.3)
#' tg1
#'
#' tg2 <- create_realistic_org(4,3, prob=c(0.2, 0.4, 0.6))
#' tg2
create_realistic_org <- function(n_children = 4, max_depth = 3, prob=0.3, .f=NULL, keep_creation_vars=FALSE) {

  stopifnot(length(prob) %in% c(1, max_depth))
  if(!is.null(.f)) stop('Use of function to define deletion probability not implemented yet')
  stopifnot(is.logical(keep_creation_vars))

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
                      })) #%>%
  #tidygraph::filter(to_delete == 0)

  if (!keep_creation_vars) {
    out <- out %>% tidygraph::select(unit_id, depth)
  }

  return(out)

}
