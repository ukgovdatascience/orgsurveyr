context("Simulate unit size")

library(dplyr)
library(tidygraph)

set.seed(1234)
tg_ex1 <- create_realistic_org(n_children = 4, max_depth = 3, prob=0.3) %>%
  simulate_unit_size()

test_that("simulate_unit_size generates expected output", {

  expect_is(tg_ex1, 'tbl_graph')

  tg_ex1_nodes <- tg_ex1 %>% activate(nodes) %>% as_tibble()
  tg_ex1_edges <- tg_ex1 %>% activate(edges) %>% as_tibble()

  # number of edges and nodes
  expect_equal(nrow(tg_ex1_edges), 41)
  expect_equal(nrow(tg_ex1_nodes), 42)

  # number of columns in nodes table
  expect_equal(ncol(tg_ex1_nodes), 4)

  # check values of unit size generated
  expect_equal(tg_ex1_nodes %>% select(unit_size) %>% slice(1:5) %>% unlist() %>% unname(), c(3, 2, 1, 1, 3))

})

# see test_check_tbl_graph_is_org for parameter checking of tbl_graph
