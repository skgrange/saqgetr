#' Function to import air quality observations. 
#' 
#' @param site A vector or sites to import. 
#' 
#' @param tz Time zone for the observations's dates. 
#' 
#' @param verbose Should the function give messages? 
#' 
#' @author Stuart K. Grange.
#' 
#' @return Tibble. 
#' 
#' @examples
#' 
#' # Load a site's data
#' data_hafodyrynys <- sairr_observations(site = "gb1038a")
#' 
#' @export
sairr_observations <- function(site, tz = "UTC", verbose = FALSE) {
  
  # Build file names
  file_remote <- stringr::str_c("air_quality_data_site_", site, ".csv.gz")
  
  # # Add location
  # file_remote <- stringr::str_c(
  #   "/media/stuart/ELEMENTS_II/drop/europeimportr_new/observations/", 
  #   file_remote
  # )
  
  file_remote <- stringr::str_c(
    "https://skgrange.github.io/data.service/data/sairr/observations/", 
    file_remote
  )
  
  # Give names for purrr iteration
  names(file_remote) <- site
  
  # Load files
  df <- purrr::imap_dfr(
    file_remote, 
    ~sairr_observations_worker(
      file = .x,
      site = .y,
      tz = tz,
      verbose = verbose
    )
  )
  
  return(df)
  
}


sairr_observations_worker <- function(file, site, tz, verbose) {
  
  # For messaging
  if (verbose) {
    message(date_message(), "Importing observations for `", site, "`...")
  }
  
  # Read data
  df <- read_sairr_observations_safely(file, tz = tz)
  
  return(df)
  
}

# Reading function
read_sairr_observations <- function(file, tz = tz) {
  
  # Data types
  col_types <- readr::cols(
    date = readr::col_character(),
    date_end = readr::col_character(),
    site = readr::col_character(),
    site_name = readr::col_character(),
    variable = readr::col_character(),
    process = readr::col_integer(),
    summary = readr::col_integer(),
    validity = readr::col_integer(),
    unit = readr::col_character(),
    value = readr::col_double()
  )
  
  # Read and parse dates
  df <- readr::read_csv(file, col_types = col_types, progress = FALSE) %>%
    mutate(date = lubridate::ymd_hms(date, tz = tz),
           date_end = lubridate::ymd_hms(date_end, tz = tz))
  
  return(df)
  
}


# Make reader return empty tibble when an error occurs
read_sairr_observations_safely <- purrr::possibly(
  read_sairr_observations, 
  otherwise = tibble::tibble()
)
