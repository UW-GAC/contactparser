.reformat_contact_table <- function(df) {

  expected_names <- c("institution_type", "study_short_name", "project",
                      "pi", "co_pi", "contact", "phenotype_liaison", "dataset_contact")
  stopifnot(all.equal(names(df), expected_names))

  tmp <- df %>%
    tidyr::gather(
      "contact_type",
      "email_list",
      pi, co_pi, contact, phenotype_liaison, dataset_contact,
      na.rm = TRUE
    )

  # Get the maximum number of emails in each field and use it to determine how many columns
  # to split the email_list field into.
  max_emails <- max(stringr::str_count(tmp$email_list, pattern = ";")) + 1

  email_cols <- sprintf("email%d", 1:max_emails)
  long_tab <- tmp %>%
    tidyr::separate("email_list", email_cols, sep = ";", , fill = "right") %>%
    tidyr::gather("foo", "email", email_cols, na.rm = TRUE) %>%
    dplyr::select(-foo) %>%
    dplyr::mutate_all(stringr::str_trim)

  long_tab
}
