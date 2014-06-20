# http://www.rstudio.com/shiny/
#

library(shiny)
library(ggplot2)

shinyServer(function(input, output) {
  
  output$playersPlot <- renderPlot({         
    if (input$select == 1) {
      display_data <- totals$HeightInches
      title = "Height of Players"
      ylabel <- "Heigh (inches)"
      p <- ggplot(totals, aes(x=Year, y=HeightInches, colour=Rookie)) + geom_point()
    } else if (input$select == 2) {
      display_data <- totals$Wt
      title = "Weight of Players"        
      ylabel <- "Weight (lbs)"
      p <- ggplot(totals, aes(x=Year, y=Wt, colour=Rookie)) + geom_point()
      } else if (input$select == 3) {
      display_data <- totals$BMI
      title = "Body-Mass Indexe of Players"  
      ylabel <- "BMI"
      p <- ggplot(totals, aes(x=Year, y=BMI, colour=Rookie)) + geom_point()      
    } else {
      display_data <- totals$Age
      title = "Age of Players"
      ylabel <- "Age (years)"
      p <- ggplot(totals, aes(x=Year, y=Age, colour=Rookie)) + geom_point()    
    }
    
    p <- p + scale_color_manual(values=c("red", "blue"))
    p <- p + stat_smooth(method="loess")
    p <- p + ggtitle(title) + ylab(ylabel)
    p <- p + labs(colour = "Players")
    p <- p + scale_x_continuous(breaks=seq(1950, 2010, 10))
    p <- p + theme(text = element_text(size=20), 
                   title = element_text(size=20))
    print(p)
  })
})
