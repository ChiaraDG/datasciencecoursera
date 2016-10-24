World Food Facts
========================================================
author: Chiara Di Gravio
date: October 24, 2010
autosize: true


The Data
========================================================

## World Food Facts

- The data is taken from the [Kaggle](https://www.kaggle.com/datasets) website.

- The data contains nutrition facts from different food sources.

- The 10 more represented countries in the data (Australia, Belgium, France, Germany, Italy, Portugal, Spain, Switzerland, United Kingdom and United States) are chosen and a detailed analysis is performed. 

- The code used to clean the data can be found [here](https://github.com/ChiaraDG/datasciencecoursera/blob/master/Developing%20Data%20Products/WorldFoodFacts/data%20cleaning.R)


A Peak into the Data
========================================================


```r
dat <- read.csv("Intakes.csv", sep = "")
str(dat)
```

```
'data.frame':	891 obs. of  8 variables:
 $ country         : Factor w/ 10 levels "Australia","Belgium",..: 1 1 1 1 1 1 1 1 1 1 ...
 $ main_category_en: Factor w/ 691 levels "Aliment-en-conserve",..: 3 5 6 7 8 14 17 18 22 23 ...
 $ totEnergy       : num  2400 239 301 1690 572 ...
 $ totFat          : num  37.3 3 4 0.5 1 2.5 0.1 0.5 17 15.1 ...
 $ totSugar        : num  47.1 3 3 90 24.3 0.5 94.9 4.3 1 0.6 ...
 $ totSalt         : num  0.1196 0.2921 0.3048 0.0229 9.4996 ...
 $ meanScore       : num  27 1 1 15 16 -6 22 -5 3 14 ...
 $ healthy         : Factor w/ 2 levels "healthy","unhealthy": 2 1 1 2 2 2 2 2 1 2 ...
```


The Shiny App
========================================================

- The Shiny App allows the user to summarise intakes of the selected variable in the chosen country and to show whether the aforementioned variable is associated with the food being healthy or not. 

- The first panel (Summary) shows, the histogram, the summary statistics for the chosen variable as well as the dataset used for deriving both. 

- The second panel (Predict Healthy/Unhealthy Food) shows the results of a logistic regression where beign healthy/unhealthy is the outcome of interest and the selected variable is the only predictor. All the analyses are done by single country.

The App and the Code
========================================================

- The App can be found [here](https://chiaradg.shinyapps.io/WorldFoodFacts/)

- The App was generated using two file: [ui.R](https://github.com/ChiaraDG/datasciencecoursera/blob/master/Developing%20Data%20Products/WorldFoodFacts/ui.R) and [server.R](https://github.com/ChiaraDG/datasciencecoursera/blob/master/Developing%20Data%20Products/WorldFoodFacts/server.R)
