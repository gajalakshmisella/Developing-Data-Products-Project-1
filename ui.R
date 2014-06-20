#
# http://www.rstudio.com/shiny/
#

library(shiny)

shinyUI(pageWithSidebar(
  
  # Application title
  headerPanel("NBA Player Comparison Application"),
  
  # Sidebar with a slider input for number of observations
  sidebarPanel(
  
    helpText("Explore how the average NBA player characteristics (height, weight, age and BMI), ",
      "have changed over the years. You can also choose to view new players (commonly known as rookies)",
      "entering the league separately."),
  
    selectInput("select", label = h4("Choose the dimension"), 
                choices = list("Height" = 1, "Weight" = 2,
                               "BMI" = 3, "Age" = 4), selected = 1),
    checkboxInput("show_rookies", "Show Rookies Separately", FALSE)
  ),
  
  # Show a plot of the generated distribution
  mainPanel(
    plotOutput("playersPlot")
  )
))
