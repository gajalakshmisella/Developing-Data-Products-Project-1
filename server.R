# http://www.rstudio.com/shiny/
#

library(shiny)
library(ggplot2)

# read in the player data and mangle it into right form
# aggreagte means of height, weight, bmi and age of rookia players
# are stored in totals data frame

colnames(players)[7] <- "Birth.Date"
players$Birth.Date <- as.Date(players$Birth.Date, format = "%B %d, %Y")
players$From <- as.numeric(players$From)
players$To <- as.numeric(players$To)
players$Wt <- as.numeric(players$Wt)

# calculate how many years the player played
players$Career.Years <- as.numeric(players$To - players$From)

#Hall of famers
players$HOF <- 0
players$HOF[grep(".*\\*", players$Player, perl=TRUE)] <- 1

#Convert height  to inches
getHeight <- function(x) {
  real_ht <- unlist(strsplit(x[5], "-"));
  as.integer(real_ht[1]) * 12 + as.integer(real_ht[2]) 
}

players$HeightInches <- apply(players, 1, getHeight)
players$AgeRetired <- players$To - as.numeric(substr(players$Birth.Date,0,4))
players$RookieAge <- players$From - as.numeric(substr(players$Birth.Date,0,4))

# Some players don't have age, so retirement and rookie ages are left empty
# let's impute the values in a simple way - average start age as start age
# add career years to get retirement age

players$RookieAge[is.na(players$RookieAge)] <- round(mean(players$RookieAge, na.rm=T))
players$AgeRetired[is.na(players$AgeRetired)] <- players$RookieAge[is.na(players$AgeRetired)]  + players$Career.Years[is.na(players$AgeRetired)] 

# Pos indicates player position. Let's simplify and put two position
# players to the position that is mentioned first (assuming that was the primary position)
# and make it a proper factor

players$Pos <- substr(players$Pos,0,1)
players$Pos <-factor(players$Pos, levels=c("G", "F", "C"))

# lets add BMI to the stats too

players$BMI <- (as.numeric(players$Wt) * 703) / players$HeightInches^2

totals <- aggregate(cbind(HeightInches, Wt, RookieAge, BMI) ~ From, data = players, FUN = mean)

#source("players.R")

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
