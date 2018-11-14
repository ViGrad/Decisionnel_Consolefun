options(Encoding="UTF-8")
library(shiny)

source("src/introduction.R")
source("src/trafficAnalysis.R")
source("src/quantitative.R")

# 2. Variable quantitative
# ---- Nuage de points
ui <- navbarPage("Analyse Console Fun",
    tabPanel("Introduction", introduction$ui),
    tabPanel("Analyse du traffic", trafficAnalysis$ui),
    tabPanel("Variable quantitative", quantitative$ui)
  )

  server <- function(input, output){
    # 1. Introduction
    introduction$server(input, output)
    # 2. Presentation des données
    trafficAnalysis$server(input, output)
    # 3. Analyse quantitative
    quantitative$server(input, output)
  }

shinyApp(ui = ui, server = server)