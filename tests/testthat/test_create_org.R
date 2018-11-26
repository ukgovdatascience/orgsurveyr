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

  expect_error(create_regular_org(n_children = 'x', max_depth = 3), "is.numeric")
  expect_error(create_regular_org(n_children = 2, max_depth = 'x'), "is.numeric")
  expect_error(create_regular_org(n_children = 2.2, max_depth = 3), "n_children%%1")
  expect_error(create_regular_org(n_children = 2, max_depth = 3.2), "max_depth%%1")
  expect_error(create_regular_org(n_children = -2, max_depth = 3), "n_children > 0")
  expect_error(create_regular_org(n_children = 2, max_depth = -3), "max_depth > 0")

})

test_that("create_realistic_org generates expected output", {

  set.seed(1235)
  real_tg1 <- create_realistic_org(n_children = 5, max_depth = 3, prob = 0.4, delete_units = TRUE)

  expect_is(real_tg1, 'tbl_graph')
  # number of nodes total
  expect_equal(real_tg1 %>% activate(edges) %>% as_tibble() %>% nrow(), 44)
  expect_equal(real_tg1 %>% activate(nodes) %>% as_tibble() %>% nrow(), 45)
  # number of columns in nodes table
  expect_equal(real_tg1 %>% activate(nodes) %>% as_tibble() %>% ncol(), 2)
  # number of nodes in a given org_depth
  expect_equal(real_tg1 %>% filter(org_depth>=2) %>% activate(nodes) %>% as_tibble() %>% nrow(), 41)


  set.seed(1235)
  real_tg2 <- create_realistic_org(n_children = 5, max_depth = 3, prob = 0.4, delete_units = FALSE)

  expect_is(real_tg2, 'tbl_graph')
  # number of nodes total
  expect_equal(real_tg2 %>% activate(edges) %>% as_tibble() %>% nrow(), 155)
  expect_equal(real_tg2 %>% activate(nodes) %>% as_tibble() %>% nrow(), 156)
  # number of columns in nodes table
  expect_equal(real_tg2 %>% activate(nodes) %>% as_tibble() %>% ncol(), 5)
  # number of nodes in a given depth
  expect_equal(real_tg2 %>% filter(org_depth>=2) %>% activate(nodes) %>% as_tibble() %>% nrow(), 150)


  set.seed(1235)
  real_tg3 <- create_realistic_org(n_children = 4, max_depth = 3, prob = c(0.1, 0.2, 0.3), delete_units = TRUE)

  expect_is(real_tg3, 'tbl_graph')
  # number of nodes total
  expect_equal(real_tg3 %>% activate(edges) %>% as_tibble() %>% nrow(), 46)
  expect_equal(real_tg3 %>% activate(nodes) %>% as_tibble() %>% nrow(), 47)
  # number of columns in nodes table
  expect_equal(real_tg3 %>% activate(nodes) %>% as_tibble() %>% ncol(), 2)
  # number of nodes in a given org_depth
  expect_equal(real_tg3 %>% filter(org_depth>=2) %>% activate(nodes) %>% as_tibble() %>% nrow(), 43)


})


test_that("create_realistic_org input parameter error handling works", {

  expect_error(create_realistic_org(n_children = 4, max_depth = 3, prob='x', .f=NULL, delete_units=TRUE),
               "is.numeric")
  expect_error(create_realistic_org(n_children = 4, max_depth = 3, prob=1.1, .f=NULL, delete_units=TRUE),
               "prob must be between 0 and 1")
  expect_error(create_realistic_org(n_children = 4, max_depth = 3, prob=c(0.3, 1.1), .f=NULL, delete_units=TRUE),
               "prob must be between 0 and 1")
  expect_error(create_realistic_org(n_children = 4, max_depth = 3, prob=c(-0.3, 0.9), .f=NULL, delete_units=TRUE),
               "prob must be between 0 and 1")
  expect_error(create_realistic_org(n_children = 4, max_depth = 3, prob=c(0.3, 0.9), .f=NULL, delete_units=TRUE),
               "length")
  expect_error(create_realistic_org(n_children = 4, max_depth = 3, prob=.3, .f=NULL, delete_units=3),
               "is.logical")

})


# zero node graph tests ---------------------------------------------------
zero_node_example <- function() {
  set.seed(1232)
  create_realistic_org(4,3, prob=0.5, delete_units = TRUE)
}

test_that("create_realistic_org handles empty graphs gracefully", {

  expect_warning(tg0 <- zero_node_example(),
                 "Simulated organisation has zero units")

})

test_that("check_tbl_graph_is_org handles empty graphs gracefully", {

  tg0 <- suppressWarnings(zero_node_example())

  expect_error(check_tbl_graph_is_org(tg0),
                 "x has zero nodes")


})
