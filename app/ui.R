library(shiny)
library(shinydashboard)
library(DT)
library(plotly)

ui <- dashboardPage(
  title = "FAERS Quarterly Dashboard",
  dashboardHeader(title = "FAERS Quarterly Dashboard"),

  dashboardSidebar(
    sidebarMenu(
      menuItem("Drugs", tabName = "drugs"),
      menuItem("Reactions", tabName = "reactions"),
      menuItem("Demographics", tabName = "demographics"),
      menuItem("Reporters", tabName = "reporters")
    )
  ),

  dashboardBody(
    # Collapsible filter box
    fluidRow(
      h2("Filters")
    ),

    tabItems(

      tabItem(
        tabName = "drugs",
        fluidRow(h2("Drugs")),
        fluidRow(
          box(DTOutput("cases_drug"), width = 10)
        )
      ),

      tabItem(
        tabName = "reactions",
        fluidRow(h2("Outcomes")),
        fluidRow(
          box(plotlyOutput("outc_plot"), width = 10)
        ),
        fluidRow(h2("Reactions")),
        fluidRow(
          box(DTOutput("cases_reac"), width = 10)
        )
      ),

      tabItem(
        tabName = "demographics",
        fluidRow(h2("Demographics")),
        fluidRow(
          box(plotlyOutput("age_sex_heatmap"), width = 10)
        )
      ),

      tabItem(
        tabName = "reporters",
        fluidRow(h2("Reporters"))
      )
    )
  )
)
