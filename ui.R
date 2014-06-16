#
# http://www.rstudio.com/shiny/
#

library(shiny)

shinyUI(pageWithSidebar(
  
  # Application title
  headerPanel("NBA Rookie Comparison Application"),
 
  
  # Sidebar with a slider input for number of observations
  sidebarPanel(
  
    helpText("Explore how the average NBA player characteristics (heigh, weight, age and BMI), ",
      "have changed over the years for the new players (commonly known as rookies)",
      "entering the league. "),
  
    selectInput("select", label = h3("Choose the dimention"), 
                choices = list("Height" = 1, "Weight" = 2,
                               "BMI" = 3, "Age" = 4), selected = 1)          
  ),
  
  # Show a plot of the generated distribution
  mainPanel(
    plotOutput("playersPlot")
  )
))
