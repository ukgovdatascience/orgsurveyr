% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/check_tbl_graph_is_org.R
\name{check_tbl_graph_is_org}
\alias{check_tbl_graph_is_org}
\title{Check tbl_graph is an organisation}
\usage{
check_tbl_graph_is_org(x)
}
\arguments{
\item{x}{an object to check}
}
\description{
Verify that a tbl_graph has the right features to be an organisation
}
\examples{

library(tidygraph)

set.seed(1234)
tg1 <- create_realistic_org()
check_tbl_graph_is_org(tg1)
# returns no errors

tg2 <- tidygraph::create_star(30)
\dontrun{
check_tbl_graph_is_org(tg2)
# returns an error
}

tg3 <- filter(tg1, unit_id != 1)
check_tbl_graph_is_org(tg3)
# returns a warning that the tree is no longer rooted

}
