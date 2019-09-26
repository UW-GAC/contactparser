# Rename table and replace blank strings with NA.
.clean_table <- function(df) {

  names(df) <- names(df) %>%
    stringr::str_replace_all(" ", "_") %>%
    stringr::str_replace_all("-", "_") %>%
    stringr::str_replace("\\(s\\)", "") %>%
    stringr::str_replace_all("'", "") %>%
    stringr::str_to_lower()
  df <- df %>%
    dplyr::rename(
      study_short_name = .data$this_studys_short_name,
      dataset_contact = .data$data_set_contact
    ) %>%
    # Replace empty strings with NA.
    dplyr::mutate_all(function(x) ifelse(x == "", NA, x)) %>%
    dplyr::select(-.data$title)

  df
}


# Read the table from html.
.read_html_table <- function(x) {
  html <- xml2::read_html(x)
  html_tab <- xml2::xml_find_all(html, "//body//table")[[1]]
  tab <- rvest::html_table(html_tab)
  names(tab)[2] <- "Record Type"

  .clean_table(tab) %>%
    tibble::as_tibble()
}

# Read the table from an exported csv file.
.read_csv_table <- function(filename) {
  # read_csv throws warnings when reading this file because the name of one column is missing.
  tab <- suppressMessages(suppressWarnings(readr::read_csv(filename))) %>%
    tibble::as_tibble()

  names(tab)[2] <- "Record Type"

  .clean_table(tab)
}
