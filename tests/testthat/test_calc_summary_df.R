context("Summary calculations")

library(tidygraph)
library(dplyr)
set.seed(1231)
tg1b <-
  create_realistic_org(4, 3, prob = 0.3, delete_units = TRUE) %>% simulate_unit_size

tg1b_indiv_df <- tg1b %>%
  simulate_individuals_df() %>%
  mutate(test_var2 = purrr::map_dbl(individual_id, ~ rnorm(1, 20, 3)))
tg1b_indiv_df

tg1b_indiv_tall_df <- tg1b_indiv_df %>%
  select(individual_id, test_var, test_var2) %>%
  tidyr::gather('metric_id', 'value',-individual_id)
tg1b_indiv_tall_df

# simple output
t1 <-
  calc_summary_df(tg1b, tg1b_indiv_df, NULL, 'test_var2', is_cumulative = TRUE)

# testing combinations of input parameters
test_setup <-
  data_frame(
    tg = list(tg1b),
    df = list(tg1b_indiv_df),
    tall_df = list(NULL, tg1b_indiv_tall_df)
  ) %>%
  tidyr::crossing(data_frame(selected_vars = list('test_var2', c('test_var', 'test_var2')))) %>%
  tidyr::crossing(is_cumulative = c(TRUE, FALSE))

test_output <- test_setup %>%
  dplyr::mutate(output = purrr::pmap(
    .l =
      list(
        tg = tg,
        df = df,
        tall_df = tall_df,
        selected_vars = selected_vars,
        is_cumulative = is_cumulative
      ),
    .f = calc_summary_df
  ))

test_that("calc_summary_df generates expected output", {
  expect_is(t1, 'tbl_df')
  purrr::walk(test_output$output, ~ expect_is(., 'tbl'))

  # number of rows and columns in output tables
  expect_equal(nrow(t1), 29)
  expect_equal(ncol(t1), 3)
  expect_equal(colnames(t1), c('unit_id', 'metric_id', 'value'))

  purrr::walk(test_output$output, ~ expect_equal(ncol(.), 3))
  purrr::walk(test_output$output, ~ expect_equal(colnames(.), c('unit_id', 'metric_id', 'value')))
  expect_equal(purrr::map_dbl(test_output$output, nrow), c(29, 29, 58, 58, 29, 29, 58, 58))

  # check values for each table generated
  expect_equal(t1$value[1:6], c(19.6247378317358, 20.3542107587949, 19.0223275134199, 19.482988347118,
                                20.4853179279958, 19.1934190306043))
  ## could store expected output df and compare here

})

test_that("calc_summary_df input parameter error handling works", {

  # see test_check_tbl_graph_is_org for parameter checking of tbl_graph

  expect_error(calc_summary_df(tg1b, 1, NULL, 'test_var2', is_cumulative = TRUE),
               'inherits')

  expect_error(calc_summary_df(tg1b, data_frame(), NULL, 'test_var2', is_cumulative = TRUE),
               'data frame should be in indiv_df format')

  expect_error(calc_summary_df(tg1b, tg1b_indiv_df, 1, 'test_var2', is_cumulative = TRUE),
               'inherits')

  expect_error(calc_summary_df(tg1b, tg1b_indiv_df, data_frame(), 'test_var2', is_cumulative = TRUE),
               'data frame should be in indiv_tall_df format')

  expect_error(calc_summary_df(tg1b, tg1b_indiv_df, NULL, 1, is_cumulative = TRUE),
               'character')

  expect_error(calc_summary_df(tg1b, tg1b_indiv_df, NULL, 'test_var2', is_cumulative = 3),
               'logical')


})
