# Plotting spray chart over specified time

Plotting spray chart over specified time

## Usage

``` r
plot_spray_chart(firstName, lastName, startDate, endDate, playerIndex = 1)
```

## Arguments

- firstName:

  A string

- lastName:

  A string

- startDate:

  A string formatted YYYY-MM-DD

- endDate:

  A string formatted YYYY-MM-DD

- playerIndex:

  A positive integer

## Value

A table with all players that match the input name, and a spray chart
plot of the specified time period data

## Examples

``` r
plot_spray_chart("Juan","Soto", "2024-05-19", "2025-06-05", playerIndex = 6)
#> ── Player ID Lookup from the Chadwick Bureau's public register of baseball playe
#> ℹ Data updated: 2026-05-27 01:46:55 UTC
#> # A tibble: 6 × 11
#>   first_name last_name given_name   name_suffix nick_name birth_year
#>   <chr>      <chr>     <chr>        <chr>       <chr>          <int>
#> 1 Juan       DeSoto    Juan Enrique ""          ""              1962
#> 2 Juan       Soto      Juan H.      ""          ""              1990
#> 3 Juan       Soto      Juan Ruddy   ""          ""              2003
#> 4 Juan       Soto      Juan A.      ""          ""              1972
#> 5 Juan       DeSoto    Juan         ""          ""                NA
#> 6 Juan       Soto      Juan Jose    ""          ""              1998
#> # ℹ 5 more variables: mlb_played_first <int>, mlbam_id <int>,
#> #   retrosheet_id <chr>, bbref_id <chr>, fangraphs_id <int>
#> Error in setnames(x, value): Can't assign 92 names to a 118-column data.table
```
