# script to create data format examples

library(orgsurveyr)
library(tidygraph)
library(dplyr)
set.seed(1236)

# tidygraph org object
tg_org <- create_realistic_org(4,3, prob=0.3, delete_units = TRUE) %>% simulate_unit_size
devtools::use_data(tg_org, overwrite=TRUE)

# individuals data frame (1 row per individual)
tg_org_indiv_df <- tg_org %>%
  simulate_individuals_df() %>%
  mutate(test_var2 = purrr::map_dbl(individual_id, ~rnorm(1, 20,3)))
devtools::use_data(tg_org_indiv_df, overwrite=TRUE)

# minimal individuals data frame (1 row per individual)
tg_org_indiv_minimal_df <- tg_org_indiv_df %>%
  dplyr::select(individual_id, unit_id)
devtools::use_data(tg_org_indiv_minimal_df, overwrite=TRUE)

# tall invididuals data frame (multiple rows per individual)
tg_org_indiv_tall_df <- tg_org_indiv_df %>%
  select(individual_id, test_var, test_var2) %>%
  tidyr::gather('metric_id', 'value', -individual_id)
devtools::use_data(tg_org_indiv_tall_df, overwrite=TRUE)

# summarised data (multiple rows per unit)
tg_org_summarised_df <- calc_summary_df(tg_org, tg_org_indiv_df, NULL,
                                    c('test_var', 'test_var2'), is_cumulative=TRUE)
devtools::use_data(tg_org_summarised_df, overwrite=TRUE)
