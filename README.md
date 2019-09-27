
<!-- README.md is generated from README.Rmd. Please edit that file -->

# contactparser

<!-- badges: start -->

| Branch                     | Build status                                                                                                                                       |
| :------------------------- | :------------------------------------------------------------------------------------------------------------------------------------------------- |
| **master**                 | [![Travis build status](https://travis-ci.org/UW-GAC/contactparser.svg?branch=master)](https://travis-ci.org/UW-GAC/contactparser)                 |
| **feature/improve-readme** | [![Travis build status](https://travis-ci.org/UW-GAC/contactparser.svg?branch=feature/improve-readme)](https://travis-ci.org/UW-GAC/contactparser) |

<!-- badges: end -->

## Description

The contactparser package was designed to parse and reformat the
[Contacts table](https://www.nhlbiwgs.org/contact-filter) on the TOPMed
website.

## Installation

You can install the released version of contactparser from
[github](https://github.com/UW-GAC/contactparser) with:

``` r
# install.packages("devtools") 
devtools::install_github("UW-GAC/contactparser")
```

## Example

This package has one primary function to read, parse, and reformat the
contacts table. It starts with either a csv file or an html file, parses
it, and reshapes the table so that it can easily be filtered by TOPMed
study, project, or contact type (PI, Co-PI, Contact, etc.).

First, export the table to a csv file with the “export” button. Then
call:

``` r
library(contactparser)
csv_file <- system.file(package = "contactparser", "testdata", "example.csv")
parsed <- parse_contact_table(csv_file)
parsed
#> # A tibble: 7 x 5
#>   record_type   study_short_name project  contact_type   email             
#>   <chr>         <chr>            <chr>    <chr>          <chr>             
#> 1 Parent Study  Study1           Project1 pi             nia.vonrueden@yah…
#> 2 Parent Study  Study1           Project1 co_pi          nia.vonrueden@yah…
#> 3 Parent Study  Study1           Project1 contact        koelpin.kathaleen…
#> 4 Parent Study  Study1           Project1 contact        ilona.cartwright@…
#> 5 Parent Study  Study1           Project1 dataset_conta… sdenesik@hotmail.…
#> 6 TOPMed Proje… Study2           Project2 pi             karren.schmeler@g…
#> 7 TOPMed Proje… Study2           Project2 contact        karren.schmeler@g…
```

You can also save the webpage as an html file and parse the contact
table from the html:

``` r
library(contactparser)
html_file <- system.file(package = "contactparser", "testdata", "example.html")
parsed <- parse_contact_table(html_file)
parsed
#> # A tibble: 7 x 5
#>   record_type   study_short_name project  contact_type   email             
#>   <chr>         <chr>            <chr>    <chr>          <chr>             
#> 1 Parent Study  Study1           Project1 pi             nia.vonrueden@yah…
#> 2 Parent Study  Study1           Project1 co_pi          nia.vonrueden@yah…
#> 3 Parent Study  Study1           Project1 contact        koelpin.kathaleen…
#> 4 Parent Study  Study1           Project1 contact        ilona.cartwright@…
#> 5 Parent Study  Study1           Project1 dataset_conta… sdenesik@hotmail.…
#> 6 TOPMed Proje… Study2           Project2 pi             karren.schmeler@g…
#> 7 TOPMed Proje… Study2           Project2 contact        karren.schmeler@g…
```

Once you’ve parsed the file, you can easily filter to specific types of
contacts using `dplyr` functions:

``` r
library(dplyr, quietly = TRUE)

# Just PIs:
pis <- parsed %>%
  filter(contact_type %in% c("pi", "co_pi"))
pis
#> # A tibble: 3 x 5
#>   record_type    study_short_name project contact_type email               
#>   <chr>          <chr>            <chr>   <chr>        <chr>               
#> 1 Parent Study   Study1           Projec… pi           nia.vonrueden@yahoo…
#> 2 Parent Study   Study1           Projec… co_pi        nia.vonrueden@yahoo…
#> 3 TOPMed Project Study2           Projec… pi           karren.schmeler@gro…
```

Then you can create a string of emails that you can cut and paste into
your email client:

``` r
unique_pi_emails <- unique(pis$email)
cat(paste(unique_pi_emails, collapse = ", "))
#> nia.vonrueden@yahoo.com, karren.schmeler@group.biz
```
