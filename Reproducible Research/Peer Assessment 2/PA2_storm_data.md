# The Impact of Severe Weather Events on Health and Economics



## Synopsis

Storms and other severe weather events can cause both public health and economic problems. The U.S. National Oceanic and Atmospheric Administration's (NOAA) storm database gives us an opportunity to track characteristics of major weather events in the United States as well as their consequences on people and properties.

In this project we explore the NOAA database to understand which are the weather events that lead to the greatest public health and economic consequences. We found that tornadoes and heat caused the most fatalities and injuries, floods and hurricane had a negative impact on property and crop. 


## Loading and Processiong the Raw Data

The dataset was downloaded and imported directly from the course website. Documentation on the dataset, including how the variables were constructed is available at:

- [National Weather Service Storm Data Documentation](https://d396qusza40orc.cloudfront.net/repdata%2Fpeer2_doc%2Fpd01016005curr.pdf)

- [National Climatic Data Center Storm Events FAQ](https://d396qusza40orc.cloudfront.net/repdata%2Fpeer2_doc%2FNCDC%20Storm%20Events-FAQ%20Page.pdf)



```r
library(dplyr)
library(ggplot2)
library(knitr)
library(maps)
```


```r
# To run only the first time

# if(!file.exists("data")){
#  dir.create("data")
#}

# fileUrl <- "https://d396qusza40orc.cloudfront.net/repdata%2Fdata%2FStormData.csv.bz2"
# download.file(fileUrl, destfile = "./Reproducible Research/Peer Assessment 2/data/stormdata.csv.bz2", method = "curl")
```


```r
dat <- read.csv("./data/stormdata.csv.bz2", na.strings ="?")
```

The dataset has 902297 observations and 37 variables. First, we fix the event type variable. Events that are the same were registered under different names (e.g. Beach Erosion and BEACH EROSION). We transform all the event type in uppercase, delete unnecessary spaces, plurals, synonyms, and correct spelling mistakes.


```r
# clean event type

# write every event in upper case
dat$EVTYPE <- as.factor(toupper(trimws(dat$EVTYPE, which = "left")))

# put abnormal warmth and excessive heat together
dat$EVTYPE[dat$EVTYPE == "ABNORMAL WARMTH" | dat$EVTYPE == "EXTREME HEAT"] <- "EXCESSIVE HEAT"

# fix spelling mistakes and unnecessary plurals
dat$EVTYPE[dat$EVTYPE == "AVALANCE"] <- "AVALANCHE"
dat$EVTYPE[grep("BEACH ER", dat$EVTYPE)] <- "BEACH EROSION"
dat$EVTYPE[grep("BITTER WIND CHILL", dat$EVTYPE)] <- "BITTER WIND CHILL TEMPERATURES"
dat$EVTYPE[grep("BLOW-OUT TIDES", dat$EVTYPE)] <- "BLOW-OUT TIDE"
dat$EVTYPE[grep("DUST DEVEL", dat$EVTYPE)] <- "DUST DEVIL"
dat$EVTYPE[grep("BRUSH FIRES", dat$EVTYPE)]<- "BRUSH FIRE"
dat$EVTYPE[grep("VOLCANIC ASH+", dat$EVTYPE)] <- "VOLCANIC ASH"
dat$EVTYPE[grep("COASTALSTORM", dat$EVTYPE)] <- "COASTAL STORM"
dat$EVTYPE[c(grep("WATER SPOUT", dat$EVTYPE),grep("WAYTERSPOUT", dat$EVTYPE))]<-  "WATERSPOUT"
dat$EVTYPE[grep("RIP CURRENT+", dat$EVTYPE)] <- "RIP CURRENTS"
dat$EVTYPE[grep("DUSTSTORM", dat$EVTYPE)] <- "DUST STORM"
dat$EVTYPE[grep("EXCESSIVE WETNESS", dat$EVTYPE)] <- "EXTREMELY WET"
dat$EVTYPE[grep("HYPOTHERMIA+", dat$EVTYPE)] <- "HYPOTHERMIA"

# put together same events (based on event description)
dat$EVTYPE[grep("BLIZZARD+", dat$EVTYPE)] <- "BLIZZARD"
dat$EVTYPE[grep("HAIL+", dat$EVTYPE)] <- "HAIL"
dat$EVTYPE[grep("BLOWING SNOW+", dat$EVTYPE)] <- "BLOWING SNOW"
dat$EVTYPE[grep("COLD+", dat$EVTYPE)] <- "COLD"
dat$EVTYPE[grep("DRY+", dat$EVTYPE)] <- "DRY"
dat$EVTYPE[grep("FROST+", dat$EVTYPE)] <- "FROST"
dat$EVTYPE[grep("FUNNEL+", dat$EVTYPE)] <- "FUNNEL"

dat$EVTYPE[c(grep("FLASH FLOOD+", dat$EVTYPE),grep("FLOOD+", dat$EVTYPE))] <- "FLOOD"
dat$EVTYPE[c(grep("FREEZING DRIZZLE+", dat$EVTYPE),grep("FREEZING RAIN+", dat$EVTYPE))] <- "FREEZING RAIN"
dat$EVTYPE[c(grep("FROST", dat$EVTYPE),grep("FREEZE", dat$EVTYPE))] <- "FROST/FREEZE"
dat$EVTYPE[c(grep("LIGHTN+", dat$EVTYPE), grep("LIGHTNING", dat$EVTYPE),
             grep("LIGNTNING", dat$EVTYPE),grep("LIGHTING", dat$EVTYPE))]<- "LIGHTNING"

dat$EVTYPE[grep("HEAVY SNOW+", dat$EVTYPE)] <- "HEAVY SNOW"
dat$EVTYPE[c(grep("HEAVY RAIN+", dat$EVTYPE), grep("URBAN+", dat$EVTYPE),
             grep("HEAVY PRECIP+", dat$EVTYPE),grep("HVY RAIN", dat$EVTYPE),
             grep("TORRENTIAL RAIN+", dat$EVTYPE),grep("EXCESSIVE RAIN+", dat$EVTYPE),
             grep("EXCESSIVE PRECIPITATION", dat$EVTYPE),
             grep("RAIN (HEAVY)",dat$EVTYPE),grep("HEAVY SHOW+",dat$EVTYPE),
             grep("SMALL STREAM AND", dat$EVTYPE),grep("SML STREAM FLD", dat$EVTYPE))] <- "HEAVY RAIN"

dat$EVTYPE[grep("HEAT+", dat$EVTYPE)] <- "EXCESSIVE HEAT"
dat$EVTYPE[grep("SLEET+", dat$EVTYPE)] <- "SLEET"
dat$EVTYPE[grep("SNOW+", dat$EVTYPE)] <- "SNOW"
dat$EVTYPE[grep("LOW TEMPERATURE+", dat$EVTYPE)] <- "LOW TEMPERATURE"

dat$EVTYPE[c(grep("THUNDERSTORM+", dat$EVTYPE),grep("THUDERSTORM+", dat$EVTYPE),
             grep("THUNDERESTORM+",dat$EVTYPE),grep("THUNDEERSTORM+",dat$EVTYPE),
             grep("TSTM+",dat$EVTYPE),grep("THUNDERSTROM+",dat$EVTYPE),
             grep("THUNDERTORM+",dat$EVTYPE), grep("THUNDERTSORM+",dat$EVTYPE),
             grep("THUNDESTORM+",dat$EVTYPE), grep("THUNERSTORM+",dat$EVTYPE))] <- "THUNDERSTORM"

dat$EVTYPE[grep("THUNDERSNOW+ ", dat$EVTYPE)] <- "THUNDERSNOW"
dat$EVTYPE[c(grep("TORNADO+", dat$EVTYPE), grep("TORNAO", dat$EVTYPE),
             grep("TORNDAO", dat$EVTYPE))] <- "TORNADO"
dat$EVTYPE[grep("TROPICAL STORM+", dat$EVTYPE)]<- "TROPICAL STORM"

dat$EVTYPE[grep("WATERSPOUT+", dat$EVTYPE)] <- "WATERSPOUT"
dat$EVTYPE[c(grep("WILD+", dat$EVTYPE), grep("FOREST FIRES",dat$EVTYPE))]<- "WILDFIRES"
dat$EVTYPE[c(grep("WIND+", dat$EVTYPE), grep("WND", dat$EVTYPE))] <- "WIND"
dat$EVTYPE[c(grep("WINTER+", dat$EVTYPE),grep("WINTRY MIX",dat$EVTYPE))] <- "WINTER WEATHER"
dat$EVTYPE[c(grep("UNSEASONABLY HOT+", dat$EVTYPE),grep("UNUSUAL HOTTH", dat$EVTYPE),
             grep("UNUSUALLY HOT", dat$EVTYPE),
             grep("UNUSUAL/RECORD HOTTH", dat$EVTYPE))]<- "UNSEASONABLY HOT"

dat$EVTYPE[grep("UNSEASONABLY COOL+", dat$EVTYPE)]<- "UNSEASONABLY COOL"
dat$EVTYPE[c(grep("MUD SLIDES", dat$EVTYPE),grep("MUD/ROCK SLIDE", dat$EVTYPE),
             grep("MUDSLIDE+", dat$EVTYPE))]<- "MUD SLIDE"

dat$EVTYPE[grep("GUSTNADO+", dat$EVTYPE)] <- "GUSTNADO"
dat$EVTYPE[grep("HURRICANE+", dat$EVTYPE)] <- "HURRICANE"
dat$EVTYPE[grep("GLAZE+", dat$EVTYPE)]<-  "GLAZE ICE" 

# delete summary event
dat <- dat[-c(grep("SUMMARY", dat$EVTYPE)), ]

# delete type = "EXCESSIVE", "HIGH" and "SOUTHEAST" as there is no information on whether it is excessiove cold or heat
dat <- subset(dat, EVTYPE != "EXCESSIVE")
dat <- subset(dat, EVTYPE != "HIGH")
dat <- subset(dat, EVTYPE != "SOUTHEAST")

# drop NONE and "NO SEVERE WEATHER" 
dat <- subset(dat, EVTYPE != "NONE")
dat <- subset(dat, EVTYPE != "NO SEVERE WEATHER")

# change reamining synomyns
dat$EVTYPE <- gsub("WARM", "HOT",dat$EVTYPE)
dat$EVTYPE <- gsub("HIGH ", "HEAVY ",dat$EVTYPE)
dat$EVTYPE <- as.factor(dat$EVTYPE)

# last change on plurals and same event
dat$EVTYPE[grep("HEAVY  SWELLS", dat$EVTYPE)]<-  "HEAVY SWELLS" 
dat$EVTYPE[grep("HEAVY SURF+", dat$EVTYPE)]<-  "HEAVY SURF" 
dat$EVTYPE[c(grep("RECORD HEAVY TEMPERATURE+", dat$EVTYPE),grep("RECORD HIGH", dat$EVTYPE),
             grep("RECORD HOT+", dat$EVTYPE),
             grep("RECORD HOTTH", dat$EVTYPE),grep("UNSEASONABLY HOT+", dat$EVTYPE),
             grep("UNUSUAL HOTTH", dat$EVTYPE),grep("VERY HOT",dat$EVTYPE))]<- "UNUSUALLY HOT"

# put hurricane and thypoon under the hurricane categories since they are classified as the same event in NOAA
dat$EVTYPE[c(grep("HURRICANE", dat$EVTYPE),grep("TYPHOON", dat$EVTYPE))] <-  "HURRICANE" 
dat$EVTYPE[grep("LANDSLIDES", dat$EVTYPE)]<-  "LANDSLIDE"
dat$EVTYPE[grep("WET MIC+", dat$EVTYPE)]<-  "WET MICROBURST"
dat$EVTYPE[grep("STORM SURGE+", dat$EVTYPE)]<-  "STORM SURGE" 

dat$EVTYPE <- droplevels(dat$EVTYPE)
```

After cleaning and regrouping events, we have 145 storm and other severe events (still higher than the events reported in the documentation). The most common events recorded are:


```r
kable(tail(dat %>% group_by(EVTYPE) %>% summarise(n_obs = n()) %>% arrange((n_obs))))
```



EVTYPE             n_obs
---------------  -------
WINTER WEATHER     19690
WIND               26554
TORNADO            60699
FLOOD              82729
HAIL              290401
THUNDERSTORM      335679

The variables FATALITIES and INJURIES reports the number of fatalities and injuries respectively. We can see that those are coded as numeric variables, and we can briefly look at summary statistics to check whether there is something problematic


```r
class(dat$FATALITIES)
```

[1] "numeric"

```r
class(dat$INJURIES)
```

[1] "numeric"

```r
summary(dat$FATALITIES)
```

    Min.  1st Qu.   Median     Mean  3rd Qu.     Max. 
  0.0000   0.0000   0.0000   0.0168   0.0000 583.0000 

```r
summary(dat$INJURIES)
```

     Min.   1st Qu.    Median      Mean   3rd Qu.      Max. 
   0.0000    0.0000    0.0000    0.1558    0.0000 1700.0000 

```r
dat$EVTYPE[which.max(dat$INJURIES)]
```

[1] TORNADO
145 Levels: ABNORMALLY WET APACHE COUNTY ... WINTER WEATHER

```r
dat$EVTYPE[which.max(dat$FATALITIES)]
```

[1] EXCESSIVE HEAT
145 Levels: ABNORMALLY WET APACHE COUNTY ... WINTER WEATHER

The variables PROPDMG, PROPDMGEXP and CROPDMG CROPDMGEXP summarizes damages to property and crop respectively. PROPDMGEXP and CROPDMGEXP represent the power of 10 that it is needed to convert PROPDMG and CROPDMG to their real values (for instance, H is hundreds, B billion and so on). However, those variables are summarised as factors; hence, first we need to transform them to numeric:


```r
class(dat$PROPDMGEXP)
```

```
## [1] "factor"
```

```r
levels(dat$PROPDMGEXP) 
```

```
##  [1] ""  "-" "+" "0" "1" "2" "3" "4" "5" "6" "7" "8" "B" "h" "H" "K" "m"
## [18] "M"
```

```r
table(dat$PROPDMGEXP)
```

```
## 
##             -      +      0      1      2      3      4      5      6 
## 465853      1      5    216     25     13      4      4     28      4 
##      7      8      B      h      H      K      m      M 
##      5      1     40      1      6 424664      7  11330
```

```r
# rename levels of a factor
levels(dat$PROPDMGEXP) <- c(rep(0,4),1:8,9,2,2,3,6,6)
table(dat$PROPDMGEXP)
```

```
## 
##      0      1      2      3      4      5      6      7      8      9 
## 466075     25     20 424668      4     28  11341      5      1     40
```

```r
# transform in numeric paying attention on the transformation
dat$PROPDMGEXP <- (as.numeric(as.character(dat$PROPDMGEXP))) 
table(dat$PROPDMGEXP)
```

```
## 
##      0      1      2      3      4      5      6      7      8      9 
## 466075     25     20 424668      4     28  11341      5      1     40
```

```r
class(dat$CROPDMGEXP)
```

```
## [1] "factor"
```

```r
levels(dat$CROPDMGEXP)
```

```
## [1] ""  "0" "2" "B" "k" "K" "m" "M"
```

```r
table(dat$CROPDMGEXP)
```

```
## 
##             0      2      B      k      K      m      M 
## 618331     19      1      9     21 281832      1   1994
```

```r
levels(dat$CROPDMGEXP) <- c(rep(0,2),2,9,3,3,6,6) 
table(dat$CROPDMGEXP)
```

```
## 
##      0      2      9      3      6 
## 618350      1      9 281853   1995
```

```r
# transform in numeric paying attention on the transformation
dat$CROPDMGEXP <- (as.numeric(as.character(dat$CROPDMGEXP)))
table(dat$CROPDMGEXP)
```

```
## 
##      0      2      3      6      9 
## 618350      1 281853   1995      9
```

then, we can use them as powers to find the total damage


```r
dat$PROPDMG <- dat$PROPDMG*(10^dat$PROPDMGEXP)
dat$CROPDMG <- dat$CROPDMG*(10^dat$CROPDMGEXP)
```

## Results

#### Population health

To understand the impact of severe weather events on population health, we look at the number of injuries and fatalities each event causes. The tables below reports the top 10 event for fatalities and injuries respectively:


```r
# find events that caused either injuries or fatalities
df_injury <- dat %>% group_by(EVTYPE) %>% summarise(n_fatalities = sum(FATALITIES), n_injuries = sum(INJURIES)) %>% filter(n_fatalities > 0 | n_injuries > 0)

# takes the top 10 events that caused the most fatalities
fatalities10 <- tail(df_injury[order(df_injury$n_fatalities),],10)[ ,c("EVTYPE","n_fatalities")]

# reorder from the most damaging to the least damaging
fatalities10 <- fatalities10 %>% arrange(desc(n_fatalities))
kable(fatalities10)
```



EVTYPE            n_fatalities
---------------  -------------
TORNADO                   5636
EXCESSIVE HEAT            3138
FLOOD                     1525
LIGHTNING                  817
THUNDERSTORM               725
RIP CURRENTS               577
WIND                       471
COLD                       451
WINTER WEATHER             278
AVALANCHE                  225

```r
# repeat similar analysis but look at injuries
injuries10 <- tail(df_injury[order(df_injury$n_injuries),],10)[ ,c("EVTYPE","n_injuries")]
injuries10 <- injuries10 %>% arrange(desc(n_injuries))
kable(injuries10)
```



EVTYPE            n_injuries
---------------  -----------
TORNADO                91407
THUNDERSTORM            9447
EXCESSIVE HEAT          9224
FLOOD                   8604
LIGHTNING               5232
ICE STORM               1975
WINTER WEATHER          1953
WIND                    1910
WILDFIRES               1606
HAIL                    1467



```r
# put fatalities and injuries together to create plot
fatalities10 <- data.frame(fatalities10, consequence = "FATALITIES")
colnames(fatalities10) <- c("event", "n", "consequences")
injuries10 <- data.frame(injuries10, consequence = "INJURIES")
colnames(injuries10) <- c("event", "n", "consequences")
data_plot <- rbind(fatalities10, injuries10)
# reorder event type by number of events regardless of whether they are injuries or fatalities
data_plot$event <- factor(data_plot$event, levels = data_plot$event[order(data_plot$n)])

ggplot(data_plot , aes(x = event, y = n)) + geom_bar(stat = "identity") +
      facet_wrap(~ consequences, scale = "free") + 
      theme(axis.text.x = element_text(angle = 90, hjust = 1), 
            panel.background = element_rect(fill = "white"), 
            axis.line.x = element_line(colour = 'black', size=0.5, linetype='solid'),
            axis.line.y = element_line(colour = 'black', size=0.5, linetype='solid'))
```

![](PA2_storm_data_files/figure-html/unnamed-chunk-9-1.png)<!-- -->

Tornadoes cause the most fatalities and injuries, following tornadoes we find excessive heat and flood.

#### Economic consequences

The economic consequences of sever weather event was studied looking at damage on properties and crops. Specifically, for each event, we look at the total damage (summing all the reported values) and we list here the ten "more costly" events. For property damage we have:


```r
# find events that caused property damage
df_property <- dat %>% group_by(EVTYPE) %>% 
      summarise(tot_damage = sum(PROPDMG, na.rm = T)) %>% filter(tot_damage > 0)

# takes the top 10 events that caused the most damage to property
property10 <- tail(df_property[order(df_property$tot_damage),],10)

# reorder from the most damaging to the least damaging
property10 <- property10 %>% arrange(desc(tot_damage))
kable(property10)
```



EVTYPE              tot_damage
---------------  -------------
FLOOD             168212215835
HURRICANE          85256410010
TORNADO            57003318376
STORM SURGE        47964724000
HAIL               17622991537
THUNDERSTORM       11139179176
WILDFIRES           8496563500
TROPICAL STORM      7714390550
WINTER WEATHER      6716307751
WIND                6236995123

Floods and hurricanes caused the highest damage in term of property. For crop damage we can see that droughts and floods were the ones that caused most of the "more expensive" crop damage:


```r
# find events that caused property damage
df_crop <- dat %>% group_by(EVTYPE) %>% 
      summarise(tot_damage = sum(CROPDMG, na.rm = T)) %>% filter(tot_damage > 0)

# takes the top 10 events that caused the most damage to property
crop10 <- tail(df_crop[order(df_crop$tot_damage),],10)

# reorder from the most damaging to the least damaging
crop10 <- crop10 %>% arrange(desc(tot_damage))
kable(crop10)
```



EVTYPE             tot_damage
---------------  ------------
DROUGHT           13972566000
FLOOD             12380109100
HURRICANE          5506117800
ICE STORM          5022113500
HAIL               3114212873
FROST/FREEZE       1997061000
COLD               1416765550
THUNDERSTORM       1206853738
EXCESSIVE HEAT      904469280
HEAVY RAIN          803900900

Finally, to help localise the areas where severe weather events caused the most economic damage, we sum damage to crops and to properties by State and point on the US map which are the States that experience the highest economic damage.


```r
# find events that caused ecomonic damage
df_tot <- dat %>% group_by(STATE, EVTYPE) %>% 
      summarise(tot_crop = sum(CROPDMG, na.rm = T),tot_prop = sum(PROPDMG, na.rm = T)) %>%
      mutate(tot_damage = tot_crop + tot_crop) %>%
      filter(tot_damage > 0) 
df_10 <- tail(df_tot[order(df_tot$tot_damage),],10)
df_10$STATE <- droplevels(df_10$STATE)
# download states
all_states <- map(database = "state", col = "red", fill=T, namesonly=TRUE, plot = F)
# 10 most problematic data
df_10 <- tail(df_tot[order(df_tot$tot_damage),],10)
df_10$STATE <- droplevels(df_10$STATE)
# change levels to full name states for graph
levels(df_10$STATE) <- c("oklahoma", "louisiana", "north carolina:main", "nebraska", 
  "california", "florida","iowa", "illinois", "mississippi", "texas")
# map the 10 events with highest economic consequences
map(database = "state",col = c("white", "red")[1+(all_states %in% levels(df_10$STATE))],fill=T,
    main = "USA: 10 areas where severe weather events caused the most economic damage")
```

![](PA2_storm_data_files/figure-html/unnamed-chunk-12-1.png)<!-- -->

Oklahoma, Louisiana, North Carolina, Nebraska, California, Florida, Iowa, Illinois, Mississippi, Texas were the ones who had to pay an highest price in term of economic damage in the last 60 years.

## Conclusions

Tornadoes, heat and flood caused the most fatalities and injuries. Floods also had a negative impact on property and crop. Hurricane did not seem to have any major effect on population health; however, most of the economic damage (either crop or property) were caused by hurricane. 

The event that causes most of the economic damage happened for large part (7 out of 10 States) in the South and coastal areas were hurricane are more common.



The dataset was downloaded on:


```r
date()
```

```
## [1] "Thu Jun 30 19:59:41 2016"
```