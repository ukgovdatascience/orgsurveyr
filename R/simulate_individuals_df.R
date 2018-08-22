#' Simulate individuals data frame
#'
#' Given an organisation tbl_graph object with the unit_size column defined, a tibble will be generated
#' with one row per individual in the organisation.  For test purposes a dummy variable is also generated.
#'
#' @param x tbl_graph organisation with unit_size defined
#'
#' @return tibble
#' @export
#'
#' @examples
#' set.seed(1234)
#' tg_ex1 <- create_realistic_org(n_children = 4, max_depth = 3, prob=0.3)
#' tg_ex1 <- simulate_unit_size(tg_ex1)
#' df <- simulate_individuals_df(tg_ex1)
#' df
simulate_individuals_df <- function(x) {

  check_tbl_graph_is_org(x)

  nodes_df <- x %>%
    tidygraph::activate(nodes) %>%
    tidygraph::as_tibble()

  check_unit_size <- 'unit_size' %in% colnames(nodes_df)

  if(!check_unit_size) {
    stop('Need to generate unit size first using the simulate_unit_size function')
  }

  nodes_df %>%
    dplyr::mutate(individual_name = purrr::map2(unit_id, unit_size, ~paste(.x, seq(1,.y), sep='_')),
                  test_var = purrr::map(unit_size, ~stats::rnorm(., mean=10, sd=3))) %>%
    tidyr::unnest() %>%
    dplyr::mutate(individual_id = dplyr::row_number()) %>%
    dplyr::select(individual_id, individual_name, unit_id, test_var)

}
