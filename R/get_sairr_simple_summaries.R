#' Function to get simple summaries of air quality observations. 
#' 
#' @param file File of simple summaries table. 
#' 
#' @param summary Summary period to import. Can either be \code{"year"} or
#'  \code{"month"}. 
#' 
#' @param tz Time zone for the observations's dates. 
#' 
#' @param progress Should the function give a progress bar for when reading the
#' data file? 
#' 
#' @author Stuart K. Grange.
#' 
#' @return Tibble. 
#' 
#' @examples 
#' 
#' # Import annual means
#' data_annual <- get_sairr_simple_summaries(summary = "year")
#' 
#' @export
get_sairr_simple_summaries <- function(file = NA, summary = "year", tz = "UTC", 
                                       progress = FALSE) {
  
  
  # Parse and check arguments
  summary <- stringr::str_trim(summary)
  summary <- stringr::str_to_lower(summary)
  stopifnot(summary %in% c("year", "month"))
  
  if (is.na(file[1]) && summary == "year") {
    file <- "https://skgrange.github.io/data.service/data/sairr/observations_summaries/annual_mean_summaries.csv.gz"
  } else if (is.na(file[1]) && summary == "month") {
    file <- "https://skgrange.github.io/data.service/data/sairr/observations_summaries/monthly_mean_summaries.csv.gz"
  }
  
  # Set data types
  col_types <- readr::cols(
    date = readr::col_character(),
    date_end = readr::col_character(),
    site = readr::col_character(),
    variable = readr::col_character(),
    summary_source = readr::col_integer(),
    summary = readr::col_integer(),
    count = readr::col_double(),
    value = readr::col_double()
  )
  
  # Read data
  df <- readr::read_csv(
    file,
    col_types = col_types,
    progress = progress
  ) %>% 
    mutate(date = lubridate::ymd_hms(date, tz = tz),
           date_end = lubridate::ymd_hms(date_end, tz = tz))
  
  return(df)
  
}
