#' @title Example organisation tbl_graph object

#' @description
#' An organisation represented as a tidygraph tbl_graph object and generated
#' by the create_realistic_org function.
#'
"tg_org"

#' @title Example indiv_df data frame

#' @description
#' An example of the indiv_df data frame format where individual level data is
#' represented as a single row per individual and multiple columns represent
#' different variables.
#'
#' @format A data frame with 146 rows and 5 variables:
#' \describe{
#'  \item{individual_id}{The ID of the individual}
#'  \item{individual_name}{The name of the individual}
#'  \item{unit_id}{The organisational unit to which the individual belongs}
#'  \item{test_var}{A simulated variable}
#'  \item{test_var2}{Another simulated variable}
#'  }
#'
"tg_org_indiv_df"

#' @title Example minimal indiv_df data frame

#' @description
#' An example of the minimal indiv_df data frame format with just the columns necessary to allow
#' individuals to be mapped to their organisational units.
#'
#' @format A data frame with 146 rows and 2 variables:
#' \describe{
#'  \item{individual_id}{The ID of the individual}
#'  \item{unit_id}{The organisational unit to which the individual belongs}
#'  }
#'
"tg_org_indiv_minimal_df"

#' @title Example indiv_tall_df data frame

#' @description
#' An example of a data frame in the indiv_tall_df data frame format where
#' an individual is represented by multiple rows, and each row represents a
#' different variable.
#'
#' @format A data frame with 292 rows and 3 variables:
#' \describe{
#'  \item{individual_id}{The ID of the individual}
#'  \item{metric_id}{The name of the variable}
#'  \item{value}{The value of the variable}
#'  }
#'
"tg_org_indiv_tall_df"

#' @title Example org_tall_df data frame

#' @description
#' An example of a data frame in the org_tall_df data frame format where
#' an organisational unit is represented by multiple rows, and each row represents a
#' different summarised variable.
#'
#' @format A data frame with 76 rows and 3 variables:
#' \describe{
#'  \item{unit_id}{The organisational unit}
#'  \item{metric_id}{The name of the variable}
#'  \item{value}{The value of the variable}
#'  }
#'
"tg_org_summarised_df"

