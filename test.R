library(shiny)
library(markdown)

# Contenu de l'interface
ui <- navbarPage("Données Console Fun",
    tabPanel("Introduction", includeMarkdown("readme.md")),
    tabPanel("Présentation des données",
      tabsetPanel(
        tabPanel("Histogramme nouveaux utilisateurs",  fluidRow(
          column(4, align="center",
                 # Buton de mise à jour de la liste rv
                 plotOutput("histNewUsers")),
          column(8, align="center",
                 # Buton de mise à jour de la liste rv
                 verbatimTextOutput(outputId = "summaryNewUsers"))
          )
      ),
      tabPanel("Histogramme pages vues par jour",  fluidRow(
        column(4, align="center",
               # Buton de mise à jour de la liste rv
               plotOutput("histViews")),
        column(8, align="center",
               # Buton de mise à jour de la liste rv
               verbatimTextOutput(outputId = "summaryViews"))
        )
      ),
      tabPanel("Histogramme pages vues par jour",  fluidRow(
        column(4, align="center",
               # Buton de mise à jour de la liste rv
               plotOutput("histActives")),
        column(8, align="center",
               # Buton de mise à jour de la liste rv
               verbatimTextOutput(outputId = "summaryActives"))
        )
      )
    )
  ),
  tabPanel("Analyse de ...", verbatimTextOutput(outputId = "summ"))
)


  # Commandes à exécuter
  server <- function(input, output){
    data <- read.csv("./output/Nouveaux utilisateurs.csv", header = TRUE)
    dataViews <- read.csv("./output/Pages vues par jour.csv", header = TRUE)
    dataActives <- read.csv("./output/utilisateurs actifs.csv", header = TRUE)
    
    # Récupération des valeurs fecondite
    nouveaux <- data$nouveaux
    vues <- dataViews$vues
    actifs <- dataActives$actifs 
    
    
    # On initialise liste de valeurs réactives
    # ----
    rv <- reactiveValues(hist_isFreq = TRUE, 
                         hist_yLabel = "Effectifs", 
                         hist_col = "blue")
  
    # Histogramme
    # ----
    output$histNewUsers <- renderPlot({
      hist(nouveaux, freq = rv$hist_isFreq)
    })
    output$summaryNewUsers <- renderPrint({ t(summary(data)) })
    
    
    output$histViews <- renderPlot({
      hist(vues, freq = rv$hist_isFreq)
    })
    output$summaryViews <- renderPrint({ t(summary(dataViews)) })
    
    output$histActives <- renderPlot({
      hist(actifs, freq = rv$hist_isFreq)
    })
    output$summaryActives <- renderPrint({ t(summary(dataActives)) })
  }
  # Association interface & commandes
  shinyApp(ui = ui, server = server)