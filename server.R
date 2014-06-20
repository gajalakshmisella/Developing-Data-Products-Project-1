# http://www.rstudio.com/shiny/
#

library(shiny)
library(ggplot2)


shinyServer(function(input, output) {
  
  output$playersPlot <- renderPlot({
         
    if (input$select == 1) {
      display_data <- totals$HeightInches
      title = "Heights"
      ylabel <- "Heigh (inches)"
    } else if (input$select == 2) {
      display_data <- totals$Wt
      title = "Weights"        
      ylabel <- "Weight (lbs)"
    } else if (input$select == 3) {
      display_data <- totals$BMI
      title = "Body-Mass Indexes"  
      ylabel <- "BMI"      
    } else {
      display_data <- totals$Age
      title = "Age"        
      ylabel <- "Age in Years"
    }
    
    p <- qplot(totals$Year, display_data,
               colour = factor(totals$Rookie),
               main = title,
               xlab = "Year",
               ylab = ylabel
    )
    p <- p + scale_x_continuous(breaks=seq(1950, 2010, 10))
    p <- p + theme(text = element_text(size=20), 
                   title = element_text(size=20))
    p <- p + stat_smooth(method="loess", aes(fill=factor(totals$Rookie)))
    print(p)     
  })
})
