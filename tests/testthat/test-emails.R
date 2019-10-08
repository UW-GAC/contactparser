context("tests of the emails functions")

test_that("get_emails checks for email column name", {
  dat <- tibble::tibble(email = internet_faker$email())
  test <- get_emails(dat)
  dat2 <- tibble::tibble(emails = internet_faker$email())
  expect_error(get_emails(dat2), "column 'email'")
})

test_that("get_emails works with no records", {
  dat <- tibble::tibble(email = character())
  out <- get_emails(dat)
  expect_equal(out, "")
})

test_that("get_emails works with one records", {
  email <- internet_faker$email()
  dat <- tibble::tibble(email = email)
  out <- get_emails(dat)
  expect_equal(out, email)
})

test_that("get_emails works with two records", {
  dat <- tibble::tibble(email = c("a@aa.com", "b@bb.com"))
  out <- get_emails(dat)
  expect_equal(out, "a@aa.com, b@bb.com")
})

test_that("get_emails sort argument", {
  dat <- tibble::tibble(email = c("b@bb.com", "a@aa.com"))
  expect_equal(get_emails(dat), "a@aa.com, b@bb.com")
  expect_equal(get_emails(dat, sorted = FALSE), "b@bb.com, a@aa.com")
})

test_that("get_emails works with many emails", {
  n <- 10
  emails <- sapply(1:n, function(x) internet_faker$email())
  dat <- tibble::tibble(email = emails)
  out <- get_emails(dat)
  for (email in emails) {
    expect_true(grepl(email, out, fixed = TRUE), info = email)
  }
  expect_equal(stringr::str_count(out, ", "), n - 1)
})

test_that("get_emails removes duplicates", {
  email <- internet_faker$email()
  dat <- tibble::tibble(email = c(email, email))
  expect_equal(get_emails(dat), email)
})

test_that("get_emails works with test data", {
  parsed <- parse_contact_table(system.file(package = "contactparser", "testdata", "example.html"))
  out <- get_emails(parsed)
  expected_string <- "fnitzsche@gmail.com, ilona.cartwright@yahoo.com, karren.schmeler@group.biz, koelpin.kathaleen@gmail.com, nia.vonrueden@yahoo.com, sdenesik@hotmail.com"
  expect_equal(get_emails(parsed), expected_string)
})