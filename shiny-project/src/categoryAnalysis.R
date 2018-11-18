library(shiny)
library(ggplot2)

# 4. Analyse de catégories
categoryAnalysis <- list()
categoryAnalysis$ui <- fluidPage(
  tabsetPanel(
    tabPanel("Diag. Barres (1 var.)", 
             fluidRow(
               column(6, plotOutput("barplotUni")),
               column(6, plotOutput("barplotOrderedUni"))
             )
    ),
    tabPanel("Diag. Barres (2 var.)", 
             fluidRow(
               column(6, plotOutput("barplotBi")),
               column(6, plotOutput("barplotDodgeBi"))
             )
    ),
    tabPanel("Diag. Profils", 
             fluidRow(
               column(6, plotOutput("barplotProfils")),
               column(6, tableOutput("contingency"))
             )
    ),
    tabPanel("Table", dataTableOutput("tableActivity"), style = "font-size: 85%")
  )
  , style = "font-size: 75%"
)
categoryAnalysis$server <- function(input, output){
  data <- read.csv("./inputs/ensemble bd analytics.csv", header=TRUE)
  colnames(data) = c("Pages de destinations","Sessions","% nouvelles sessions", "Nouveaux utilisateurs", "Taux de rebond", "Pages/session", "Durée moyenne des sessions", "Visite (Taux de conversion – Objectif 1)", "Visite (Réalisations de l'objectif 1)", "Visite (valeur de l'objectif 1)", "idfichejeux", "titrejeux", "descriptif", "editeur", "developpeur", "type", "sortie", "sortie_jp", "sortie_us", "support", "icones", "classification","multijoueur","console","image","idforum","pub","videotest","tournoi","auteur","galerie","id","date","categorie","multi","titre","contenu","jouabilite","note_jouabilite","graphismes","note_graphismes","bandeson","note_bandeson","dureedevie","note_dureedevie","scenario","note_scenario","conclusion","note","plus","moins","selection","image1","image2","image3","lien","topic","anecdotes","etat","une","dossier","fiche", "source") 
  
  # Données brutes
  # ----
  output$tableActivity <- renderDataTable({data})
  
  # Diagramme en barres
  # ----
  # Unidimensionnel
  output$barplotUni <- renderPlot({
    # Diagramme en barres de la variable 'categorie' avec ggplot
    ggplot(data, aes(x = categorie)) + geom_bar()
  })
  output$barplotOrderedUni <- renderPlot({
    # Diagramme en barres de la variable 'categorie' avec ggplot
    tmp.data <- data
    # On ordonne dans l'ordre naturel les différentes modalités de 'categorie'
    # freshman: 1, sophomore: 2, junior: 3, senior: 4, special: 5, graduate: 6
    tmp.order <- rep(0, nrow(data))
    tmp.order[with(tmp.data, categorie == "ps4")] = 1
    tmp.order[with(tmp.data, categorie == "xboxone")] = 2
    tmp.order[with(tmp.data, categorie == "switch")] = 3
    tmp.order[with(tmp.data, categorie == "pc")] = 4
    tmp.order[with(tmp.data, categorie == "iphone")] = 5
    tmp.order[with(tmp.data, categorie == "android")] = 6
    tmp.order[with(tmp.data, categorie == "multi")] = 4
    
    tmp.data$categorie <- with(tmp.data, reorder(categorie, tmp.order))
    rm(tmp.order)
    # Diagramme en barres de la variable 'categorie' avec ggplot
    ggplot(tmp.data, aes(x = categorie)) + geom_bar()
  })
  
  # Bidimensionnel
  output$barplotBi <- renderPlot({
    # Diagramme en barres entre les variables 'categorie' et 'Sessions'
    ggplot(data, aes(x = categorie, fill = Sessions)) + geom_bar()
  })
  output$barplotProfils <- renderPlot({
    # Diagramme de profils entre les variables 'categorie' et 'Sessions'
    ggplot(data, aes(x = categorie, fill = Sessions)) + geom_bar(position = "fill")
  })
  output$barplotDodgeBi <- renderPlot({
    # Diagramme de profils entre les variables 'categorie' et 'Sessions'
    ggplot(data, aes(x = categorie, fill = Sessions)) + geom_bar(position = "dodge")
  })
  
  # Table de contingence entre 'Sessions' et 'categorie'
  # ----
  output$contingency <- renderTable({
    tab = with(data, table(Sessions, categorie))
    round(tab/sum(tab), 3)
    tab
  })
  
}