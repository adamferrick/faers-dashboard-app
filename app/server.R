library(shiny)
library(tidyverse)
library(pool)

pool <- dbPool(
  drv = duckdb::duckdb(),
  dbdir = "../data/faers.duckdb",
  read_only = TRUE
)

onStop(function() {
  poolClose(pool)
})

server <- function(input, output) {

  output$first_plot <- renderPlot({
    pool %>%
      tbl("demo") %>%
      select(sex, primaryid) %>%
      distinct() %>%
      as_tibble() %>%
      ggplot(aes(sex)) +
      geom_bar()
  })

}
