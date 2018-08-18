#' Create a symmetrical organisation
#'
#' Create an organisation where each unit has a specified number of child units up until
#' a maximum depth.
#'
#' @param n_children integer defining the number of children each node should have
#' @param max_depth the maximum depth of the organisation
#'
#' @return tidygraph object
#' @export
#'
#' @examples
#' set.seed(1234)
#' tg1a <- create_regular_org(n_children=4, max_depth=3)
#' tg1a
#'
#' \dontrun{
#' plot_org(tg1a, fill_var=NULL)
#' }
create_regular_org <- function(n_children=4, max_depth=3) {

  stopifnot(is.numeric(n_children), is.numeric(max_depth))
  stopifnot(n_children %% 1 == 0, max_depth %% 1 == 0)
  stopifnot(n_children > 0, max_depth > 0)

  regular_n <- sum(n_children^c(0:max_depth))
  tidygraph::create_tree(n = regular_n, children = n_children)

}
