library(shiny)
library(ggplot2)

# 4. Analyse de catégories
categoryAnalysis <- list()
categoryAnalysis$ui <- fluidPage(
  tabsetPanel(
    tabPanel("Diag. Barres (1 var.)", 
             fluidRow(
               column(12, plotOutput("barplotUni")),
               column(12, plotOutput("barplotOrderedUni"))
             )
    ),
    tabPanel("Diag. Barres (2 var.)", 
             fluidRow(
               column(12, plotOutput("barplotBi")),
               column(12, plotOutput("barplotDodgeBi"))
             )
    ),
    tabPanel("Diag. Profils", 
             fluidRow(
               column(12, plotOutput("barplotProfils")),
               column(6, tableOutput("contingency"))
             )
    ),
    tabPanel("Table", dataTableOutput("tableActivity"), style = "font-size: 85%")
  )
  , style = "font-size: 75%"
)
categoryAnalysis$server <- function(input, output){
  data <- read.csv("./inputs/ensemble bd analytics.csv", header=TRUE)
  # Données brutes
  # ----
  output$tableActivity <- renderDataTable({data})
  
  # Diagramme en barres
  # ----
  # Unidimensionnel
  output$barplotUni <- renderPlot({
    # Diagramme en barres de la variable 'genre' avec ggplot
    ggplot(data, aes(x = genre)) + geom_bar()
  })
  output$barplotOrderedUni <- renderPlot({
    # Diagramme en barres de la variable 'genre' avec ggplot
    tmp.data <- data
    # On ordonne dans l'ordre naturel les différentes modalités de 'genre'
    # freshman: 1, sophomore: 2, junior: 3, senior: 4, special: 5, graduate: 6
    tmp.order <- rep(0, nrow(data))
    tmp.order[with(tmp.data, genre == "ps4")] = 1
    tmp.order[with(tmp.data, genre == "xboxone")] = 2
    tmp.order[with(tmp.data, genre == "switch")] = 3
    tmp.order[with(tmp.data, genre == "pc")] = 4
    tmp.order[with(tmp.data, genre == "iphone")] = 5
    tmp.order[with(tmp.data, genre == "android")] = 6
    tmp.order[with(tmp.data, genre == "multi")] = 4
    
    tmp.data$genre <- with(tmp.data, reorder(genre, tmp.order))
    rm(tmp.order)
    # Diagramme en barres de la variable 'genre' avec ggplot
    ggplot(tmp.data, aes(x = genre)) + geom_bar()
  })
  
  # Bidimensionnel
  output$barplotBi <- renderPlot({
    # Diagramme en barres entre les variables 'genre' et 'categorie'
    ggplot(data, aes(x = genre, fill = categorie)) + geom_bar()
  })
  output$barplotProfils <- renderPlot({
    # Diagramme de profils entre les variables 'genre' et 'categorie'
    ggplot(data, aes(x = genre, fill = categorie)) + geom_bar(position = "fill")
  })
  output$barplotDodgeBi <- renderPlot({
    # Diagramme de profils entre les variables 'genre' et 'categorie'
    ggplot(data, aes(x = genre, fill = categorie)) + geom_bar(position = "dodge")
  })
  
  # Table de contingence entre 'categorie' et 'genre'
  # ----
  output$contingency <- renderTable({
    tab = with(data, table(categorie, genre))
    round(tab/sum(tab), 3)
    tab
  })
  
}