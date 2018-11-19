library(markdown)

# 1. Introduction
introduction <- list()
introduction$ui <- includeMarkdown("./inputs/introduction.md")
introduction$server <- function(input, output) {}