options(Encoding="UTF-8")

# 2. Variables quantitatives

getQuantitative <- function () {
  # ---- Nuage de points
  cloud <- list()
  cloud$ui <- tabPanel("Nuage de points", 
                       fluidRow(
                         column(8, offset = 1, plotOutput("nuagePoints"))
                       ),
                       fluidRow(
                         column(4, offset = 3, textOutput("correlation"))
                       )
  )
  cloud$server <- function(input, output, dataSet) {
    output$nuagePoints <- renderPlot({
      # Simple nuage de point EF vs CA
      options(scipen=999)
      x.var = "EF"; y.var = "CA";
      plot(x = dataSet[, x.var], y = dataSet[, y.var], col = "blue",
           las = 2, cex.axis = 0.7,
           main = paste(y.var, "en fonction de", x.var),
           xlab = x.var, ylab = y.var, cex.lab = 1.2
      )
      # Droite de régression linéaire (y~x) 
      abline(lm(dataSet[, y.var]~dataSet[, x.var]), col="red", lwd = 2)
      options(scipen=0)
    })
  }
  
  # ---- Caractéristiques
  caract <- list()
  caract$ui <- tabPanel("Caractéristiques", tableOutput("caract"))
  caract$server <- function(input, output, dataSet) {
    output$caract <- renderTable({
      # Définition des colonnes choisies 
      var.names <- c("NB", "EF", "CA")
      # Initialisation de la table
      caract.df <- data.frame()
      # Pour chaque colonne, calcul de min, max, mean et ecart-type
      for(strCol in var.names){
        caract.vect <- c(min(dataSet[, strCol]), max(dataSet[,strCol]), 
                         mean(dataSet[,strCol]), sqrt(var(dataSet[,strCol])))
        caract.df <- rbind.data.frame(caract.df, caract.vect)
      }
      # Définition des row/colnames
      rownames(caract.df) <- var.names
      colnames(caract.df) <- c("Minimum", "Maximum", "Moyenne", "Ecart-type")
      # Renvoyer la table
      caract.df
    }, rownames = TRUE, digits = 0)
  }
  
  # ---- Résumé
  summary <- list()
  summary$ui <- tabPanel("Table", tableOutput("table"))
  summary$server <- function(input, output, dataSet) {
    # Données brutes
    output$table <- renderTable({dataSet}, colnames = TRUE)
    
    output$expSummary <- renderTable({
      expSummary.df <- data.frame()
      # Pour chaque exemple de jeu de données...
      for(i in 1:4){
        tmp.data.x <- dataHelp[which(dataHelp[, 1] == paste("X", i, sep = "")), 2]
        tmp.data.y <- dataHelp[which(dataHelp[, 1] == paste("Y", i, sep = "")), 2]
        tmp.et.x <- sqrt((1/length(tmp.data.x))*sum((tmp.data.x-mean(tmp.data.x))^2))
        tmp.et.y <- sqrt((1/length(tmp.data.y))*sum((tmp.data.y-mean(tmp.data.x))^2))
        tmp.row <- c(mean(tmp.data.x), mean(tmp.data.y), tmp.et.x, tmp.et.y,
                     cov(tmp.data.x, tmp.data.y)/(sd(tmp.data.x)*sd(tmp.data.y)))
        expSummary.df <- rbind.data.frame(expSummary.df, tmp.row)
      }
      colnames(expSummary.df) <- c("moy. X", "moy. Y", "sd. X", "sd. Y", "corr(X, Y)")
      rownames(expSummary.df) <- c("data1", "data2", "data3", "data4")
      expSummary.df
    }, 
    colnames = TRUE, rownames = TRUE, bordered = TRUE)
  }
  
  quantitative <- list()
  quantitative$ui <- tabsetPanel(
                      cloud$ui,
                      caract$ui,
                      summary$ui
                    )
  
  quantitative$server <- function(input, output) {
    dataSet <-  fread("./inputs/ensemble bd analytics.csv", header=TRUE)
    dataHelp <- fread("./inputs/ensemble bd analytics.csv", header=TRUE)
    
    reactive({rnorm(input$num)})
    
    cloud$server(input, output, dataSet)
    caract$server(input, output, dataSet)
    summary$server(input, output, dataSet)
  }
  
  return(quantitative)
}

quantitative <- getQuantitative()

