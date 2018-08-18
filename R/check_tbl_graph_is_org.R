#' Check tbl_graph is an organisation
#'
#' Verify that a tbl_graph has the right features to be an organisation
#'
#' @param x
#'
#' @return logical
#' @export
#'
#' @examples
#'
#' library(tidygraph)
#'
#' set.seed(1234)
#' tg1 <- create_realistic_org()
#' check_tbl_graph_is_org(tg1)
#' # returns TRUE
#'
#' tg2 <- tidygraph::create_star(30)
#' check_tbl_graph_is_org(tg2)
#' # returns FALSE
#'
check_tbl_graph_is_org <- function(x) {

  if(!tidygraph::is.tbl_graph(x)) {
    message('x is not a tbl_graph object')
    return(FALSE)
  }

  if(!tidygraph::with_graph(x, tidygraph::graph_is_tree())) {
    message('x is not a tree')
    return(FALSE)
  }

  return(TRUE)

}
