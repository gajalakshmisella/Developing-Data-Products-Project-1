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
      if (input$show_rookies) {
        p <- ggplot(totals, aes(x=Year, y=HeightInches, colour=Rookie)) + geom_point()
        p <- p + scale_color_manual(values=c("blue", "red"))
      } else {
        p <- ggplot(totals[totals$Rookie=="Everyone",], aes(x=Year, y=HeightInches)) + geom_point(colour="blue")        
      }
    } else if (input$select == 2) {
      display_data <- totals$Wt
      title = "Weight of Players"        
      ylabel <- "Weight (lbs)"
      if (input$show_rookies) {
        p <- ggplot(totals, aes(x=Year, y=Wt, colour=Rookie)) + geom_point()
        p <- p + scale_color_manual(values=c("blue", "red"))
      } else {
        p <- ggplot(totals[totals$Rookie=="Everyone",], aes(x=Year, y=Wt)) + geom_point(colour="blue")        
      }
    } else if (input$select == 3) {
      display_data <- totals$BMI
      title = "Body-Mass Indexe of Players"  
      ylabel <- "BMI"
      if (input$show_rookies) {
        p <- ggplot(totals, aes(x=Year, y=BMI, colour=Rookie)) + geom_point()
        p <- p + scale_color_manual(values=c("blue", "red"))
      } else {
        p <- ggplot(totals[totals$Rookie=="Everyone",], aes(x=Year, y=BMI)) + geom_point(colour="blue")        
      }
    } else {
      display_data <- totals$Age
      title = "Age of Players"
      ylabel <- "Age (years)"
      if (input$show_rookies) {
        p <- ggplot(totals, aes(x=Year, y=Age, colour=Rookie)) + geom_point()
        p <- p + scale_color_manual(values=c("blue", "red"))
      } else {
        p <- ggplot(totals[totals$Rookie=="Everyone",], aes(x=Year, y=Age)) + geom_point(colour="blue")        
      }
    }
    
    p <- p + stat_smooth(method="loess")
    p <- p + ggtitle(title) + ylab(ylabel)
    p <- p + labs(colour = "Players")
    p <- p + scale_x_continuous(breaks=seq(1950, 2010, 10))
    p <- p + theme(text = element_text(size=20), 
                   title = element_text(size=20))
    print(p)
  })
})
