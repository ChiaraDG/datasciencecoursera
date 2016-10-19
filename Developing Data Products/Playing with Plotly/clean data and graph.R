# Load packages and import data
library(dplyr)
library(plotly)
library(rworldmap)
dat <- read.csv("./Developing Data Products/FoodFacts.csv")

# Keep only the needed variables
keep <- c("countries_en", "fat_100g", "sugars_100g", "salt_100g","energy_100g", "main_category_en","nutrition_score_uk_100g")
dat <- dat[,names(dat) %in% keep]
# delete missing variables
dat <- na.omit(dat)
str(dat)

# Inspect countries, and rename levels of countries
# Look level that contains the word Europe
unique(dat$countries_en[grep("Europe", dat$countries_en)])
# rename French Europe as France
dat$countries_en[grep("France,fr:Europe", dat$countries_en)] <- "France"
# rename Spain Europe as Spain
dat$countries_en[grep("Spain,es:Europe", dat$countries_en)] <- "Spain"
# Rename European Union,France European Union as France
dat$countries_en[grep("European Union,France European Union", dat$countries_en)] <- "France"
# drop unused levels
dat$countries_en <- droplevels(dat$countries_en)
# rename Quebec as Canada
dat$countries_en[grep("fr:Quebec", dat$countries_en)] <- "Canada"
# eliminate those that are no countries
nocountries <- c("en:dairies","en:fresh-foods", "fr:yaourt-veloute-aux-fruits", "fr:\346\227\245\346\234\254", "\346\227\245\346\234\254","R<c3><a9>union","European Union")
dat <- dat[!(dat$countries_en %in% nocountries),]
# drop levels
dat$countries_en <-  droplevels(dat$countries_en)
# inspect countries
levels(dat$countries_en)
# keep only the single countries
dat <- dat[-grep(",", dat$countries_en), ]
dat$countries_en <- droplevels(dat$countries_en)
# eliminate missing countries
dat <- dat[dat$countries_en != "",]
dat$countries_en <- droplevels(dat$countries_en)

# Look at food category
# drop if main_category_en = ""
dat <- dat[dat$main_category_en != "",]
# drop main category in french
dat <- dat[-grep("fr:", dat$main_category_en),]
dat$main_category_en <- droplevels(dat$main_category_en)

# Number of observations per countries
countriesNobs <- dat %>% group_by(countries_en) %>% summarise(n = n()) %>% arrange(desc(n))
# Take the top 10 only and work with those
top10 <- countriesNobs$countries_en[1:10]
top10 <- droplevels(top10)
dat <- dat[dat$countries_en %in% top10,]
dat$countries_en <- droplevels(dat$countries_en)
# rename countries_en as country
names(dat)[names(dat) == "countries_en"] <- "country"
names(countriesNobs)[names(countriesNobs) == "countries_en"] <- "country"


# For each country and food category compute: total energy, total fat, total sugar, total salt, mean
# nutrition score
totIntakes <- dat %>% 
      group_by(country,main_category_en) %>% 
      summarise(totEnergy = sum(energy_100g), totFat = sum(fat_100g), totSugar = sum(sugars_100g), 
                totSalt = sum(salt_100g), meanScore = mean(nutrition_score_uk_100g))

#### PLOT 1: plot total energy by country ####

p <- ggplot(totIntakes, aes(x = country, y = totEnergy, fill = country)) + 
      geom_boxplot() + scale_y_log10() + theme_bw() + ylab("Total Energy (log-scale)") +
      theme(axis.text.x=element_text(size = 9), axis.text.y=element_text(size = 9,angle=90, hjust=1))
ggplotly(p)


#### MAP 1: map of 10 countries color coded by number of observations and average energy intake ####

# take only the top 10 countries
countriesNobs <- countriesNobs[1:10,]
#join to a coarse resolution map
spdf <- joinCountryData2Map(countriesNobs, joinCode="NAME", nameJoinColumn="country")
mapDevice(rows = 2, columns = 1, height = 1)
# color coded by number of aobservation
mapCountryData(spdf, nameColumnToPlot="n",mapTitle = "Number of Observations")
# compute average energy intake by country and store them into a dataframe
avgIntakes <- totIntakes %>% group_by(country) %>% summarise(AverageEnergyIntake = mean(totEnergy))
# rename country as country
names(avgIntakes)[names(avgIntakes) == "country"] <- "country"
#join to a coarse resolution map
spdf <- joinCountryData2Map(avgIntakes, joinCode="NAME", nameJoinColumn="country")
# color coded by average energy intake
mapCountryData(spdf, nameColumnToPlot="AverageEnergyIntake",mapTitle = "Average Energy Intake")

#### PLOT 2: what about relation between energy and sugar intake? ####

# create a dataframe with total sugar and total energy for each country
SugarEnergy <- totIntakes %>% group_by(country) %>% select(totSugar, totEnergy)
p2 <- ggplot(SugarEnergy, aes(x = totSugar, y = totEnergy, col = country)) + geom_point() + scale_y_log10() +
     scale_x_log10() + theme_bw() + scale_color_brewer(palette="Set3") + xlab("Total Sugar (log-scale)") +
     ylab("Total Energy (log-scale)") + ggtitle("Relation between Energy and Sugar Intake")
ggplotly(p2)


#### PLOT 3: where does the sugar come from? Sugar Intakes by category ###

# compute the total sugar intakes by food category and store them in a dataset
GroupIntakes <- totIntakes %>% group_by(main_category_en) %>% select(totSugar) %>% arrange(desc(totSugar))
# take only the food group with higher sugar intake and remove unused levels
GroupIntakes10 <- GroupIntakes[1:10,]
GroupIntakes10$main_category_en <- droplevels(GroupIntakes10$main_category_en)
# rename category variable
names(GroupIntakes10)[names(GroupIntakes10) == "main_category_en"] <- "category"
# plot
p3 <- ggplot(GroupIntakes10, aes(category, totSugar)) + geom_bar(stat = "identity") + 
      ggtitle("Food Category by Total Sugar Intake") + theme_bw() + xlab("") + ylab("") +
      theme(axis.text.x=element_text(angle=45, hjust=1, size = 7), axis.text.y=element_text(size = 7))
ggplotly(p3)


