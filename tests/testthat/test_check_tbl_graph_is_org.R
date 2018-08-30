context("Organisation network object format checking")

library(tidygraph)
library(dplyr)
data("tg_org")
data("tg_org_indiv_df")
data("tg_org_indiv_tall_df")
data("tg_org_summarised_df")
data("mtcars")

test_that("check_tbl_graph_is_org behaviour is correct", {

  expect_error(check_tbl_graph_is_org(1), "x is not a tbl_graph")
  expect_error(check_tbl_graph_is_org(create_star(20)), "x is not a tree")
  expect_warning(tg_org %>% filter(unit_id != 1) %>% check_tbl_graph_is_org(), 'x is not a rooted tree')

})

## may be worth checking behaviour of functions which call check_tbl_graph_is_org?


