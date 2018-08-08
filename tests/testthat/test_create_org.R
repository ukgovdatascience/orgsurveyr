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

