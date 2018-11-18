options(Encoding="UTF-8")
library(data.table)
library(shiny)
eval(parse("src/introduction.R", encoding="UTF-8"))
eval(parse("src/trafficAnalysis.R", encoding="UTF-8"))
eval(parse("src/quantitative.R", encoding="UTF-8"))
eval(parse("src/categoryAnalysis.R", encoding="UTF-8"))


# 2. Variable quantitative
# ---- Nuage de points
ui <- navbarPage("Analyse Console Fun",
    tabPanel("Introduction", introduction$ui),
    tabPanel("Analyse du traffic", trafficAnalysis$ui),
    #tabPanel("Variable quantitative", quantitative$ui),
    tabPanel("Analyse de l'activité", categoryAnalysis$ui)
  )

  server <- function(input, output){
    # 1. Introduction
    introduction$server(input, output)
    # 2. Presentation des donn?es
    trafficAnalysis$server(input, output)
    # 3. Analyse quantitative
    #quantitative$server(input, output)
    # 4. Analyse de catégories
    categoryAnalysis$server(input, output)
  }

shinyApp(ui = ui, server = server)