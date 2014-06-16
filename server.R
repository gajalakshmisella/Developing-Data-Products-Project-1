# http://www.rstudio.com/shiny/
#

library(shiny)
library(ggplot2)

# read in the player data and mangle it into right form
# aggreagte means of height, weight, bmi and age of rookia players
# are stored in totals data frame

source("players.R")

shinyServer(function(input, output) {
  
  output$playersPlot <- renderPlot({
         
    if (input$select == 1) {
      display_data <- totals$HeightInches
      title = "Heigh of Rookies"
      ylabel <- "Heigh (inches)"
    } else if (input$select == 2) {
      display_data <- totals$Wt
      title = "Weight of Rookies"        
      ylabel <- "Weight (lbs)"
    } else if (input$select == 3) {
      display_data <- totals$BMI
      title = "Body-Mass Index of Rookies"  
      ylabel <- "BMI"      
    } else {
      display_data <- totals$RookieAge
      title = "Age as a Rookie"        
      ylabel <- "Age"
    }
    
    p <- qplot(totals$From, display_data,
               main = title,
               xlab = "Year",
               ylab = ylabel
               )
    p <- p + scale_x_continuous(breaks=seq(1950, 2010, 10))
    p <- p + stat_smooth(method="loess")
    p <- p + theme(text = element_text(size=20), 
                   title = element_text(size=20))
    print(p)        
  })
  
})
