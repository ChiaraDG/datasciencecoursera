#### EXPLORATORY DATA ANALYSIS ####

#### Set directory and read data in (create sample data) ####
setwd("./Capstone Project")
source("Read Data.R")

# load packages
library(stringi)
library(quanteda)
library(ggplot2)

# Number of words and number of lines in each set
data.frame(source = c("Twitter","News","Blogs"), 
           Lines.Total = c(length(twitter), length(news), length(blogs)),  
           Words.Total = c(sum(stri_count_words(twitter)),sum(stri_count_words(news)),sum(stri_count_words(blogs))))

# remove unused dataset
rm(blogs); rm(twitter); rm(news); rm(select)

# build a courpus for each source and put them together
finalSample <- c(twitterSample, newsSample, blogsSample)
finalSample <- corpus(finalSample)

# add source
docvars(finalSample, "source") <- c(rep("Twitter", length(twitterSample)),rep("news", length(newsSample)),
                                    rep("Blogs", length(blogsSample)))
summary(finalSample, n = 5)
summary(subset(finalSample, source == "Twitter"), n = 5)
summary(subset(finalSample, source == "Blogs"), n = 5)
summary(subset(finalSample, source == "news"), n = 5)
# final data is ~0.01% of original data. Half of those comes from twitter.

# remove separate files
rm(twitterSample); rm(newsSample); rm(blogsSample)

#### Cleaning and Exploring data ####

# need to add will in ignored features as it is not in the stopword list
top1word <- dfm(finalSample, toLower = T, removeNumbers = T, removePunct = T,
                     removeTwitter = T, stem = F, ignoredFeatures = c("will",stopwords("english")))
top1word

# 10 most frequent words
top10 <- data.frame(topfeatures(top1word, 10))  
Word <- rownames(top10)
top10 <- data.frame(Word, top10)
rownames(top10) <- NULL
colnames(top10) <- c("word","frequency")
top10
ggplot(top10, aes(x = reorder(word, frequency), y = frequency)) + geom_bar(stat = "identity") + theme_bw() +
      coord_flip() + ylab("") + ggtitle("Top 10 most common words") + xlab("")

#### how many words are needed to cover 50%? and 90%? ####
wordFreq <- topfeatures(top1word, n = 141347)
coverage <- function(perc, x){
      sum(cumsum(x) < sum(x)*perc)
}

p <- seq(0,1,0.01)
wordsNeed <- c()
for(i in 1:length(p)){
      wordsNeed[i] <- coverage(p[i], wordFreq)
}

dat <- data.frame(words = wordsNeed, coverage = p) 
ggplot(dat, aes(x = wordsNeed, y = p)) + geom_line() + xlab("Number of unique words needed") +
      ylab("Percentage of vocabulary needed") + theme_bw() + ggtitle("Number of words to cover the vocabulary") +
      geom_vline(xintercept = coverage(0.5, wordFreq), col = "red") + 
      geom_vline(xintercept = coverage(0.9, wordFreq), col = "blue") + 
      annotate("text", x = 4000, y = 0.25, label = coverage(0.5, wordFreq), col = "red", angle = 90) +
      annotate("text", x = 20000, y = 0.25, label = coverage(0.9, wordFreq), col = "blue", angle = 90)

rm(top1word); rm(wordFreq)
#### What are the frequencies of 2-grams and 3-grams in the dataset? ####

# 2-grams
top2word <- dfm(finalSample, toLower = T, removeNumbers = T, removePunct = T,
                removeTwitter = T, stem = F, ignoredFeatures = c("will",stopwords("english")),
                ngram = 2)
top2word
# 10 most frequent 2gram
top102gram <- data.frame(topfeatures(top2word, 10))  
Word <- rownames(top102gram)
top102gram <- data.frame(Word, top102gram)
rownames(top102gram) <- NULL
colnames(top102gram) <- c("word","frequency")
top102gram$word <- gsub("_", " ", top102gram$word )
top102gram

ggplot(top102gram, aes(x = reorder(word, frequency), y = frequency)) + geom_bar(stat = "identity") + theme_bw() +
      coord_flip() + ylab("") + ggtitle("Top 10 most common 2-grams") + xlab("")

rm(top2word)
# 3-grams
top3word <- dfm(finalSample, toLower = T, removeNumbers = T, removePunct = T,
                removeTwitter = T, stem = F, ignoredFeatures = c("'","will",stopwords("english")),
                ngram = 3)
top3word

# 10 most frequent 3gram
top103gram <- data.frame(topfeatures(top3word, 10))  
Word <- rownames(top103gram)
top103gram <- data.frame(Word, top103gram)
rownames(top103gram) <- NULL
colnames(top103gram) <- c("word","frequency")
top103gram$word <- gsub("_", " ", top103gram$word)
top103gram

ggplot(top103gram, aes(x = reorder(word, frequency), y = frequency)) + geom_bar(stat = "identity") + theme_bw() +
      coord_flip() + ylab("") + ggtitle("Top 10 most common 3-grams") + xlab("")

