#' Simulate unit sizes for an organisation
#'
#' Function which takes a tbl_graph object representing an organisation and generates a number representing
#' the number of individuals immediately associated with each unit.  This number is stored as the `unit_size` variable
#' in the nodes tibble of the tbl_graph object.
#'
#' @param x a tbl_graph object representing an organisation
#'
#' @return tbl_graph
#' @export
#'
#' @examples
#' set.seed(1234)
#' tg_ex1 <- create_realistic_org(n_children = 4, max_depth = 3, prob=0.3)
#' tg_ex1 <- simulate_unit_size(tg_ex1)
#'
#' \dontrun{
#' set.seed(1234)
#' create_realistic_org(n_children = 4, max_depth = 3, prob=0.3) %>%
#'    simulate_unit_size() %>%
#'    plot_org() + geom_node_text(aes(label=unit_size), color='white')
#'}
simulate_unit_size <- function(x) {

  stopifnot(check_tbl_graph_is_org(x))

  x %>%
    dplyr::mutate(
      is_leaf = tidygraph::node_is_leaf(),
      unit_size = purrr::map_dbl(is_leaf, .generate_unit_size)
    )

}

# helper function to generate the size of an org unit
.generate_unit_size <- function(is_leaf_node) {
  if (is_leaf_node) {
    ceiling(rbeta(1, 10, 40)*20)
  } else {
    sample(1:3, 1)
  }
}
