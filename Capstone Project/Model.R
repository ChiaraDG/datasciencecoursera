#### MODELLING ####

#### Set directory and read data in (create sample data) ####
setwd("./Capstone Project")
source("Read Data.R")

# load packages
library(stringi)
library(quanteda)
library(data.table)

# remove unused dataset
rm(blogs); rm(twitter); rm(news); rm(select)

# build the courpus 
finalSample <- c(twitterSample, newsSample, blogsSample)
finalSample <- corpus(finalSample)

rm(blogsSample); rm(twitterSample); rm(newsSample)

#### Build n-gram function ####

ngram <- function(dat, n){
      # extract n-grams (n to be fixed by user)
      ngrams <- dfm(finalSample, toLower = T, removeNumbers = T, removePunct = T,
                    removeTwitter = T, stem = F, ngram = n, verbose  = T, ignoredFeatures=c(profanity))
      # take the list of all possible n-grams and save as a dataframe
      wordFreq <- topfeatures(ngrams, nfeature(ngrams))
      Word <- names(wordFreq)
      wordFreq <- data.frame(Word, wordFreq)
      rownames(wordFreq) <- NULL
      colnames(wordFreq) <- c("word","frequency")
      # delete _ between words and add a space if looking at n-grmans with n > 1
      if(n > 1){wordFreq$word <- gsub("_", " ", wordFreq$word)}
      # ouput the dataframe
      return(wordFreq)
}


#### Dataset with most common n-gram (from 4 to 1) ####

# 4-grams
ngramsdat4 <- ngram(finalSample, 4)
write.table(ngramsdat4,"ngramsdat4.csv",row.names = FALSE)

# 3-grams
ngramsdat3 <- ngram(finalSample, 3)
write.table(ngramsdat3,"ngramsdat3.csv",row.names = FALSE)

# 2-grams
ngramsdat2 <- ngram(finalSample, 2)
write.table(ngramsdat2,"ngramsdat2.csv",row.names = FALSE)

# 1-grams
ngramsdat1 <- ngram(finalSample, 1)
write.table(ngramsdat1,"ngramsdat1.csv",row.names = FALSE)


#### Prepare the input ####

input <- function(x, n){
      # remove any punctuation
      out <- gsub('[[:punct:]]', '', x) 
      # transform to lower case
      out <- tolower(out)
      # strip the string and take the last n - 2 word (n is the n-gram of interest)
      out <- unlist(strsplit(x, " "))
      if((length(out) - (abs(n - 2))) <= 0){
            # take all available
            out <- out
      } else {
            out <- out[(length(out) - (abs(n - 2))):length(out)]     
      }
      # put the selected words together
      out <- paste(out, collapse = " ")
      # add ^ and  to facilitate regular expression
      out <- paste(paste("^", out, sep = ""), "", sep = " ")
      return(out)
}


#### Build Text Prediction Algorithm ####

ngramsdat3 <- fread("ngramsdat3.csv", sep = " ")
ngramsdat2 <- fread("ngramsdat2.csv", sep = " ")
colnames(ngramsdat2) <- c("word","frequency")
ngramsdat1 <- fread("ngramsdat1.csv", sep = " ")
colnames(ngramsdat1) <- c("word","frequency")


# delete all n-grams with frequency less than 10
ngramsdat3 <- ngramsdat3[frequency > 10, ]
ngramsdat2 <- ngramsdat2[frequency > 10, ]
ngramsdat1 <- ngramsdat1[frequency > 10, ]

write.table(ngramsdat3,"ngramsdat3.csv",row.names = FALSE)
write.table(ngramsdat2,"ngramsdat2.csv",row.names = FALSE)
write.table(ngramsdat1,"ngramsdat1.csv",row.names = FALSE)

# and save as output
ngramsdat3 <- fread("ngramsdat3.csv", sep = " ")
ngramsdat2 <- fread("ngramsdat2.csv", sep = " ")
colnames(ngramsdat2) <- c("word","frequency")
ngramsdat1 <- fread("ngramsdat1.csv", sep = " ")
colnames(ngramsdat1) <- c("word","frequency")

x <- "Very early observations on the Bills game: Offense still struggling but the"


# start with 3-grams
sentence <- input(x, 3)      
# look for any 3-gram that starts with the sentence (ignore lower and upper case)
search <- ngramsdat3[which(grepl(sentence, ngramsdat3$word, ignore.case = T) == T),]
if(nrow(search) > 0){
      # if 3-gram found take the last words and look at how many are found in the dataset
      words <- strsplit(search$word, " ")
      tofind <- sapply(words, "[[", 3)
      twogramsfound <- c()
      for(i in 1:length(tofind)){
            twogramsfound[i] <- sum(ngramsdat2[which(grepl(tofind[i], ngramsdat2$word, ignore.case = T) == T),]$frequency)
      }
      search$twogramsfound <- twogramsfound
      search$prob <- search$frequency/search$twogramsfound
      search <- search[order(-search$prob),]
      words <- strsplit(search$word, " ")
      search$mostcommon <- sapply(words,"[[",3)
      # plot most probable words
      p <- ggplot(search, aes(x = reorder(mostcommon, prob), y = prob)) + 
            geom_bar(stat = "identity", color = "white", fill="blue") + theme_bw() +
            coord_flip() + ylab("Probability") + ggtitle("") + xlab("")
      # most probable words
      if(length(words) >= 3){
            print(c(words[[1]][3], words[[2]][3], words[[3]][3]))
            p
      } else {
            for(i in 1:length(words)){
                  print(c(words[[i]][3]))
                  p}
      }
} else {
      # look at 2-grams
      sentence <- input(x, 2)
      search <- ngramsdat2[which(grepl(sentence, ngramsdat2$word, ignore.case = T) == T),]
      if(nrow(search) > 0){
            # if 2-gram found take the last words and look at how many are found in the dataset
            # take only the first 50 words from search 
            search <- search[1:50,]
            words <- strsplit(search$word, " ")
            tofind <- sapply(words, "[[", 2)
            onegramsfound <- c()
            for(i in 1:length(tofind)){
                  onegramsfound[i] <- sum(ngramsdat1[which(grepl(tofind[i], ngramsdat1$word, ignore.case = T) == T),]$frequency)
            }
            search$onegramsfound <- onegramsfound
            search$prob <- 0.4*search$frequency/search$onegramsfound
            search <- search[order(-search$prob),]
            words <- strsplit(search$word, " ")
            search$mostcommon <- sapply(words,"[[",2)
            p <- ggplot(search, aes(x = reorder(mostcommon, prob), y = prob)) + 
                  geom_bar(stat = "identity", color = "white", fill="blue") + theme_bw() +
                  coord_flip() + ylab("Probability") + ggtitle("") + xlab("")
            if(length(words) >= 3){
                  print(c(words[[1]][2], words[[2]][2], words[[3]][2]))
                  p
            } else {
                  for(i in 1:length(words)){
                        print(c(words[[i]][2]))
                        p}
            }
      } else {
            print(ngramsdat1[1:3,])
            print("No match found. Three most common word returned")
      }
}