# Load packages and import data
library(dplyr)
dat <- read.csv("./Developing Data Products/Playing with Plotly/FoodFacts.csv")

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

# A food is classified as 'less healthy' where it scores 4 points or more.
totIntakes$healthy <- ifelse(abs(totIntakes$meanScore) >= 4, "unhealthy", "healthy")


# save the dataset
write.table(totIntakes, "Intakes.csv")
