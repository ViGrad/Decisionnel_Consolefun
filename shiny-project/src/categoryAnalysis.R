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
  data <- fread("./inputs/ensemble bd analytics.csv", header=TRUE)
  colnames(data) = c("Pages de destinations","Sessions","% nouvelles sessions", "Nouveaux utilisateurs", "Taux de rebond", "Pages/session", "Durée moyenne des sessions", "Visite (Taux de conversion – Objectif 1)", "Visite (Réalisations de l'objectif 1)", "Visite (valeur de l'objectif 1)", "idfichejeux", "titrejeux", "descriptif", "editeur", "developpeur", "type", "sortie", "sortie_jp", "sortie_us", "support", "icones", "classification","multijoueur","console","image","idforum","pub","videotest","tournoi","auteur","galerie","id","date","categorie","multi","titre","contenu","jouabilite","note_jouabilite","graphismes","note_graphismes","bandeson","note_bandeson","dureedevie","note_dureedevie","scenario","note_scenario","conclusion","note","plus","moins","selection","image1","image2","image3","lien","topic","anecdotes","etat","une","dossier","fiche", "source") 
  
  # Données brutes
  # ----
  output$tableActivity <- renderDataTable({data})
  
  # Diagramme en barres
  # ----
  # Unidimensionnel
  output$barplotUni <- renderPlot({
    # Diagramme en barres de la variable 'Level' avec ggplot
    ggplot(data, aes(x = Level)) + geom_bar()
  })
  output$barplotOrderedUni <- renderPlot({
    # Diagramme en barres de la variable 'Level' avec ggplot
    tmp.data <- data
    # On ordonne dans l'ordre naturel les différentes modalités de 'Level'
    # freshman: 1, sophomore: 2, junior: 3, senior: 4, special: 5, graduate: 6
    tmp.order <- rep(0, nrow(data))
    tmp.order[with(tmp.data, Level == "freshman")] = 1
    tmp.order[with(tmp.data, Level == "sophomore")] = 2
    tmp.order[with(tmp.data, Level == "junior")] = 3
    tmp.order[with(tmp.data, Level == "senior")] = 4
    tmp.order[with(tmp.data, Level == "special")] = 5
    tmp.order[with(tmp.data, Level == "graduate")] = 6
    tmp.data$Level <- with(tmp.data, reorder(Level, tmp.order))
    rm(tmp.order)
    # Diagramme en barres de la variable 'Level' avec ggplot
    ggplot(tmp.data, aes(x = Level)) + geom_bar()
  })
  
  # Bidimensionnel
  output$barplotBi <- renderPlot({
    # Diagramme en barres entre les variables 'Level' et 'Sex'
    ggplot(data, aes(x = Level, fill = Sex)) + geom_bar()
  })
  output$barplotProfils <- renderPlot({
    # Diagramme de profils entre les variables 'Level' et 'Sex'
    ggplot(data, aes(x = Level, fill = Sex)) + geom_bar(position = "fill")
  })
  output$barplotDodgeBi <- renderPlot({
    # Diagramme de profils entre les variables 'Level' et 'Sex'
    ggplot(data, aes(x = Level, fill = Sex)) + geom_bar(position = "dodge")
  })
  
  # Table de contingence entre 'Sex' et 'Level'
  # ----
  output$contingency <- renderTable({
    tab = with(data, table(Sex, Level))
    round(tab/sum(tab), 3)
    tab
  })
  
}