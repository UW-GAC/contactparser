context("read functions")

test_that("reads an html table", {
  filename <- system.file(package = "contactparser", "testdata", "example.html")
  dat <- .read_html_table(filename)
  expect_is(dat, "tbl_df")
})

test_that("reads a csv table", {
  filename <- system.file(package = "contactparser", "testdata", "example.csv")
  expect_silent(dat <- .read_csv_table(filename))
  expect_is(dat, "tbl_df")
})

test_that("produces same output for csv and html", {
  html_filename <- system.file(package = "contactparser", "testdata", "example.html")
  html <- .read_html_table(html_filename)

  csv_filename <- system.file(package = "contactparser", "testdata", "example.csv")
  csv <- .read_csv_table(csv_filename)

  expect_equal(html, csv)
})

test_that("cleaning an example table fixes names appropriately", {
  filename <- system.file(package = "contactparser", "testdata", "example.html")
  tab <- .read_html_table(filename)
  expected_names <- c("institution_type", "study_short_name", "project",
                      "pi", "co_pi", "contact","phenotype_liaison","dataset_contact")
  expect_equal(names(tab), expected_names)

})

test_that("cleaning an example table replaces blank strings with NA", {
  html_filename <- system.file(package = "contactparser", "testdata", "example.html")
  html <- .read_html_table(html_filename)
  expect_true(is.na(html$co_pi[2]))
})
