context("Example dataset creation")

library(tidygraph)
library(dplyr)
data("tg_org")
data("tg_org_indiv_df")
data("tg_org_indiv_tall_df")
data("tg_org_summarised_df")

tg_org_nodes <- tg_org %>% activate(nodes) %>% as_tibble()


test_that("example dataset tg_org has been generated as expected", {

  #tg_org
  expect_is(tg_org, 'tbl_graph')
  expect_equal(dim(tg_org_nodes), c(38,4))
  expect_equal(colnames(tg_org_nodes), c("unit_id", "org_depth", "is_leaf", "unit_size"))

})

test_that("example dataset tg_org_indiv_df has been generated as expected", {

  #tg_org_indiv_df
  expect_is(tg_org_indiv_df, 'data.frame')
  expect_equal(dim(tg_org_indiv_df), c(146,5))
  expect_equal(colnames(tg_org_indiv_df),
               c("individual_id", "individual_name", "unit_id", "test_var", "test_var2"))
  expect_equal(tg_org_indiv_df$test_var[1:5],
               c(7.27120357870557, 8.52708686714899, 9.21213868594158, 12.8746475191596,
                 5.01780702303503))
})

test_that("example dataset tg_org_indiv_tall_df has been generated as expected", {

  #tg_org_indiv_tall_df
  expect_is(tg_org_indiv_tall_df, 'data.frame')
  expect_equal(dim(tg_org_indiv_tall_df), c(292,3))
  expect_equal(colnames(tg_org_indiv_tall_df),
               c("individual_id", "metric_id", "value"))
  expect_equal(tg_org_indiv_tall_df$value[1:5],
               c(7.27120357870557, 8.52708686714899, 9.21213868594158, 12.8746475191596,
                 5.01780702303503))
})

test_that("example dataset tg_org_summarised_df has been generated as expected", {

  #tg_org_summarised_df
  expect_is(tg_org_summarised_df, 'data.frame')
  expect_equal(dim(tg_org_summarised_df), c(76,3))
  expect_equal(colnames(tg_org_summarised_df),
               c("unit_id", "metric_id", "value"))
  expect_equal(tg_org_summarised_df$value[1:5],
               c(10.168569768016, 20.2131138471325, 10.9109698461405, 20.1530991768429,
                 10.4401917959373))

})
