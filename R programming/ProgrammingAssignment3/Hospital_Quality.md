# Assignment 3: Hospital Quality
Chiara Di Gravio  
27 maggio 2016  



## Assignment 3: Hospital Quality

The [Hospital Compare web site](http://hospitalcompare.hhs.gov), run by the U.S. Department of Health and Human Services, provides data and information about the quality of care at over 4,000 Medicare-certified hospitals in the U.S. Here we focused on three outcomes:

- heart attack

- heart failure

- pneumonia

and we look at which hospital has the lower death rate. The function needed for this assignment can be found in [ProgrammingAssignment3.R](https://github.com/ChiaraDG/datasciencecoursera/blob/master/R%20programming/ProgrammingAssignment3/ProgrammingAssignment3.R). First we look at the hospital that has the best (i.e. lowest) 30-day mortality for one of the three outcomes listed above in a pre-specified State.


```r
source("ProgrammingAssignment3.R")
```

For instance if we are interested in Texas:


```r
best("TX","heart attack")
```

```
## [1] "CYPRESS FAIRBANKS MEDICAL CENTER"
```

```r
best("TX","heart failure")
```

```
## [1] "FORT DUNCAN MEDICAL CENTER"
```

```r
best("TX", "pneumonia")
```

```
## [1] "UNIVERSITY OF TEXAS HEALTH SCIENCE CENTER AT TYLER"
```

or if we want to look at the best hospitals in New Jersery:


```r
best("NJ","heart attack")
```

```
## [1] "EAST ORANGE GENERAL HOSPITAL"
```

```r
best("NJ","heart failure")
```

```
## [1] "EAST ORANGE GENERAL HOSPITAL"
```

```r
best("NJ", "pneumonia")
```

```
## [1] "ENGLEWOOD HOSPITAL AND MEDICAL CENTER"
```

Second, we rank the hospitals by outcome in each state. For instance, the 5 hospitals in Texas with lower 30-day mortality rate for pneumonia are:


```r
best5 <- rankhospital("TX", "heart failure", 1:5)
data.frame(best = best5)
```

```
##                               best
## 1       FORT DUNCAN MEDICAL CENTER
## 2  TOMBALL REGIONAL MEDICAL CENTER
## 3 CYPRESS FAIRBANKS MEDICAL CENTER
## 4           DETAR HOSPITAL NAVARRO
## 5           METHODIST HOSPITAL,THE
```

whereas the worst hospital in Texas for pneumonia (i.e. hospital with highest 30-day mortality rate) is:


```r
rankhospital("TX", "pneumonia", "worst")
```

```
## [1] "LIMESTONE MEDICAL CENTER"
```

Finally, we look at which hospital in each State has a pre-specified ranking for the outcome of interest. For instance, the three hospitals that have the highest pneumonia 30-day mortality rate within their State are:


```r
tail(rankall("pneumonia","worst"),3)
```

```
##                                      hospital state
## 52 MAYO CLINIC HEALTH SYSTEM - NORTHLAND, INC    WI
## 53                     PLATEAU MEDICAL CENTER    WV
## 54           NORTH BIG HORN HOSPITAL DISTRICT    WY
```

whereas three hospitals that have the lowest pneumonia 30-day mortality rate within their Statse are:


```r
head(rankall("pneumonia","best"),3)
```

```
##                             hospital state
## 1 YUKON KUSKOKWIM DELTA REG HOSPITAL    AK
## 2      MARSHALL MEDICAL CENTER NORTH    AL
## 3        STONE COUNTY MEDICAL CENTER    AR
```
