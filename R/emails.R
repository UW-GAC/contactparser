.construct_email_list <- function(emails, sorted = TRUE) {
  
  if (sorted) {
    emails <- sort(emails)
  }
  
  paste(unique(emails), collapse = ", ")
}

#' Obtain emails in the table
#' 
#' @param tbl A tibble with one required column "email"
#' @param sorted Should the emails be sorted before returning?
#' 
#' @seealso parse_contact_table
#' 
#' @examples{
#' 
#' html_file <- system.file(package = "contactparser", "testdata", "example.html")
#' parsed <- parse_contact_table(html_file)
#' get_emails(parsed)
#' 
#' }
get_emails <- function(tbl, sorted = TRUE) {
  if (!("email" %in% names(tbl))) {
    stop("tbl must have a column 'email'")
  }
  return(.construct_email_list(tbl$email, sorted = sorted))
}
