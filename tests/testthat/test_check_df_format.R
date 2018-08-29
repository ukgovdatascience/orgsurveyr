context("Data frame format checking")

library(tidygraph)
library(dplyr)
data("tg_org")
data("tg_org_indiv_df")
data("tg_org_indiv_tall_df")
data("tg_org_summarised_df")
data("mtcars")

tg_org_nodes <- tg_org %>% activate(nodes) %>% as_tibble()

test_that("get_df_format output is correct", {

  expect_equal(get_df_format(tg_org_indiv_df), 'indiv_df')
  expect_equal(get_df_format(tg_org_indiv_tall_df), 'indiv_tall_df')
  expect_equal(get_df_format(tg_org_summarised_df), 'org_tall_df')
  expect_equal(get_df_format(mtcars), 'unknown')

})

test_that("check_df_format output is correct", {

  expect_equal(check_df_format(tg_org_indiv_df, 'indiv_df', dev_mode=FALSE), TRUE)
  expect_equal(check_df_format(tg_org_indiv_tall_df, 'indiv_tall_df', dev_mode=FALSE), TRUE)
  expect_equal(check_df_format(tg_org_summarised_df, 'org_tall_df', dev_mode=FALSE), TRUE)
  expect_equal(check_df_format(mtcars, 'unknown', dev_mode=FALSE), TRUE)

  expect_equal(check_df_format(tg_org_indiv_df, 'unknown', dev_mode=FALSE), FALSE)
  expect_equal(check_df_format(tg_org_indiv_tall_df, 'indiv_df', dev_mode=FALSE), FALSE)
  expect_equal(check_df_format(tg_org_summarised_df, 'indiv_tall_df', dev_mode=FALSE), FALSE)
  expect_equal(check_df_format(mtcars, 'org_tall_df', dev_mode=FALSE), FALSE)


})

test_that("check_df_format output is correct in dev_mode", {

  expect_equal(check_df_format(tg_org_indiv_df, 'indiv_df', dev_mode=TRUE), TRUE)
  expect_equal(check_df_format(tg_org_indiv_tall_df, 'indiv_tall_df', dev_mode=TRUE), TRUE)
  expect_equal(check_df_format(tg_org_summarised_df, 'org_tall_df', dev_mode=TRUE), TRUE)
  expect_equal(check_df_format(mtcars, 'unknown', dev_mode=TRUE), TRUE)

  expect_error(check_df_format(tg_org_indiv_df, 'org_tall_df', dev_mode=TRUE),
               "should be in org_tall_df format")
  expect_error(check_df_format(tg_org_indiv_tall_df, 'indiv_df', dev_mode=TRUE),
               "should be in indiv_df format")
  expect_error(check_df_format(tg_org_summarised_df, 'indiv_tall_df', dev_mode=TRUE),
               "should be in indiv_tall_df format")
  expect_error(check_df_format(mtcars, 'org_tall_df', dev_mode=TRUE),
               "should be in org_tall_df format")


})

test_that("functions that use check_df_format work correctly", {

  #generate_cumulative_mapping
  expect_error(generate_cumulative_mapping(tg_org, tg_org_indiv_tall_df),
               'should be in indiv_df format')

  #calc_summary_df
  expect_error(calc_summary_df(tg_org, data_frame(), NULL, 'test_var'),
               'should be in indiv_df format')
  expect_error(calc_summary_df(tg_org, tg_org_indiv_df, data_frame(), 'test_var'),
               'should be in indiv_tall_df format')

  #plot_org
  expect_error(plot_org(tg_org, df=data_frame()),
               'should be in org_tall_df format')

})
