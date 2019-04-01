#' Function to get simple summaries of air quality observations. 
#' 
#' @param file File of simple summaries table. 
#' 
#' @param summary Summary period to import. Can either be \code{"annual_mean"} or
#'  \code{"monthly_mean"}. 
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
#' data_annual <- get_saq_simple_summaries(summary = "annual_mean")
#' 
#' @export
get_saq_simple_summaries <- function(file = NA, summary = "annual_mean", tz = "UTC", 
                                     progress = FALSE) {
  
  
  # Parse and check arguments
  summary <- stringr::str_trim(summary)
  summary <- stringr::str_to_lower(summary)
  summary <- stringr::str_remove(summary, "s$")
  stopifnot(summary %in% c("annual_mean", "monthly_mean"))
  
  if (is.na(file[1]) && summary == "annual_mean") {
    file <- "https://skgrange.github.io/data.service/data/saqgetr/observations_summaries/annual_mean_summaries.csv.gz"
  } else if (is.na(file[1]) && summary == "monthly_mean") {
    file <- "https://skgrange.github.io/data.service/data/saqgetr/observations_summaries/monthly_mean_summaries.csv.gz"
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
