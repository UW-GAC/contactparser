context("reformat functions")

test_that("reformats a table to expected rows", {
  wide <- tibble::tibble(
    institution_type = c("Parent study"),
    study_short_name = c("ABC"),
    project = c("DEF"),
    pi = internet_faker$email(),
    co_pi = internet_faker$email(),
    contact = internet_faker$email(),
    phenotype_liaison = internet_faker$email(),
    dataset_contact = internet_faker$email()
  )

  long <- .reformat_contact_table(wide)
  expect_is(long, "tbl_df")
  expected_names <- c("institution_type", "study_short_name", "project", "contact_type", "email")
  expect_equal(names(long), expected_names)
  expect_equal(nrow(long), 5)
  expect_equal(long$institution_type, rep("Parent study", 5))
  expect_equal(long$study_short_name, rep("ABC", 5))
  expect_equal(long$project, rep("DEF", 5))
  expect_equal(long$contact_type, c("pi", "co_pi", "contact", "phenotype_liaison", "dataset_contact"))
  expect_equal(long$email,
               c(wide$pi, wide$co_pi, wide$contact, wide$phenotype_liaison, wide$dataset_contact))
})

test_that("reformats a table with two rows to expected format", {
  n <- 2
  wide <- tibble::tibble(
    institution_type = c("Parent study"),
    study_short_name = c("ABC", "DEF"),
    project = c("GHI", "JKL"),
    pi = sapply(1:n, function(x) internet_faker$email()),
    co_pi = sapply(1:n, function(x) internet_faker$email()),
    contact = sapply(1:n, function(x) internet_faker$email()),
    phenotype_liaison = sapply(1:n, function(x) internet_faker$email()),
    dataset_contact = sapply(1:n, function(x) internet_faker$email())
  )

  long <- .reformat_contact_table(wide)
  expect_is(long, "tbl_df")
  expected_names <- c("institution_type", "study_short_name", "project", "contact_type", "email")
  expect_equal(names(long), expected_names)
  expect_equal(nrow(long), 10)
  expect_equal(long$institution_type, rep("Parent study", 10))
  expect_equal(long$study_short_name, rep(wide$study_short_name, each = 5))
  expect_equal(long$project, rep(wide$project, each = 5))
  expect_equal(long$contact_type,
               rep(c("pi", "co_pi", "contact", "phenotype_liaison", "dataset_contact"), times = 2))
  expected_emails <- c(
    wide$pi[1], wide$co_pi[1], wide$contact[1], wide$phenotype_liaison[1], wide$dataset_contact[1],
    wide$pi[2], wide$co_pi[2], wide$contact[2], wide$phenotype_liaison[2], wide$dataset_contact[2]
  )
  expect_equal(long$email, expected_emails)
})

test_that("reformatting fails with duplicated study/project combination", {
  n <- 2
  wide <- tibble::tibble(
    institution_type = c("Parent study"),
    study_short_name = c("ABC", "ABC"),
    project = c("DEF", "DEF"),
    pi = sapply(1:n, function(x) internet_faker$email()),
    co_pi = sapply(1:n, function(x) internet_faker$email()),
    contact = sapply(1:n, function(x) internet_faker$email()),
    phenotype_liaison = sapply(1:n, function(x) internet_faker$email()),
    dataset_contact = sapply(1:n, function(x) internet_faker$email())
  )
  expect_error(.reformat_contact_table(wide), "duplicated study_short_name/project detected")
})

test_that("works with duplicated parent study with different projects", {
  n <- 2
  wide <- tibble::tibble(
    institution_type = c("Parent study"),
    study_short_name = c("ABC", "ABC"),
    project = c("DEF", "GHI"),
    pi = sapply(1:n, function(x) internet_faker$email()),
    co_pi = sapply(1:n, function(x) internet_faker$email()),
    contact = sapply(1:n, function(x) internet_faker$email()),
    phenotype_liaison = sapply(1:n, function(x) internet_faker$email()),
    dataset_contact = sapply(1:n, function(x) internet_faker$email())
  )

  long <- .reformat_contact_table(wide)
  expected_names <- c("institution_type", "study_short_name", "project", "contact_type", "email")
  expect_equal(names(long), expected_names)
  expect_equal(nrow(long), 10)
  expect_equal(long$institution_type, rep("Parent study", 10))
  expect_equal(long$study_short_name, rep(wide$study_short_name, each = 5))
  expect_equal(long$project, rep(wide$project, each = 5))
  expect_equal(long$contact_type,
               rep(c("pi", "co_pi", "contact", "phenotype_liaison", "dataset_contact"), times = 2))
  expected_emails <- c(
    wide$pi[1], wide$co_pi[1], wide$contact[1], wide$phenotype_liaison[1], wide$dataset_contact[1],
    wide$pi[2], wide$co_pi[2], wide$contact[2], wide$phenotype_liaison[2], wide$dataset_contact[2]
  )
  expect_equal(long$email, expected_emails)
})

test_that("works with duplicated project with different parent studies", {
  n <- 2
  wide <- tibble::tibble(
    institution_type = c("Parent study"),
    study_short_name = c("ABC", "DEF"),
    project = c("GHI", "GHI"),
    pi = sapply(1:n, function(x) internet_faker$email()),
    co_pi = sapply(1:n, function(x) internet_faker$email()),
    contact = sapply(1:n, function(x) internet_faker$email()),
    phenotype_liaison = sapply(1:n, function(x) internet_faker$email()),
    dataset_contact = sapply(1:n, function(x) internet_faker$email())
  )

  long <- .reformat_contact_table(wide)
  expected_names <- c("institution_type", "study_short_name", "project", "contact_type", "email")
  expect_equal(names(long), expected_names)
  expect_equal(nrow(long), 10)
  expect_equal(long$institution_type, rep("Parent study", 10))
  expect_equal(long$study_short_name, rep(wide$study_short_name, each = 5))
  expect_equal(long$project, rep(wide$project, each = 5))
  expect_equal(long$contact_type,
               rep(c("pi", "co_pi", "contact", "phenotype_liaison", "dataset_contact"), times = 2))
  expected_emails <- c(
    wide$pi[1], wide$co_pi[1], wide$contact[1], wide$phenotype_liaison[1], wide$dataset_contact[1],
    wide$pi[2], wide$co_pi[2], wide$contact[2], wide$phenotype_liaison[2], wide$dataset_contact[2]
  )
  expect_equal(long$email, expected_emails)
})

test_that("reformatting fails with missing names", {
  required_names <- c("institution_type", "study_short_name", "project",
                      "pi", "co_pi", "contact", "phenotype_liaison", "dataset_contact")

  wide <- tibble::tibble(
    institution_type = c("Parent study"),
    study_short_name = c("ABC"),
    project = c("DEF"),
    pi = internet_faker$email(),
    co_pi = internet_faker$email(),
    contact = internet_faker$email(),
    phenotype_liaison = internet_faker$email(),
    dataset_contact = internet_faker$email()
  )

  for (n in required_names) {
    this_df <- wide %>% dplyr::select(- !! rlang::sym(n))
    expect_error(.reformat_contact_table(this_df), "df names required to be",
                 info = sprintf("checking %s", n))
  }
})

test_that("reformatting fails with extra names", {
  required_names <- c("institution_type", "study_short_name", "project",
                      "pi", "co_pi", "contact", "phenotype_liaison", "dataset_contact")

  wide <- tibble::tibble(
    institution_type = c("Parent study"),
    study_short_name = c("ABC"),
    project = c("DEF"),
    pi = internet_faker$email(),
    co_pi = internet_faker$email(),
    contact = internet_faker$email(),
    phenotype_liaison = internet_faker$email(),
    dataset_contact = internet_faker$email(),
    extra_name = "foo"
  )

  expect_error(.reformat_contact_table(wide), "df names required to be",
               info = sprintf("checking %s", n))
})

test_that("works with names in a different order", {
  wide <- tibble::tibble(
    dataset_contact = internet_faker$email(),
    phenotype_liaison = internet_faker$email(),
    contact = internet_faker$email(),
    co_pi = internet_faker$email(),
    pi = internet_faker$email(),
    project = c("DEF"),
    study_short_name = c("ABC"),
    institution_type = c("Parent study")
  )

  long <- .reformat_contact_table(wide)
  expect_is(long, "tbl_df")
  expected_names <- c("institution_type", "study_short_name", "project", "contact_type", "email")
  expect_equal(names(long), expected_names)
  expect_equal(nrow(long), 5)
  expect_equal(long$contact_type, c("pi", "co_pi", "contact", "phenotype_liaison", "dataset_contact"))
  expect_equal(long$email,
               c(wide$pi, wide$co_pi, wide$contact, wide$phenotype_liaison, wide$dataset_contact))
})

test_that("reformatting works with two email addresses per field", {
  pi_emails <- c(internet_faker$email(), internet_faker$email())
  co_pi_emails <- c(internet_faker$email(), internet_faker$email())
  contact_emails <- c(internet_faker$email(), internet_faker$email())
  phenotype_liaison_emails <- c(internet_faker$email(), internet_faker$email())
  dataset_contact_emails <- c(internet_faker$email(), internet_faker$email())

  wide <- tibble::tibble(
    institution_type = c("Parent study"),
    study_short_name = c("ABC"),
    project = c("DEF"),
    pi = paste(pi_emails, collapse = "; "),
    co_pi = paste(co_pi_emails, collapse = "; "),
    contact = paste(contact_emails, collapse = "; "),
    phenotype_liaison = paste(phenotype_liaison_emails, collapse = "; "),
    dataset_contact = paste(dataset_contact_emails, collapse = "; ")
  )

  long <- .reformat_contact_table(wide)
  expect_is(long, "tbl_df")
  expected_names <- c("institution_type", "study_short_name", "project", "contact_type", "email")
  expect_equal(names(long), expected_names)
  expect_equal(nrow(long), 10)

  expect_equal(long$contact_type,
               rep(c("pi", "co_pi", "contact", "phenotype_liaison", "dataset_contact"), each = 2))
  expected_emails <- c(pi_emails, co_pi_emails, contact_emails, phenotype_liaison_emails,
                       dataset_contact_emails)
  expect_equal(long$email, expected_emails)

})

test_that("reformatting works with two email addresses in one field and one in another", {
  pi_emails <- c(internet_faker$email(), internet_faker$email())

  wide <- tibble::tibble(
    institution_type = c("Parent study"),
    study_short_name = c("ABC"),
    project = c("DEF"),
    pi = paste(pi_emails, collapse = "; "),
    co_pi = internet_faker$email(),
    contact = internet_faker$email(),
    phenotype_liaison = internet_faker$email(),
    dataset_contact = internet_faker$email()
  )

  long <- .reformat_contact_table(wide)
  expect_is(long, "tbl_df")
  expected_names <- c("institution_type", "study_short_name", "project", "contact_type", "email")
  expect_equal(names(long), expected_names)
  expect_equal(nrow(long), 6)

  expect_equal(long$contact_type,
               c("pi", "pi", "co_pi", "contact", "phenotype_liaison", "dataset_contact"))
  expected_emails <- c(pi_emails, wide$co_pi, wide$contact, wide$phenotype_liaison, wide$dataset_contact)
  expect_equal(long$email, expected_emails)
})

test_that("reformatting removes contact types with no email", {
  wide <- tibble::tibble(
    institution_type = c("Parent study"),
    study_short_name = c("ABC"),
    project = c("DEF"),
    pi = internet_faker$email(),
    co_pi = NA,
    contact = NA,
    phenotype_liaison = NA,
    dataset_contact = internet_faker$email()
  )

  long <- .reformat_contact_table(wide)
  expect_is(long, "tbl_df")
  expected_names <- c("institution_type", "study_short_name", "project", "contact_type", "email")
  expect_equal(names(long), expected_names)
  expect_equal(nrow(long), 2)

  expect_equal(long$contact_type,
               c("pi", "dataset_contact"))
  expected_emails <- c(wide$pi, wide$dataset_contact)
  expect_equal(long$email, expected_emails)
})
