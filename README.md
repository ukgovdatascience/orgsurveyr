
<!-- README.md is generated from README.Rmd. Please edit that file -->
    ## 
    ## Attaching package: 'tidygraph'

    ## The following object is masked from 'package:stats':
    ## 
    ##     filter

orgsurveyr
==========

The goal of `orgsurveyr` is to facilitate the use of Tom Lin Pederson's excellent `tidygrap`h and `ggraph` packages with organisational information used by many Human Resources departments, in particular employee surveys.

Installation
------------

You can install orgsurveyr from github with:

``` r
# install.packages("devtools")
devtools::install_github("ukgovdatascience/orgsurveyr")
```

Example
-------

An organisation is a very basic type of network known as a tree. The tidygraph package lets us simulate and represent a tree structure as follows:

``` r
tg <- tidygraph::create_tree(13,3) 
tg
#> # A tbl_graph: 13 nodes and 12 edges
#> #
#> # A rooted tree
#> #
#> # Node Data: 13 x 0 (active)
#> #
#> # Edge Data: 12 x 2
#>    from    to
#>   <int> <int>
#> 1     1     2
#> 2     1     3
#> 3     1     4
#> # ... with 9 more rows
```

The `ggraph` package can be used to plot networks with the familiar `ggplot2` syntax. Below the simulated organisation is plotted as a dendrogram:

``` r
  ggraph(tg, 'dendrogram') + geom_edge_diagonal() + 
  geom_node_point(size=5) + theme_bw()
```

![](README-example-2-1.png)

The `orgsurveyr` provides detailed vignettes, convenience functions and example data to help HR analysts make use of the `ggraph` and `tidygraph` packages in the analysis of organisation data.
