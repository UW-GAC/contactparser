
<!-- README.md is generated from README.Rmd. Please edit that file -->

# contactparser

<!-- badges: start -->

[![Travis build
status](https://travis-ci.org/UW-GAC/contactparser.svg?branch=master)](https://travis-ci.org/UW-GAC/contactparser)
<!-- badges: end -->

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
parse_contact_table(csv_file)
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
parse_contact_table(html_file)
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
