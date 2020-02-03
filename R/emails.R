.construct_email_list <- function(emails, delimiter, sorted = TRUE) {

  if (sorted) {
    emails <- sort(emails)
  }

  paste(unique(emails), collapse = delimiter)
}

.check_email_column <- function(tbl) {
  if (!("email" %in% names(tbl))) {
    stop("tbl must have a column 'email'")
  }
}


#' Obtain emails in the table
#'
#' These functions collapse the emails in the provided \code{tbl} to
#' a comma-separated string that can be cut and paste into an email
#' client's "To:" field.
#'
#' @param tbl A tibble with one required column "email"
#' @param sorted Should the emails be sorted before returning?
#' @param delimiter Character(s) to use as a delimiter to when concatenating emails
#'
#' @seealso parse_contact_table
#'
#' @name emails
#'
#' @examples
#' html_file <- system.file(package = "contactparser", "testdata", "example.html")
#' parsed <- parse_contact_table(html_file)
#'
#' get_emails(parsed)
#'
#' print_emails(parsed)
#' print_emails(parsed, delimiter = "\n")
#'
NULL

#' @describeIn emails return an email list
#'
#' @export
#'
get_emails <- function(tbl, sorted = TRUE, delimiter = ", ") {
  .check_email_column(tbl)
  return(.construct_email_list(tbl$email, delimiter, sorted = sorted))
}

#' @describeIn emails print the emails to the console
#'
#' @export
#'
print_emails <- function(tbl, sorted = TRUE, delimiter = ", ") {
  .check_email_column(tbl)
  message(.construct_email_list(tbl$email, delimiter, sorted = sorted))
  return(invisible(NULL))
}
