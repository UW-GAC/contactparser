.reformat_contact_table <- function(df) {

  expected_names <- c("institution_type", "study_short_name", "project",
                      "pi", "co_pi", "contact", "phenotype_liaison", "dataset_contact")
  if (!setequal(names(df), expected_names)) {
    msg <- sprintf("df names required to be %s", paste(expected_names, collapse = ", "))
    stop(msg)
  }

  # Check for duplicates
  if (any(duplicated(df[, c("study_short_name", "project")]))) {
    stop("duplicated study_short_name/project detected!")

  }
  tmp <- df %>%
    tidyr::gather(
      "contact_type",
      "email_list",
      .data$pi, .data$co_pi, .data$contact, .data$phenotype_liaison, .data$dataset_contact,
      na.rm = TRUE,
      factor_key = TRUE
    )

  # Get the maximum number of emails in each field and use it to determine how many columns
  # to split the email_list field into.
  max_emails <- max(stringr::str_count(tmp$email_list, pattern = ";")) + 1

  email_cols <- sprintf("email%d", 1:max_emails)
  long_tab <- tmp %>%
    tidyr::separate("email_list", email_cols, sep = ";", , fill = "right") %>%
    tidyr::gather("foo", "email", email_cols, na.rm = TRUE) %>%
    dplyr::select(-.data$foo) %>%
    dplyr::arrange(.data$study_short_name, .data$project, .data$contact_type) %>%
    dplyr::mutate_all(stringr::str_trim) %>%
    # Put in expected order.
    dplyr::select(.data$institution_type, .data$study_short_name, .data$project,
                  .data$contact_type, .data$email)

  long_tab
}
