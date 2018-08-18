#' Check tbl_graph is an organisation
#'
#' Verify that a tbl_graph has the right features to be an organisation
#'
#' @param x an object to check
#'
#' @export
#'
#' @examples
#'
#' library(tidygraph)
#'
#' set.seed(1234)
#' tg1 <- create_realistic_org()
#' check_tbl_graph_is_org(tg1)
#' # returns no errors
#'
#' tg2 <- tidygraph::create_star(30)
#' \dontrun{
#' check_tbl_graph_is_org(tg2)
#' # returns an error
#' }
#'
#' tg3 <- filter(tg1, unit_id != 1)
#' check_tbl_graph_is_org(tg3)
#' # returns a warning that the tree is no longer rooted
#'
check_tbl_graph_is_org <- function(x) {

  if(!tidygraph::is.tbl_graph(x)) {
    stop('x is not a tbl_graph object')
  }

  if(tidygraph::with_graph(x, tidygraph::graph_is_forest())) {
    warning('x is not a rooted tree - orgsurveyr may not work as intended')
  } else if (!tidygraph::with_graph(x, tidygraph::graph_is_tree())) {
    stop('x is not a tree')
  }


}
