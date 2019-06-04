#' Function to import information for monitoring sites/stations/facilities 
#' serviced by the \strong{saqgetr} package.  
#' 
#' @param file File of sites helper table. 
#' 
#' @author Stuart K. Grange.
#' 
#' @return Tibble. 
#' 
#' @examples 
#' 
#' # Load sites table
#' data_sites <- get_saq_sites()
#' 
#' @export
get_saq_sites <- function(file = NA) {
  
  # Default file
  if (is.na(file[1])) {
    file <- "http://aq-data.ricardo-aea.com/R_data/saqgetr/helper_tables/sites_table.csv.gz"
  }
  
  # Define data types
  col_types <- readr::cols(
    site = readr::col_character(),
    site_name = readr::col_character(),
    latitude = readr::col_double(),
    longitude = readr::col_double(),
    elevation = readr::col_double(),
    country = readr::col_character(),
    country_iso_code = readr::col_character(),
    site_type = readr::col_character(),
    site_area = readr::col_character(),
    date_start = readr::col_character(),
    date_end = readr::col_character(),
    network = readr::col_character(),
    eu_code = readr::col_character(),
    eoi_code = readr::col_character(),
    data_source = readr::col_character()
  )
  
  # Read data and parse dates
  df <- readr::read_csv(file, col_types = col_types, progress = FALSE) %>% 
    mutate(date_start = lubridate::ymd_hms(date_start, tz = "UTC"),
           date_end = lubridate::ymd_hms(date_end, tz = "UTC"))
  
  return(df)
  
}
