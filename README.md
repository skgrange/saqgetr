# **saqgetr**

[![Build Status](https://travis-ci.org/skgrange/saqgetr.svg?branch=master)](https://travis-ci.org/skgrange/saqgetr)

**saqgetr** is an R package to import air quality monitoring data in a fast and easy way. Currently, only European data are available, but the package is generic and therefore data from other areas may be included in the future. 

## Installation

To install the development version, install [**devtools**](https://github.com/r-lib/devtools) or [**remotes**](https://github.com/r-lib/remotes) and then use this: 

```
# Install development version saqgetr
remotes::install_github("skgrange/saqgetr")
```

**saqgetr** should make it onto CRAN in the near future. 

## Framework

**saqgetr** acts as an interface to pre-prepared data files located on a web server. For each monitoring site serviced, there is a single file containing all observations. There are a number of metadata files too which enable users to further understand the location and type of observations are available. The data files are compressed text files (`.csv.gz`) which allows for simple and fast importing and if other interfaces wish to be developed, this should be simple. 

## Usage

### Sites

To import data with **saqgetr**, functions with the `get_saq_*` prefix are used. A monitoring site must be supplied to get observations. To find what sites are available use `get_saq_sites`: 

```
# Load packages
library(dplyr)
library(sairr)

# Import site information
data_sites <- get_saq_sites()

# Glimpse tibble
glimpse(data_sites)

#> Observations: 633
#> Variables: 16
#> $ site              <chr> "gb0001a", "gb0002r", "gb0004r", "gb0006r", "g…
#> $ site_name         <chr> "BONNYRIGG 1", "Eskdalemuir", "Stoke Ferry", "…
#> $ latitude          <dbl> 55.87389, 55.31531, 52.55985, 54.43951, 50.597…
#> $ longitude         <dbl> -3.104447, -3.206111, 0.506147, -7.900328, -3.…
#> $ elevation         <dbl> 111, 255, 3, 130, 119, 267, 270, 5, 370, 32, 1…
#> $ country           <chr> "united_kingdom", "united_kingdom", "united_ki…
#> $ country_iso_code  <chr> "GB", "GB", "GB", "GB", "GB", "GB", "GB", "GB"…
#> $ site_type         <chr> "background", "background", "background", "bac…
#> $ site_area         <chr> "suburban", "rural", "rural", "rural", "rural"…
#> $ date_start        <dttm> 1997-04-01, 1986-04-23, 1997-01-01, 1987-04-0…
#> $ date_end          <dttm> 1998-07-06 00:00:00, 2017-12-31 22:00:00, 201…
#> $ network           <chr> NA, "GB_Network_1", "GB_Network_1", "GB_Networ…
#> $ eu_code           <chr> NA, "Station_GB0002R", "Station_GB0004R", "Sta…
#> $ eoi_code          <chr> NA, "GB0002R", "GB0004R", "GB0006R", "GB0013R"…
#> $ observation_count <dbl> 859, 762289, 1974, 665118, 738157, 722719, 606…
#> $ data_source       <chr> "airbase", "aqer:e1a", "aqer:e1a", "aqer:e1a",…
```

### Observations

Sites are represented by a code which is prefixed with the country's ISO code, for example, a site in York, England, United Kingdom is identified as `gb0919a` (the ISO code for the United Kingdom is non-standard and GB is for Great Britain). To get observations this site, use `get_sairr_observations`:

```{r}
# Get air quality monitoring data for a York site
data_york <- get_saq_observations(site = "gb0919a")

# Glimpse tibble
glimpse(data_york)

#> Observations: 333,741
#> Variables: 10
#> $ date      <dttm> 2008-01-01, 2008-01-02, 2008-01-03, 2008-01-04, 2008-…
#> $ date_end  <dttm> NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, N…
#> $ site      <chr> "gb0919a", "gb0919a", "gb0919a", "gb0919a", "gb0919a",…
#> $ site_name <chr> "York Fishergate", "York Fishergate", "York Fishergate…
#> $ variable  <chr> "pm10", "pm10", "pm10", "pm10", "pm10", "pm10", "pm10"…
#> $ process   <int> 62392, 62392, 62392, 62392, 62392, 62392, 62392, 62392…
#> $ summary   <int> 20, 20, 20, 20, 20, 20, 20, 20, 20, 20, 20, 20, 20, 20…
#> $ validity  <int> 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 0, 0, 1, …
#> $ unit      <chr> "µg/m3", "µg/m3", "µg/m3", "µg/m3", "µg/m3", "µg/m3", …
#> $ value     <dbl> 21.625, 22.708, 24.667, 21.833, 24.000, 29.875, 16.833…
```

`get_saq_observations` takes a vector of sites to import many sites at once. Beware that if a user stacks the sites, a lot of data can be returned. For example, using the two sites below returns a tibble/data frame/table with almost 10 million observations. 

```{r}
# Get almost 10 million observations
data_large_ish <- get_saq_observations(site = c("gb0036r", "gb0682a"))

# Glimpse tibble
glimpse(data_large_ish)

#> Observations: 9,911,190
#> Variables: 10
#> $ date      <dttm> 1995-09-11, 1995-09-12, 1995-09-13, 1995-09-14, 1995-…
#> $ date_end  <dttm> NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, N…
#> $ site      <chr> "gb0036r", "gb0036r", "gb0036r", "gb0036r", "gb0036r",…
#> $ site_name <chr> "Harwell", "Harwell", "Harwell", "Harwell", "Harwell",…
#> $ variable  <chr> "so2", "so2", "so2", "so2", "so2", "so2", "so2", "so2"…
#> $ process   <int> 57295, 57295, 57295, 57295, 57295, 57295, 57295, 57295…
#> $ summary   <int> 20, 20, 20, 20, 20, 20, 20, 20, 20, 20, 20, 20, 20, 20…
#> $ validity  <int> 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, …
#> $ unit      <chr> "µg/m3", "µg/m3", "µg/m3", "µg/m3", "µg/m3", "µg/m3", …
#> $ value     <dbl> 0.983, 0.792, 1.362, 0.483, 14.633, 1.171, 0.821, 15.2…
```

#### Cleaning observations

Once a data are imported, valid data for a certain averaging period/summary can be isolated with `saq_clean_observations`. `saq_clean_observations` can also "spread" data where the variable/pollutants become columns: 

```{r}
# Get only valid hourly data and reshape (spread)
data_york_spread <- data_york %>% 
  saq_clean_observations(summary = "hour", valid_only = TRUE, spread = TRUE)
```

### Processes

Information on the specific time series/processes can also be retrieved. 

```{r}
# Get processes
data_processes <- get_saq_processes()

# Glimpse tibble
glimpse(data_processes)

#> Observations: 8,257
#> Variables: 15
#> $ process           <int> 57079, 57080, 57081, 57082, 57083, 57084, 5708…
#> $ site              <chr> "gb0001a", "gb0001a", "gb0001a", "gb0002r", "g…
#> $ variable          <chr> "sa", "sa", "bs", "o3", "o3", "o3", "o3", "no2…
#> $ variable_long     <chr> "Strong acidity (air)", "Strong acidity (air)"…
#> $ period            <chr> "day", "day", "day", "day", "dymax", "hour", "…
#> $ unit              <chr> "µg SO2/m3", "µg SO2/m3", "µg/m3", "µg/m3", "µ…
#> $ date_start        <dttm> 1998-01-01 00:00:00, 1997-04-01 00:00:00, 199…
#> $ date_end          <dttm> 1998-07-06 00:00:00, 1998-03-30 00:00:00, 199…
#> $ sample            <chr> NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA…
#> $ sampling_point    <chr> NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA…
#> $ sampling_process  <chr> NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA…
#> $ observed_property <int> 3, 3, 6, 7, 7, 7, 7, 8, 8, 9, 9, 12, 12, 13, 1…
#> $ group_code        <int> 100, 101, 100, 100, 100, 100, 100, 100, 100, 1…
#> $ data_source       <chr> "airbase", "airbase", "airbase", "airbase", "a…
#> $ observation_count <dbl> 123, 351, 385, 9542, 9547, 225711, 227809, 284…
```

### Other metadata

Other helper tables are also available: 

```{r}
# Get other helper tables
# Summary integers
data_summary_integers <- get_saq_summaries() %>% 
  print(n = Inf)
  
#> # A tibble: 20 x 2
#>    averaging_period summary
#>    <chr>              <int>
#>  1 hour                   1
#>  2 day                   20
#>  3 week                  90
#>  4 var                   91
#>  5 month                 92
#>  6 fortnight             93
#>  7 3month                94
#>  8 2month                95
#>  9 2day                  96
#> 10 3day                  97
#> 11 2week                 98
#> 12 4week                 99
#> 13 3hour                100
#> 14 8hour                101
#> 15 hour8                101
#> 16 year                 102
#> 17 dymax                 21
#> 18 quarter              103
#> 19 other                 91
#> 20 n-hour               104

# Validity integers
data_validity_integers <- get_saq_validity() %>% 
  print(n = Inf)
  
#> # A tibble: 6 x 4
#>   validity valid description                                  notes        
#>      <int> <lgl> <chr>                                        <chr>        
#> 1       NA FALSE data is considered to be invalid due to the… from aqer    
#> 2       -1 FALSE invalid due to other circumstances or data … from aqer    
#> 3        0 FALSE invalid                                      smonitor nom…
#> 4        1 TRUE  <NA>                                         from aqer    
#> 5        2 TRUE  valid but below detection limit measurement… from aqer    
#> 6        3 TRUE  valid but below detection limit and number … from aqer
````

### Simple annual and monthly means of observations

Simple annual and monthly means of the daily and hourly processes have also been generated. These summaries are often useful for trend analysis or mapping. 

```{r}
# Get annual means
data_annual <- get_saq_simple_summaries(summary = "year")

# Glimpse tibble
glimpse(data_annual)

#> Observations: 623,054
#> Variables: 8
#> $ date           <dttm> 2013-01-01, 2014-01-01, 2015-01-01, 2016-01-01, …
#> $ date_end       <dttm> 2013-12-31 23:59:59, 2014-12-31 23:59:59, 2015-1…
#> $ site           <chr> "ad0942a", "ad0942a", "ad0942a", "ad0942a", "ad09…
#> $ variable       <chr> "co", "co", "co", "co", "co", "no", "no", "no", "…
#> $ summary_source <int> 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1…
#> $ summary        <int> 102, 102, 102, 102, 102, 102, 102, 102, 102, 102,…
#> $ count          <dbl> 1, 8438, 8385, 8171, 8440, 1, 8310, 8308, 8341, 8…
#> $ value          <dbl> 0.5000000, 0.3224579, 0.3582230, 0.3168768, 0.259…
```
