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
#' @param tz Time zone for the observations' dates. 
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
#' data_hafodyrynys <- get_saq_observations(
#'   site = "gb1038a", 
#'   start = 2018, 
#'   end = 2018
#' )
#' 
#' # Print tibble
#' data_hafodyrynys
#' 
#' \donttest{
#' 
#' # Get multiple sites nox and ozone data for between a date range
#' data_many <- get_saq_observations(
#'   site = c("gb1014a", "gb1044a", "gb1060a"),
#'   variable = c("nox", "no2", "o3"),
#'   start = 2018,
#'   end = 2019,
#'   verbose = TRUE
#' )
#' 
#' # Print tibble
#' data_many
#' 
#' # Sites and site names
#' data_many %>% 
#'   dplyr::distinct(site)
#'   
#' }
#' 
#' @export
get_saq_observations <- function(site, variable = NA, start = NA, end = NA, 
                                 valid_only = FALSE, tz = "UTC", 
                                 verbose = FALSE) {
  
  # Parse arguments
  site <- stringr::str_trim(site)
  variable <- stringr::str_trim(variable)
  
  # Dates
  if (is.na(start)) start <- lubridate::year(lubridate::now())
  if (is.na(end)) end <- lubridate::ceiling_date(lubridate::now(), unit = "year")
  
  # Parse
  start <- parse_date_arguments(start, "start", tz = tz)
  end <- parse_date_arguments(end, "end", tz = tz)
  
  # The directory
  remote_path <- "http://aq-data.ricardo-aea.com/R_data/saqgetr/observations"
  
  # Produce file names
  file_remote <- tidyr::crossing(
    site = site,
    year = lubridate::year(start):lubridate::year(end)
  ) %>% 
    arrange(site,
            year) %>% 
    mutate(
      file_remote = stringr::str_c(
        remote_path,
        "/",
        year, 
        "/", 
        "air_quality_data_site_",
        site, 
        "_",
        year,
        ".csv.gz"
      )
    ) %>% 
    pull(file_remote)
  
  # Load files
  df <- purrr::map_dfr(
    file_remote, 
    ~get_saq_observations_worker(
      file = .x,
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


get_saq_observations_worker <- function(file, variable, start, end,
                                        valid_only, tz, verbose) {
  
  # Message file to user
  if (verbose) message(date_message(), "Loading `", fs::path_file(file), "`...")

  # Read data
  df <- read_saq_observations(file, tz = tz, verbose = verbose)
  
  # Return here
  if (nrow(df) == 0) return(tibble())
  
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
read_saq_observations <- function(file, tz = tz, verbose) {
  
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
  
  # Create gz connection
  con <- file %>% 
    url() %>% 
    gzcon()
  
  df <- tryCatch({
    
    # Read and parse dates, quiet supresses time zone conversion messages and
    # warning supression is for when url does not exist
    suppressWarnings(
      readr::read_csv(con, col_types = col_types, progress = FALSE) %>%
        mutate(date = lubridate::ymd_hms(date, tz = tz, quiet = TRUE),
               date_end = lubridate::ymd_hms(date_end, tz = tz, quiet = TRUE))
    )
    
  }, error = function(e) {
    
    # Close the connection on error
    close.connection(con)
    tibble()
    
  })
  
  return(df)
  
}


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
