#' Simple organisation plot
#'
#' Bare bones function to plot an organisation style dendrogram from a tidygraph object.
#'
#' Note that the recommended way to plot organisations is using the ggraph package.  Some examples of how to do this
#' are included in the vignettes.  This simple function is provided as a convenience for new users and to use in examples.
#'
#' DEV NOTE: in ggplot2 version 3.0.0 tidyeval is available so should be able to use this rather than aes_string
#'
#' @param x organisation as a tidygraph object (tidygraph)
#' @param fill_var the variable to use as a fill colour for units (column name)
#' @param is_circular whether to make the dendrogram circular which is useful for larger organisations (logical)
#'
#' @return ggraph object
#' @import ggraph ggplot2
#' @export
#'
#' @examples
#' \dontrun{
#' set.seed(1234)
#' tg <- create_realistic_org()
#' plot_org(tg)
#' plot_org(tg, is_circular=TRUE)
#' }

plot_org <- function(x, fill_var = 'depth', is_circular = FALSE) {

  ggraph(x, 'dendrogram', circular = is_circular) +
    geom_edge_diagonal() +
    geom_node_point(aes_string(fill = fill_var),
                    shape = 21, size = 5) +
    theme_bw()

}
