#' Read and parse the TOPMed website contact table
#'
#' Read the table from either a csv or html file and reformat it to a tall format, with
#' one row per email.
#'
#' @param x The path to a csv or html file containing the contact table.
#'
#' @return A formatted version of the contact table with columns:
#' \itemize{
#'   \item \code{instutition_type}: String indicating if this record is for a parent study, project, or center
#'   \item \code{study_short_name}: Study short name
#'   \item \code{project}: Associated TOPMed project
#'   \item \code{contact_type}: pi, co_pi, contact, dataset_contact, or phenotype_liaison
#'   \item \code{email}: email address for this contact
#' }
#'
#' If there are multiple contact types for the same study/project, they will appear in separate records.
#' Similarly, if the same email has multiple contact_types for the same study/project or is associated
#' with different studies or projects, that email will appear multiple times.
#'
#' @export
#'
parse_contact_table <- function(x) {

  if (stringr::str_ends(x, "\\.html")) {
    tab <- .read_html_table(x)
  } else if (stringr::str_ends(x, "\\.csv")) {
    tab <- .read_csv_table(x)
  }

  .reformat_contact_table(tab)

}
