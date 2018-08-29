context('Organisation plotting')

library(tidygraph)
library(dplyr)
data("tg_org")
data("tg_org_indiv_df")
data("tg_org_indiv_tall_df")
data("tg_org_summarised_df")
data("mtcars")


test_that('plot_org input parameter error handling works',{

  # see test_check_tbl_graph_is_org for parameter checking of tbl_graph

  expect_error(plot_org(tg_org, fill_var='depth', df = 1, is_circular = FALSE),
               'inherits')

  expect_error(plot_org(tg_org, fill_var='depth', df = data_frame(), is_circular = FALSE),
               'data frame should be in org_tall_df format')

  expect_error(plot_org(tg_org, fill_var=c(1,2), df = NULL, is_circular = FALSE),
               'character')

  expect_error(plot_org(tg_org, fill_var='depth', df = NULL, is_circular = 3),
               'logical')

  expect_error(plot_org(tg_org, fill_var='blah', df = NULL, is_circular = FALSE),
               'fill_var')

  expect_error(plot_org(tg_org, fill_var='blah', df = tg_org_summarised_df, is_circular = FALSE),
               'nrow')


})
