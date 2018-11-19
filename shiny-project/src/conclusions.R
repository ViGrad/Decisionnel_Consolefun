library(markdown)

# 4. Conclusion
conclusion <- list()
conclusion$ui <- includeMarkdown("./inputs/conclusion.md")
conclusion$server <- function(input, output) {}