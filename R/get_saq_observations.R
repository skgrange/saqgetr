#' Function to get \strong{saqgetr} air quality observations. 
#' 
#' @param site A vector of sites to import. Use \link{get_saq_sites} to find
#' what sites are available. 
#' 
#' @param variable An optional variable vector. If not used, all variables will
#' be returned. 
#' 
#' @param start Start date for returned observations. Can either be a date string in
#' \code{"yyyy-mm-dd"} format, or a year integer. 
#' 
#' @param end End date for returned observations. Can either be a date string in
#' \code{"yyyy-mm-dd"} format, or a year integer. 
#' 
#' @param valid_only Should only valid observations be kept?
#' 
#' @param tz Time zone for the observations's dates. 
#' 
#' @param verbose Should the function give messages? 
#' 
#' @author Stuart K. Grange.
#' 
#' @return Tibble. 
#' 
#' @seealso \code{\link{get_saq_sites}}, \code{\link{saq_clean_observations}}
#' 
#' @examples
#' 
#' # Load a site's data
#' data_hafodyrynys <- get_saq_observations(site = "gb1038a")
#' 
#' # Print tibble
#' data_hafodyrynys
#' 
#' # Get mulitple sites nox and ozone data for between a date range
#' data_many <- get_saq_observations(
#'   site = c("gb1014a", "gb1044a", "gb1060a"),
#'   variable = c("nox", "no2", "o3"),
#'   start = 2010,
#'   end = 2019
#' )
#' 
#' # Print tibble
#' data_many
#' 
#' # Sites and site names
#' data_many %>% 
#'   dplyr::distinct(site)
#' 
#' @export
get_saq_observations <- function(site, variable = NA, start = NA, end = NA, 
                                   valid_only = FALSE, tz = "UTC", 
                                   verbose = FALSE) {
  
  # Parse arguments
  site <- stringr::str_trim(site)
  variable <- stringr::str_trim(variable)
  
  # Dates
  if (is.na(start)) start <- "1960-01-01"
  if (is.na(end)) end <- lubridate::ceiling_date(lubridate::now(), unit = "year")
  
  # Parse
  start <- parse_date_arguments(start, "start", tz = tz)
  end <- parse_date_arguments(end, "end", tz = tz)
  
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
    ~get_saq_observations_worker(
      file = .x,
      site = .y,
      variable = variable,
      start = start,
      end = end,
      valid_only = valid_only,
      tz = tz,
      verbose = verbose
    )
  )
  
  return(df)
  
}


get_saq_observations_worker <- function(file, site, variable, start, end,
                                        valid_only, tz, verbose) {
  
  # For messaging
  if (verbose) {
    message(date_message(), "Importing observations for `", site, "`...")
  }
  
  # Read data
  df <- read_saq_observations_safely(file, tz = tz)
  
  # Filter to dates
  df <- filter(df, date >= start, date <= end)
  
  # Filter to variables
  if (!is.na(variable[1])) {
    df <- filter(df, variable %in% !!variable)
  }
  
  # Keep only valid observations
  if (valid_only) {
    df <- filter(df, validity %in% c(1, 2, 3) | is.na(validity))
  }
  
  return(df)
  
}


# Reading function
read_saq_observations <- function(file, tz = tz) {
  
  # Data types
  col_types <- readr::cols(
    date = readr::col_character(),
    date_end = readr::col_character(),
    site = readr::col_character(),
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
read_saq_observations_safely <- purrr::possibly(
  read_saq_observations, 
  otherwise = tibble::tibble()
)


# From threadr
parse_date_arguments <- function(date, type, tz = "UTC") 
{
  if (lubridate::is.Date(date) || lubridate::is.POSIXt(date)) 
    date <- as.character(date)
  if (is.na(date)) {
    date <- lubridate::ymd(Sys.Date(), tz = tz)
  }
  else {
    date_system <- lubridate::ymd(Sys.Date(), tz = tz)
    if (type == "start") {
      if (stringr::str_count(date) == 4) 
        date <- stringr::str_c(date, "-01-01")
      date <- ifelse(is.na(date), as.character(lubridate::floor_date(date_system, 
                                                                     "year")), date)
    }
    if (type == "end") {
      if (stringr::str_count(date) == 4) 
        date <- stringr::str_c(date, "-12-31")
      date <- ifelse(is.na(date), as.character(lubridate::ceiling_date(date_system, 
                                                                       "year")), date)
    }
    date <- lubridate::parse_date_time(date, c("ymd", "dmy"), 
                                       tz = tz)
  }
  return(date)
}
