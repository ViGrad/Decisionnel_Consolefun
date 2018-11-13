options(Encoding="UTF-8")
library(shiny)
library(markdown)

# Contenu de l'interface
ui <- navbarPage("Analyse Console Fun",
    tabPanel("Introduction", includeMarkdown("readme.md")),
    tabPanel("Analyse du traffic",
      tabsetPanel(
        tabPanel("Nouveaux utilisateurs",  
          fluidRow(
            column(4, align="center",
                   # Buton de mise à jour de la liste rv
                   plotOutput("histNewUsers")),
            column(8, align="center",
                   # Buton de mise à jour de la liste rv
                   plotOutput(outputId = "boiteMoustachesNewUsers"))
          ),
          verbatimTextOutput(outputId = "summaryNewUsers")
      ),
      tabPanel("Pages vues",  fluidRow(
        column(4, align="center",
               # Buton de mise à jour de la liste rv
               plotOutput("histViews")),
        column(8, align="center",
               # Buton de mise à jour de la liste rv
               plotOutput(outputId = "boiteMoustachesViews"))
        ),
        verbatimTextOutput(outputId = "summaryViews")
      ),
      tabPanel("Utilisateurs actifs",  fluidRow(
        column(4, align="center",
               # Buton de mise à jour de la liste rv
               plotOutput("histActiveUsers")),
        column(8, align="center",
               # Buton de mise à jour de la liste rv
               plotOutput(outputId = "boiteMoustachesActiveUsers"))
        ),
        verbatimTextOutput(outputId = "summaryActiveUsers")
      )
    )
  ),
  tabPanel("Analyse de ...", verbatimTextOutput(outputId = "summ"))
)


  # Commandes à exécuter
  server <- function(input, output){
    data <- read.csv("./output/Nouveaux utilisateurs.csv", header = TRUE)
    dataViews <- read.csv("./output/Pages vues par jour.csv", header = TRUE)
    dataActiveUsers <- read.csv("./output/utilisateurs actifs.csv", header = TRUE)
    
    # Récupération des valeurs fecondite
    nouveaux <- data$nouveaux
    vues <- dataViews$vues
    actifs <- dataActiveUsers$actifs 
    
    
    # On initialise liste de valeurs réactives
    # ----
    rv <- reactiveValues(hist_isFreq = TRUE, 
                         hist_yLabel = "Effectifs", 
                         hist_col = "blue")
  
    # ---- Nouveaux utilisateurs
    output$histNewUsers <- renderPlot({
      hist(nouveaux, freq = rv$hist_isFreq, main = "Histogramme")
    })
    output$summaryNewUsers <- renderPrint({ t(summary(data)) })
    output$boiteMoustachesNewUsers <- renderPlot({
      # Boîte à moustaches
      boxplot( data, col = grey(0.8), 
               main = "Nouveaux utilisateurs par jour",
               ylab = "Utilisateurs", las = 1)
      # Affichage complémentaires en Y des différents âges
      rug(data[,1], side = 2)
    })
    
    # ---- Vues
    output$histViews <- renderPlot({
      hist(vues, freq = rv$hist_isFreq, main = "Histogramme")
    })
    output$summaryViews <- renderPrint({ t(summary(dataViews)) })
    output$boiteMoustachesViews <- renderPlot({
      # Boîte à moustaches
      boxplot( dataViews, col = grey(0.8), 
               main = "Nombre de vues par jour",
               ylab = "Vues", las = 1)
      # Affichage complémentaires en Y des différents âges
      rug(dataViews[,1], side = 2)
    })
    
    # ---- Utilisateurs actifs
    output$histActiveUsers <- renderPlot({
      hist(actifs, freq = rv$hist_isFreq, main = "Histogramme")
    })
    output$summaryActiveUsers <- renderPrint({ t(summary(dataActiveUsers)) })
    output$boiteMoustachesActiveUsers <- renderPlot({
      # Boîte à moustaches
      boxplot( dataActiveUsers, col = grey(0.8), 
               main = "Utilisateurs actifs par jour",
               ylab = "Utilisateurs", las = 1)
      # Affichage complémentaires en Y des différents âges
      rug(dataActiveUsers[,1], side = 2)
    })
  }
  # Association interface & commandes
  shinyApp(ui = ui, server = server)