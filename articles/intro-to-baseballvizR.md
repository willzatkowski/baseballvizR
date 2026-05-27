# Introduction to baseballvizR

The `baseballvizR` package provides convenience functions for some
common tasks. I wanted to make this package because baseball statistics
are just numbers on a page and don’t always tell the full story. With
the functions in this package you can get a glimpse behind just the raw
data and start to see trends.

To install this package from GitHub, use

``` r

# install.packages("remotes")
# install.packages("devtools")
devtools::install_github("ADC-405-S26/baseballvizR")
```

Load the package using the following code.

``` r

library(baseballvizR)
```

The package contains three functions

- `plot_zone_heatmap`

- `plot_spray_chart`

- `calculate_hitter_profile`
