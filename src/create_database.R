## this script creates a DuckDB database from the zip archive of the 2022 Q2 FAERS data.


# load packages
library(DBI)
library(stringr)
library(purrr)


# unzip the data
tmpdir <- tempdir()
unzip("data/faers_ascii_2022q2.zip", exdir = tmpdir)


# create the database
con = dbConnect(duckdb::duckdb(), dbdir = "data/faers.duckdb", read_only = FALSE)


# read the csv files into DuckDB
write_table <- function(name) {
  path <- str_c(tmpdir, "/ASCII/", toupper(name), "22Q2.txt")

  dbExecute(
    con,
    str_c("CREATE TABLE ", name, " AS SELECT * FROM read_csv_auto('", path, "', header=True, sep='$', sample_size=-1)")
  )
}

table_names <- c("demo", "drug", "indi", "outc", "reac", "rpsr", "ther")

walk(table_names, write_table)

dbDisconnect(con, shutdown = TRUE)
