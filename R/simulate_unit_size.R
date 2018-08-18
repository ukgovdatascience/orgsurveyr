#' Simulate unit sizes within an organisation
#'
#' Function which takes a tbl_graph object representing an organisation and generates a number representing
#' the number of individuals immediately associated each unit.
#'
#' @param tg a tbl_graph object representing an organisation
#'
#' @return
#' @export
#'
#' @examples
#' NULL
simulate_unit_size <- function(tg) {

  tg %>%
    dplyr::mutate(
      unit_id = dplyr::row_number(),
      is_leaf = tidygraph::node_is_leaf(),
      unit_size = purrr::map_dbl(is_leaf, .generate_unit_size)
    )

}

#'Generate the size of an org unit
#'
#' Internal helper function to generate the size of an organisational unit based on whether it is a leaf node or not
#'
#' @param is_leaf_node logical: whether the node is a leaf node or not
#'
#' @return integer
#'
#' @examples
#' NULL
.generate_unit_size <- function(is_leaf_node) {
  if (is_leaf_node) {
    ceiling(rbeta(1, 10, 40)*20)
  } else {
    sample(1:3, 1)
  }
}
