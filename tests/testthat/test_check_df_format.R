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

})
