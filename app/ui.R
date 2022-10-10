library(shiny)
library(shinydashboard)

ui <- dashboardPage(
  title = "FAERS Quarterly Dashboard",
  dashboardHeader(title = "FAERS Quarterly Dashboard"),
  dashboardSidebar(),
  dashboardBody(
    box(plotOutput("first_plot"), width = 8),
  )
)
