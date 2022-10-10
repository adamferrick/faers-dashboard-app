## this script downloads a quarterly data zip archive file from the FAERS website.
## takes one argument: the name of the desired file.

args = commandArgs(trailingOnly = TRUE)

if (length(args) == 0) {
  stop("Usage: Rscript download_data.R xxqx")
}


download.file(
  url = sprintf("https://fis.fda.gov/content/Exports/faers_ascii_20%s.zip", args[1]),
  destfile = sprintf("data/faers_ascii_20%s.zip", args[1]),
  method = "wget",
  extra = "--no-use-server-timestamps",
  timeout = 300
)
