% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/generate_cumulative_mapping_df.R
\name{generate_cumulative_mapping}
\alias{generate_cumulative_mapping}
\title{Generate Cumulative Mapping}
\usage{
generate_cumulative_mapping(tg, df)
}
\arguments{
\item{tg}{tbl_graph that passes a check with check_tbl_graph_is_org}

\item{df}{a data frame with columns named unit_id and invididual_id - see see the indiv_df format
in \code{\link{orgsurveyr-data-formats}}}
}
\value{
tbl_df
}
\description{
Takes an organisation as a tbl_graph object and a data frame that maps individuals to units
and returns a data frame that maps an organisational unit to all individuals within that unit.
}
\details{
For example, if an organisation is split into four departments, and each department has four teams,
an employee is affiliated not just to their immediate team, but also their department and the organisation
as a whole.

The output dataframe serves as a basis for calculating unit level summaries that include all individuals
affiliated to that unit.
}
\examples{

library(dplyr)
set.seed(1234)
tg_ex1 <- create_realistic_org(n_children = 4, max_depth = 3, prob=0.3)
tg_ex1 <- simulate_unit_size(tg_ex1)
df <- simulate_individuals_df(tg_ex1)

map_df <- generate_cumulative_mapping(tg_ex1, df)
map_df

#use the map to calculate cumulative means
df \%>\%
inner_join(map_df, by='individual_id') \%>\%
 group_by(parent_id) \%>\%
 summarise(cum_test_var = mean(test_var),
           cum_n = n())
}
