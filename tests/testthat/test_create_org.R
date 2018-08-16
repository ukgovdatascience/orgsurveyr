context("Organisation network creation")

library(dplyr)
library(tidygraph)

tg1 <- create_regular_org(n_children = 4, max_depth = 3)
tg2 <- create_regular_org(n_children = 3, max_depth = 4)

test_that("create_regular_org generates expected output", {

  expect_is(tg1, 'tbl_graph')
  expect_equal(tg1 %>% activate(edges) %>% as_tibble() %>% nrow(), 84)
  expect_equal(tg1 %>% activate(nodes) %>% as_tibble() %>% nrow(), 85)
  expect_equal(tg2 %>% activate(edges) %>% as_tibble() %>% nrow(), 120)
  expect_equal(tg2 %>% activate(nodes) %>% as_tibble() %>% nrow(), 121)

})

test_that("create_regular_org input parameter error handling works", {

})

test_that("create_realistic_org generates expected output", {

  set.seed(1235)
  real_tg1 <- create_realistic_org(n_children = 5, max_depth = 3, prob = 0.4, delete_units = TRUE)

  # number of nodes total
  # number of nodes in a given depth
  # number of columns in nodes table

  set.seed(1235)
  real_tg2 <- create_realistic_org(n_children = 5, max_depth = 3, prob = 0.4, delete_units = FALSE)

  # number of nodes total
  # number of nodes in a given depth
  # number of columns in nodes table


  set.seed(1235)
  real_tg3 <- create_realistic_org(n_children = 4, max_depth = 3, prob = c(0.1, 0.2, 0.3), delete_units = TRUE)

  # number of nodes total
  # number of nodes in a given depth
  # number of columns in nodes table


})


test_that("create_realistic_org input parameter error handling works", {

})
