library(markdown)

# 2. Analyse du traffic
getTraficAnalysis <- function() {
  # ---- constantes
  RV <- reactiveValues(hist_isFreq = TRUE, 
                       hist_yLabel = "Effectifs", 
                       hist_col = "blue")
  
  # ---- Nouveaux utilisateurs
  newUsersAnalysis <- list()
  newUsersAnalysis[["ui"]] <- tabPanel("Nouveaux utilisateurs",  
                                       fluidRow(
                                         column(4, align="center",
                                                plotOutput("histNewUsers")),
                                         column(8, align="center",
                                                plotOutput(outputId = "boiteMoustachesNewUsers"))
                                       ),
                                       verbatimTextOutput(outputId = "summaryNewUsers")
  )
  
  
  newUsersAnalysis[["server"]] <- function(input, output) {
    dataNouveaux <- read.csv("./inputs/Nouveaux utilisateurs.csv", header = TRUE)
    nouveaux <- dataNouveaux$nouveaux
    
    
    output$histNewUsers <- renderPlot({
      hist(nouveaux, freq = RV$hist_isFreq, main = "Histogramme")
    })
    output$summaryNewUsers <- renderPrint({ t(summary(dataNouveaux)) })
    output$boiteMoustachesNewUsers <- renderPlot({
      boxplot( dataNouveaux, col = grey(0.8), 
               main = "Nouveaux utilisateurs par jour",
               ylab = "Utilisateurs", las = 1)
      rug(dataNouveaux[,1], side = 2)
    })
  }
  
  # ---- Vues
  viewsAnalysis <- list()
  viewsAnalysis[["ui"]] <- tabPanel("Pages vues",  fluidRow(
    column(4, align="center",
           plotOutput("histViews")),
    column(8, align="center",
           plotOutput(outputId = "boiteMoustachesViews"))
  ),
  verbatimTextOutput(outputId = "summaryViews")
  )
  
  viewsAnalysis[["server"]] <- function(input, output) {
    dataViews <- read.csv("./inputs/Pages vues par jour.csv", header = TRUE)
    vues <- dataViews$vues
    
    output$histViews <- renderPlot({
      hist(vues, freq = RV$hist_isFreq, main = "Histogramme")
    })
    output$summaryViews <- renderPrint({ t(summary(dataViews)) })
    output$boiteMoustachesViews <- renderPlot({
      boxplot( dataViews, col = grey(0.8), 
               main = "Nombre de vues par jour",
               ylab = "Vues", las = 1)
      rug(dataViews[,1], side = 2)
    })
  }
  
  # ---- Utilisateurs actifs
  activeUsersAnalysis <- list()
  activeUsersAnalysis[["ui"]] <-  tabPanel("Utilisateurs actifs",  
                                           fluidRow(
                                             column(4, align="center",
                                                    plotOutput("histActiveUsers")),
                                             column(8, align="center",
                                                    plotOutput(outputId = "boiteMoustachesActiveUsers"))
                                           ),
                                           verbatimTextOutput(outputId = "summaryActiveUsers")
  )
  activeUsersAnalysis[["server"]] <- function(input, output) {
    dataActiveUsers <- read.csv("./inputs/utilisateurs actifs.csv", header = TRUE)
    actifs <- dataActiveUsers$actifs 
    
    output$histActiveUsers <- renderPlot({
      hist(actifs, freq = RV$hist_isFreq, main = "Histogramme")
    })
    output$summaryActiveUsers <- renderPrint({ t(summary(dataActiveUsers)) })
    output$boiteMoustachesActiveUsers <- renderPlot({
      boxplot( dataActiveUsers, col = grey(0.8), 
               main = "Utilisateurs actifs par jour",
               ylab = "Utilisateurs", las = 1)
      rug(dataActiveUsers[,1], side = 2)
    })
  }
  
  
  traficAnalysis <- list()
  traficAnalysis[["ui"]] <- tabsetPanel(
    newUsersAnalysis$ui,
    viewsAnalysis$ui,
    activeUsersAnalysis$ui,
    tabPanel("Analyse", includeMarkdown("./inputs/traficAnalysis.md"))
  )
  traficAnalysis[["server"]] <- function(input, output) {
    newUsersAnalysis$server(input, output)
    viewsAnalysis$server(input, output)
    activeUsersAnalysis$server(input, output)
  }
  
  return(traficAnalysis)
}

traficAnalysis <- getTraficAnalysis()