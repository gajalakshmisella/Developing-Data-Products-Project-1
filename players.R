library(XML)

# can read a stored file on shiny server, so read the data in every time....
#players <- read.csv("nba_players.csv")

urls <- paste0("http://www.basketball-reference.com/players/",letters,"/")

# remove X, no player names start with that letter
urls <- urls[-24]
players <- {}

for (i in 1:length(urls) ) {
  players <- rbind(players, readHTMLTable(urls[i])[[1]])
}

### we now have the raw data read into players data frame

# set the features to the right type
players$Birth.Date <- as.Date(players$Birth.Date, format = "%B %d, %Y")
players$From <- as.numeric(players$From)
players$To <- as.numeric(players$To)

# calculate how many years the player played
players$Career.Years <- players$To - players$From

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

players$BMI <- (players$Wt * 703) / players$HeightInches^2

totals <- aggregate(. ~ From, players, mean)

# remove players that are still active
#active_players <- players[players$To == 2014,]
#players <- players[players$To != 2014,]


#qplot(From, HeightInches, data = totals) + stat_smooth()
#qplot(From, Wt, data = totals) + stat_smooth()
#qplot(From, RookieAge, data = totals) + stat_smooth()
#qplot(From, BMI, data = totals) + stat_smooth()
