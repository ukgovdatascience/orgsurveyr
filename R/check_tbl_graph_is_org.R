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
