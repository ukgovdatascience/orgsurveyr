context("Generate cumulative mapping")

library(dplyr)
library(tidygraph)
set.seed(1234)
tg_ex1 <- create_realistic_org(n_children = 4, max_depth = 3, prob=0.3)
tg_ex1 <- simulate_unit_size(tg_ex1)
df <- simulate_individuals_df(tg_ex1)
map_df <- generate_cumulative_mapping(tg_ex1, df)
group_size_df <- count(map_df, parent_id)

test_that("generate_cumulative_mapping generates expected output", {

  expect_is(map_df, 'tbl_df')

  #size of data frame
  expect_equal(nrow(map_df), 552)
  expect_equal(ncol(map_df), 2)

  # check values of unit size generated
  expect_equal(group_size_df %>% select(n) %>% slice(1:5) %>% unlist() %>% unname(), c(146L, 59L, 64L, 20L, 21L))

})

test_that("generate_cumulative_mapping input parameter error handling works", {

  # derived from check_tbl_graph_is_org
  expect_error(generate_cumulative_mapping(1, df), "x is not a tbl_graph")
  expect_error(generate_cumulative_mapping(create_star(20), df), "x is not a tree")
  expect_warning(tg_ex1 %>% filter(unit_id != 1) %>% generate_cumulative_mapping(., df), 'x is not a rooted tree')

  # check error message when df is not a data frame
  expect_error(generate_cumulative_mapping(tg_ex1, 1), "inherits")

  # check error message when unit_id not present
  expect_error(generate_cumulative_mapping(tg_ex1, select(df, -unit_id)),
               'should be in indiv_df format')

  expect_error(generate_cumulative_mapping(tg_ex1, select(df, -individual_id)),
               'should be in indiv_df format')

})


