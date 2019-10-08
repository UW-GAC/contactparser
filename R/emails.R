.construct_email_list <- function(emails, sorted = TRUE) {
  
  if (sorted) {
    emails <- sort(emails)
  }
  
  paste(unique(emails), collapse = ", ")
}

.check_email_column <- function(tbl) {
  if (!("email" %in% names(tbl))) {
    stop("tbl must have a column 'email'")
  }
}
#' Obtain emails in the table
#' 
#' @param tbl A tibble with one required column "email"
#' @param sorted Should the emails be sorted before returning?
#' 
#' @seealso parse_contact_table
#' 
#' @export
#' 
#' @examples{
#' 
#' html_file <- system.file(package = "contactparser", "testdata", "example.html")
#' parsed <- parse_contact_table(html_file)
#' get_emails(parsed)
#' 
#' }
get_emails <- function(tbl, sorted = TRUE) {
  .check_email_column(tbl)
  return(.construct_email_list(tbl$email, sorted = sorted))
}

print_emails <- function(tbl, sorted = TRUE) {
  .check_email_column(tbl)
  message(.construct_email_list(tbl$email, sorted = sorted))
  return(invisible(NULL))
}