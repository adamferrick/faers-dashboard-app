library(shiny)
library(DT)
library(tidyverse)
library(pool)
library(plotly)

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

  output$cases_drug <- renderDT({
    pool %>%
      tbl("drug") %>%
      select(primaryid, drugname) %>%
      distinct() %>%
      group_by(drugname) %>%
      summarise(count = n()) %>%
      ungroup() %>%
      arrange(desc(count)) %>%
      as_tibble()
  })

  output$cases_reac <- renderDT({
    pool %>%
      tbl("reac") %>%
      select(primaryid, pt) %>%
      distinct() %>%
      group_by(pt) %>%
      summarise(count = n()) %>%
      ungroup() %>%
      arrange(desc(count)) %>%
      as_tibble()
  })

  output$outc_plot <- renderPlotly({
    pool %>%
      tbl("outc") %>%
      select(primaryid, outc_cod) %>%
      distinct() %>%
      group_by(outc_cod) %>%
      summarise(count = n()) %>%
      ungroup() %>%
      as_tibble() %>%
      mutate(
        outcome = fct_recode(
          outc_cod,
          "Death" = "DE",
          "Life-Threatening" = "LT",
          "Hospitalization - Initial or Prolonged" = "HO",
          "Disability" = "DS",
          "Congenital Anomaly" = "CA",
          "Required Intervention to Prevent Permanent Impairment/Damage" = "RI",
          "Other Serious (Important Medical Event)" = "OT"
        )
      ) %>%
      plot_ly(x = ~count, y = ~outcome, type = "bar", orientation = "h")
  })

  output$age_sex_heatmap <- renderPlotly({
    pool %>%
      tbl("demo") %>%
      select(primaryid, sex, age_grp) %>%
      distinct() %>%
      group_by(sex, age_grp) %>%
      summarise(count = n()) %>%
      ungroup() %>%
      as_tibble() %>%
      mutate(
        `Age Group` = fct_recode(
          age_grp,
          "Neonate" = "N",
          "Infant" = "I",
          "Child" = "C",
          "Adolescent" = "T",
          "Adult" = "A",
          "Elderly" = "E"
        ),
        Sex = fct_recode(
          sex,
          "Unknown" = "Unk",
          "Male" = "M",
          "Female" = "F"
        )
      ) %>%
      plot_ly(x = ~`Age Group`, y = ~count, color = ~Sex, type = "bar")
  })

  output$reporters_plot <- renderPlotly({
    pool %>%
      tbl("demo") %>%
      select(primaryid, occp_cod) %>%
      distinct() %>%
      group_by(occp_cod) %>%
      summarise(count = n()) %>%
      ungroup() %>%
      as_tibble() %>%
      mutate(
        Reporter = fct_recode(
          occp_cod,
          "Physician" = "MD",
          "Pharmacist" = "PH",
          "Other Health Professional" = "HP",
          "Lawyer" = "LW",
          "Consumer" = "CN"
        )
      ) %>%
      plot_ly(x = ~count, y = ~Reporter, type = "bar", orientation = "h")
  })
}
