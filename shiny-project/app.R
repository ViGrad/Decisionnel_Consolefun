options(Encoding="UTF-8")
library(data.table)
library(shiny)
eval(parse("src/introduction.R", encoding="UTF-8"))
eval(parse("src/traficAnalysis.R", encoding="UTF-8"))
eval(parse("src/categoryAnalysis.R", encoding="UTF-8"))
eval(parse("src/conclusions.R", encoding="UTF-8"))

ui <- navbarPage("Analyse Console Fun",
    tabPanel("Introduction", introduction$ui),
    tabPanel("Analyse du trafic", traficAnalysis$ui),
    tabPanel("Analyse de l'activité", categoryAnalysis$ui),
    tabPanel("Constat", conclusion$ui)
  )

  server <- function(input, output){
    # 1. Introduction
    introduction$server(input, output)
    # 2. Analyse du trafic
    traficAnalysis$server(input, output)
    # 3. Analyse de catégories
    categoryAnalysis$server(input, output)
    # 4. Conclusion
    conclusion$server(input, output)
  }

shinyApp(ui = ui, server = server)