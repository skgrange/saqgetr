# **sairr**

[![Build Status](https://travis-ci.org/skgrange/sairr.svg?branch=master)](https://travis-ci.org/skgrange/sairr)

**sairr** is an R package to import air quality monitoring data in a fast and easy way. Currently, only European data are available, but the package is generic and therefore data from other areas may be included in the future. 

## Installation

To install the development version, install [**devtools**](https://github.com/r-lib/devtools) or [**remotes**](https://github.com/r-lib/remotes) and then use this: 

```
# Install development version sairr
remotes::install_github("skgrange/sairrr")
```

**sairr** should make it onto CRAN in the near future. 

## Framework

**sairr** acts as an interface to pre-prepared data files located on a web server. For each monitoring site serviced, there is a single file containing all observations. There are a number of metadata files too which enable users to further understand the location and type of observations are available. The data files are compressed text files which allows for simple and fast importing and if other interfaces wish to be developed, it will be easy. 

## Usage

### Sites

To import data with **sairr**, functions with the `get_sairr_*` prefix are used. A monitoring site must be supplied to get observations. To find what sites are available use `get_sairr_sites`: 

```
# Load packages
library(dplyr)
library(sairr)

# Import site information
data_sites <- get_sairr_sites()

# Print tibble
head(data_sites)
#> # A tibble: 6 x 16
#>   site  site_name latitude longitude elevation country country_iso_code
#>   <chr> <chr>        <dbl>     <dbl>     <dbl> <chr>   <chr>           
#> 1 gb00… BONNYRIG…     55.9    -3.10        111 united… GB              
#> 2 gb00… Eskdalem…     55.3    -3.21        255 united… GB              
#> 3 gb00… Stoke Fe…     52.6     0.506         3 united… GB              
#> 4 gb00… Lough Na…     54.4    -7.90        130 united… GB              
#> 5 gb00… Yarner W…     50.6    -3.72        119 united… GB              
#> 6 gb00… High Muf…     54.3    -0.809       267 united… GB              
#> # … with 9 more variables: site_type <chr>, site_area <chr>,
#> #   date_start <dttm>, date_end <dttm>, network <chr>, eu_code <chr>,
#> #   eoi_code <chr>, observation_count <dbl>, data_source <chr>

# Print sites
head(data_sites$site)
#> [1] "gb0001a" "gb0002r" "gb0004r" "gb0006r" "gb0013r" "gb0014r"
```

### Observations

Sites are represented by a code which is prefixed with the country's ISO code, for example, a site in York, England, United Kingdom is identified as `gb0919a` (the ISO code for the United Kingdom is non-standard and GB is for Great Britain). To get observations this site, use `get_sairr_observations`:

```{r}
# Get air quality monitoring data for a York site
data_york <- get_sairr_observations(site = "gb0919a")

# Print tibble
head(data_york)
#> # A tibble: 6 x 10
#>   date                date_end            site  site_name variable process
#>   <dttm>              <dttm>              <chr> <chr>     <chr>      <int>
#> 1 2008-01-01 00:00:00 NA                  gb09… York Fis… pm10       62392
#> 2 2008-01-02 00:00:00 NA                  gb09… York Fis… pm10       62392
#> 3 2008-01-03 00:00:00 NA                  gb09… York Fis… pm10       62392
#> 4 2008-01-04 00:00:00 NA                  gb09… York Fis… pm10       62392
#> 5 2008-01-05 00:00:00 NA                  gb09… York Fis… pm10       62392
#> 6 2008-01-06 00:00:00 NA                  gb09… York Fis… pm10       62392
#> # … with 4 more variables: summary <int>, validity <int>, unit <chr>,
#> #   value <dbl>
```

`get_sairr_observations` takes a vector of sites to import many sites at once. Beware that if a user stacks the sites, a lot of data can be returned. For example, using the two sites below returns a tibble/data frame/table with almost 10 million observations. 

```{r}
# Get almost 10 million observations
data_large_ish <- get_sairr_observations(site = c("gb0036r", "gb0682a"))
```

#### Cleaning observations

```{r}
sairr_clean_observations()
```

### Processes

```{r}
# Get processes
data_processes <- get_sairr_processes()

# Print tibble
head(data_processes)
#> # A tibble: 6 x 15
#>   process site  variable variable_long period unit  date_start         
#>     <int> <chr> <chr>    <chr>         <chr>  <chr> <dttm>             
#> 1   57079 gb00… sa       Strong acidi… day    µg S… 1998-01-01 00:00:00
#> 2   57080 gb00… sa       Strong acidi… day    µg S… 1997-04-01 00:00:00
#> 3   57081 gb00… bs       Black smoke … day    µg/m3 1997-04-01 00:00:00
#> 4   57082 gb00… o3       Ozone (air)   day    µg/m3 1986-04-23 00:00:00
#> 5   57083 gb00… o3       Ozone (air)   dymax  µg/m3 1986-04-23 00:00:00
#> 6   57084 gb00… o3       Ozone (air)   hour   µg/m3 1986-04-23 07:00:00
#> # … with 8 more variables: date_end <dttm>, sample <chr>,
#> #   sampling_point <chr>, sampling_process <chr>, observed_property <int>,
#> #   group_code <int>, data_source <chr>, observation_count <dbl>
```

### Other metadata

```{r}
# Get helper tables
data_summary_integers <- get_sairr_summaries()
data_validity_integers <- get_sairr_validity()
````

### Simple annual and monthly means of observations

```{r}
# Get annual means
data_annual <- get_sairr_simple_summaries(summary = "year")
```
