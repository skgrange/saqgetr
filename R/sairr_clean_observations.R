#' Function to clean and format observational data from \strong{saqgetr}'s 
#' \code{\link{get_saq_observations}} function. 
#' 
#' @param df Tibble/data frame from \code{\link{get_saq_observations}}. 
#' 
#' @param summary Summary to filter data to. Default is \code{"hour"}. 
#' 
#' @param valid_only Should only valid observations be kept? 
#' 
#' @param spread Should the data be "spread" where the data frame is reshaped 
#' so pollutants form variables/columns. This format is usually what is desired
#' when using \strong{openair}. 
#' 
#' @author Stuart K. Grange
#' 
#' @return Tibble. 
#' 
#' @examples 
#' 
#' # Load a site's data
#' data_hafodyrynys <- get_saq_observations(site = "gb1038a")
#' 
#' # Keep only valid and hourly data
#' data_hafodyrynys_hourly <- data_hafodyrynys %>% 
#'   saq_clean_observations(summary = "hour", valid_only = TRUE) %>% 
#'   print()
#'
#' # Spread hourly data, a different table format here
#' data_hafodyrynys_hourly_spread <- data_hafodyrynys %>% 
#'   saq_clean_observations(summary = "hour", valid_only = TRUE, spread = TRUE) %>% 
#'   print()
#' 
#' @export
saq_clean_observations <- function(df, summary = "hour", valid_only = TRUE,
                                     spread = FALSE) {
  
  # Parse inputs
  summary <- stringr::str_trim(summary)
  summary <- stringr::str_to_lower(summary)
  
  if (!summary %in% c("hour", "day")) {
    stop("`summary` must be `hour` or `day`...", call. = FALSE)
  }
  
  # # Get summary integer for filtering
  # summary_integer <- data_summaries %>% 
  #   filter(averaging_period == !!summary) %>% 
  #   pull(summary)
  
  summary_integer <- if_else(summary == "hour", 1L, NA_integer_)
  summary_integer <- if_else(summary == "day", 20L, summary_integer)
  
  # Filter to single summary
  df <- filter(df, summary == !!summary_integer)
  
  # Only keep valid observations
  if (valid_only){
    df <- filter(df, validity %in% c(1, 2, 3) | is.na(validity))
  }
  
  # Make wider
  if (spread) {
    df <- make_saq_observations_wider(df)
  }
  
  return(df)
  
}


make_saq_observations_wider <- function(df) {
  
  tryCatch({
    
    df %>% 
      select(date,
             date_end,
             site,
             variable,
             value) %>% 
      tidyr::spread(variable, value)
    
  }, error = function(e) {
    
    warning(
      "Duplicated date-site-variable combinations detected, observations have been removed...",
      call. = FALSE
    )
    
    df %>% 
      select(date,
             date_end,
             site,
             variable,
             value) %>% 
      distinct(date,
               site,
               variable,
               .keep_all = TRUE) %>% 
      tidyr::spread(variable, value)
    
  })
  
}
