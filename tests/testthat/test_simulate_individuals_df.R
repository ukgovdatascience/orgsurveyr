context("Simulate individuals data frame")

library(dplyr)
library(tidygraph)

set.seed(1234)
tg_ex1 <- create_realistic_org(n_children = 4, max_depth = 3, prob=0.3)
tg_ex2 <- simulate_unit_size(tg_ex1)
df <- simulate_individuals_df(tg_ex2)

test_that("simulate_individuals_df generates expected output", {

  expect_is(df, 'tbl_df')

  #size of data frame
  expect_equal(nrow(df), 146)

  # check values of unit size generated
  expect_equal(df %>% select(individual_name) %>% slice(1:5) %>% unlist() %>% unname(), c("1_1", "1_2", "1_3", "2_1", "2_2"))

  # check values of test_var generated
  expect_equal(df %>% select(test_var) %>% slice(1:5) %>% unlist() %>% unname(),
               c(8.64103276261495, 10.6384999981502, 9.44776320365966, 12.1104237849795, 10.459657270596))


})

test_that("simulate_individuals_df input parameter error handling works", {

  # derived from check_tbl_graph_is_org
  expect_error(simulate_unit_size(1), "x is not a tbl_graph")
  expect_error(simulate_unit_size(create_star(20)), "x is not a tree")
  expect_warning(tg_ex1 %>% filter(unit_id != 1) %>% simulate_unit_size(), 'x is not a rooted tree')

  # check error message when unit_size not present
  expect_error(simulate_individuals_df(tg_ex1), 'Need to generate unit size first')


})
