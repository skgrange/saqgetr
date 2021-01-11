#' Function to get air quality time series processes serviced by the 
#' \strong{saqgetr} package. 
#' 
#' @param file File of processes helper table. 
#' 
#' @author Stuart K. Grange.
#' 
#' @return Tibble. 
#' 
#' @examples 
#' 
#' \donttest{
#' 
#' # Get processes
#' data_processes <- get_saq_processes()
#' 
#' }
#' 
#' @export
get_saq_processes <- function(file = NA) {
  
  # Default file
  if (is.na(file[1])) {
    file <- "http://aq-data.ricardo-aea.com/R_data/saqgetr/helper_tables/processes_table.csv.gz"
  }
  
  # Define data types
  col_types <- readr::cols(
    process = readr::col_integer(),
    site = readr::col_character(),
    variable = readr::col_character(),
    variable_long = readr::col_character(),
    period = readr::col_character(),
    unit = readr::col_character(),
    date_start = readr::col_character(),
    date_end = readr::col_character(),
    sample = readr::col_character(),
    sampling_point = readr::col_character(),
    sampling_process = readr::col_character(),
    observed_property = readr::col_integer(),
    group_code = readr::col_integer(),
    data_source = readr::col_character(),
    observation_count = readr::col_double()
  )
  
  # Read data
  df <- read_csv_gz_remote(file, col_types = col_types) 
  
  # Parse dates
  if (nrow(df) >= 1) {
    df <- df %>% 
      mutate(date_start = lubridate::ymd_hms(date_start, tz = "UTC"),
             date_end = lubridate::ymd_hms(date_end, tz = "UTC"))
  }
  
  return(df)
  
}
