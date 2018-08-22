context("Summary calculations")

library(tidygraph)
library(dplyr)
set.seed(1231)
tg1b <- create_realistic_org(4,3, prob=0.3, delete_units = TRUE) %>% simulate_unit_size

tg1b_indiv_df <- tg1b %>%
  simulate_individuals_df() %>%
  mutate(test_var2 = purrr::map_dbl(individual_id, ~rnorm(1, 20,3)))
tg1b_indiv_df

tg1b_indiv_tall_df <- tg1b_indiv_df %>%
  select(individual_id, test_var, test_var2) %>%
  tidyr::gather('metric_id', 'value', -individual_id)
  tg1b_indiv_tall_df

 # using wide data frame
t1 <- calc_summary_df(tg1b, tg1b_indiv_df, NULL, 'test_var2', is_cumulative=TRUE)
t2 <- calc_summary_df(tg1b, tg1b_indiv_df, NULL, c('test_var', 'test_var2'), is_cumulative=TRUE)
t3 <- calc_summary_df(tg1b, tg1b_indiv_df, NULL, 'test_var2', is_cumulative=FALSE)
t4 <- calc_summary_df(tg1b, tg1b_indiv_df, NULL, c('test_var', 'test_var2'), is_cumulative=FALSE)

 # using tall data frame
t5 <- calc_summary_df(tg1b, tg1b_indiv_df, tg1b_indiv_tall_df, 'test_var2', is_cumulative=TRUE)
t6 <- calc_summary_df(tg1b, tg1b_indiv_df, tg1b_indiv_tall_df, c('test_var', 'test_var2'), is_cumulative=TRUE)
t7 <- calc_summary_df(tg1b, tg1b_indiv_df, tg1b_indiv_tall_df, 'test_var2', is_cumulative=FALSE)
t8 <- calc_summary_df(tg1b, tg1b_indiv_df, tg1b_indiv_tall_df, c('test_var', 'test_var2'), is_cumulative=FALSE)

test_that("calc_summary_df generates expected output", {

  expect_is(t1, 'tbl_df')
  expect_is(t2, 'tbl_df')
  expect_is(t3, 'tbl_df')
  expect_is(t4, 'tbl_df')
  expect_is(t5, 'tbl_df')
  expect_is(t6, 'tbl_df')
  expect_is(t7, 'tbl_df')
  expect_is(t8, 'tbl_df')


  # number of rows and columns in output tables

  # check values for each table generated

})

test_that("calc_summary_df input parameter error handling works", {



})
