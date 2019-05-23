#' Function to import validiy integers for used in the \strong{saqgetr} package.  
#' 
#' @param file File of validiy helper table. 
#' 
#' @author Stuart K. Grange.
#' 
#' @return Tibble. 
#' 
#' @examples 
#' 
#' # Get validity integers
#' data_validity <- get_saq_validity()
#' 
#' @export
get_saq_validity <- function(file = NA) {
  
  # Default file
  if (is.na(file[1])) {
    # file <- "/media/stuart/ELEMENTS_II/drop/sairr/helper_tables/validity_integers_table.csv.gz"
    # file <- "https://skgrange.github.io/data.service/data/saqgetr/helper_tables/validity_integers_table.csv.gz"
    file <- "http://aq-data.ricardo-aea.com/R_data/saqgetr/helper_tables/validity_integers_table.csv.gz"
  }
  
  # Load file
  df <- readr::read_csv(file, col_types = "ilcc", progress = FALSE)
  
  return(df)
  
}


#' Function to import summary integers for used in the \strong{saqgetr} package.  
#' 
#' @param file File of summary helper table. 
#' 
#' @author Stuart K. Grange.
#' 
#' @return Tibble. 
#' 
#' @examples 
#' 
#' # Get summary integers
#' data_validity <- get_saq_summaries()
#' 
#' @export
get_saq_summaries <- function(file = NA) {
  
  # Default file
  if (is.na(file[1])) {
    # file <- "/media/stuart/ELEMENTS_II/drop/sairr/helper_tables/summary_integers_table.csv.gz"
    # file <- "https://skgrange.github.io/data.service/data/saqgetr/helper_tables/summary_integers_table.csv.gz"
    file <- "http://aq-data.ricardo-aea.com/R_data/saqgetr/helper_tables/summary_integers_table.csv.gz"
  }
  
  # Load file
  df <- readr::read_csv(file, col_types = "ci", progress = FALSE)
  
  return(df)
  
}
