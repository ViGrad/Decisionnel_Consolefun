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
                 plotOutput("hist")),
          column(8, align="center",
                 # Buton de mise à jour de la liste rv
                 verbatimTextOutput(outputId = "summary"))
          )
        ),
        tabPanel("Histogramme utilisateurs par jour",  fluidRow(
          column(4, align="center",
                 # Buton de mise à jour de la liste rv
                 plotOutput("histUsers")),
          column(8, align="center",
                 # Buton de mise à jour de la liste rv
                 verbatimTextOutput(outputId = "summaryUsers"))
        )
      ),
      tabPanel("Histogramme utilisateurs par jour",  fluidRow(
        column(4, align="center",
               # Buton de mise à jour de la liste rv
               plotOutput("histUsers")),
        column(8, align="center",
               # Buton de mise à jour de la liste rv
               verbatimTextOutput(outputId = "summaryUsers"))
      )),
      tabPanel("Pages vue par jour",  fluidRow(
        column(4, align="center",
               # Buton de mise à jour de la liste rv
               plotOutput("histSeenPage")),
        column(8, align="center",
               # Buton de mise à jour de la liste rv
               verbatimTextOutput(outputId = "summarySeenPage"))
        )
      )
    )
  ),
  tabPanel("Analyse de ...", verbatimTextOutput(outputId = "summ"))
)


  # Commandes à exécuter
  server <- function(input, output){
    data <- read.csv("./output/Nouveaux utilisateurs.csv", header = TRUE)
    data2 <- read.csv("./output/utilisateurs actifs.csv", header = TRUE)
    data3 <- read.csv("./output/Pages vues par jour.csv", header = TRUE)
    
    # Récupération des valeurs fecondite
    nouveaux <- reactive({
      if(!"nouveaux" %in% colnames(data)) return(NULL)
      data$nouveaux
    })
    
    users <- reactive({
      if(!"actifs" %in% colnames(data2)) return(NULL)
      as.numeric((unlist(data2)))
    })
    
    seenPage <- reactive({
      if(!"actifs" %in% colnames(data3)) return(NULL)
      as.numeric((unlist(data3)))
    })
    
    
    # On initialise liste de valeurs réactives
    # ----
    rv <- reactiveValues(hist_isFreq = TRUE, 
                         hist_yLabel = "Effectifs", 
                         hist_col = "blue")
  
    # Histogramme
    # ----
    output$hist <- renderPlot({
      hist(nouveaux(), freq = rv$hist_isFreq)
    })
    
    output$histUsers <- renderPlot({
      hist(users(), freq = rv$hist_isFreq)
    })
    
    output$histSeenPage <- renderPlot({
      hist(seenPage(), freq = rv$hist_isFreq)
    })
    
    
    output$summary <- renderPrint({ t(summary(data)) })
    output$summaryUsers <- renderPrint({ t(summary(data2)) })
    output$summarySeenPage <- renderPrint({ t(summary(data3)) })
  }
  # Association interface & commandes
  shinyApp(ui = ui, server = server)