#' Squash the global variable notes when building a package. 
#' 
#' @name zzz
#' 
if (getRversion() >= "2.15.1") {
  
  # What variables are causing issues?
  variables <- c(
    "date_end", "date_start", "site", "site_name", "variable", "value",
    "validity", "year"
  )
  
  # Squash the notes
  utils::globalVariables(variables)
  
}
