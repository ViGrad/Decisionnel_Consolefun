library(markdown)

# 5. Conclusion
conclusion <- list()
conclusion$ui <- includeMarkdown("./inputs/conclusion.md")
conclusion$server <- function(input, output) {}