read_csv_gz_remote <- function(url, col_types = NULL, verbose = TRUE) {
  
  # Get remote content with httr
  response <- httr::GET(url)
  
  # Check for errors, could also use httr::status_code
  # Only raise a message here too
  if (httr::http_error(response)) {
    if (verbose) {
      message("Remote resource is not available or location has changed...")
    }
    return(tibble())
  }
  
  # Create the connection
  con <- response %>% 
    httr::content() %>% 
    rawConnection() %>% 
    gzcon() 
  
  # Read data from the connection
  df <- readr::read_csv(con, col_types = col_types, progress = FALSE)
  
  # Ensure the connection is always closed
  close(con)

  return(df)
  
}
