context("parse_contact_table tests")

test_that("works with html", {
  parsed <- parse_contact_table(system.file(package = "contactparser", "testdata", "example.html"))
  expect_is(parsed, "tbl_df")
  expect_equal(nrow(parsed), 7)
  expect_equal(names(parsed), c("record_type", "study_short_name", "project", "contact_type", "email"))
  expect_equal(parsed$record_type, c(rep("Parent Study", 5), rep("TOPMed Project", 2)))
  expect_equal(parsed$study_short_name, c(rep("Study1", 5), rep("Study2", 2)))
  expect_equal(parsed$project, c(rep("Project1", 5), rep("Project2", 2)))
  expect_equal(parsed$contact_type,
               c("pi", "co_pi", "contact", "contact", "dataset_contact","pi", "contact"))
  expected_emails <- c(
    "nia.vonrueden@yahoo.com", "nia.vonrueden@yahoo.com", "koelpin.kathaleen@gmail.com",
    "ilona.cartwright@yahoo.com", "sdenesik@hotmail.com", "karren.schmeler@group.biz",
    "karren.schmeler@group.biz"
  )
  expect_equal(parsed$email, expected_emails)
})

test_that("works with csv", {
  parsed <- parse_contact_table(system.file(package = "contactparser", "testdata", "example.csv"))
  expect_is(parsed, "tbl_df")
})
