library(shiny)
library(stringi)
library(quanteda)
library(data.table)
library(ggplot2)

#### Prepare the input ####

wordsplit <- function(x, n){
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
ngramsdat3 <- fread("ngramsdat3.csv", sep = " "); ngramsdat2 <- fread("ngramsdat2.csv", sep = " ")
ngramsdat1 <- fread("ngramsdat1.csv", sep = " ")

# Define server logic required to draw a histogram
shinyServer(function(input, output) {
  # 3 three most common words
  output$best3 <- renderPrint({
        # start with 3-grams
        sentence <- wordsplit(input$text, 3)      
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
              # most probable words
              if(length(words) >= 3){
                    print(data.frame(Word = c(words[[1]][3], words[[2]][3], words[[3]][3])))
              } else {
                          print(data.frame(Word = words[[1]][3]))
              }
        } else {
              # look at 2-grams
              sentence <- wordsplit(input$text, 2)
              search <- ngramsdat2[which(grepl(sentence, ngramsdat2$word, ignore.case = T) == T),]
              if(nrow(search) > 0){
                    # if 2-gram found take the last words and look at how many are found in the dataset
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
                    if(length(words) >= 3){
                          print(data.frame(Words = c(words[[1]][2], words[[2]][2], words[[3]][2])))
                    } else {
                          print(data.frame(Word = words[[1]][2]))}
              } else {
                    print(data.frame(Word = ngramsdat1$word[1:3]))
              }
        }
  })
  
  # plot the most common words
  output$plot1 <- renderPlot({
        # start with 3-grams
        sentence <- wordsplit(input$text, 3)      
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
              # most probable words
              ggplot(search, aes(x = reorder(mostcommon, prob), y = prob)) + 
                    geom_bar(stat = "identity", color = "white", fill="blue") + theme_bw() +
                    coord_flip() + ylab("Probability") + ggtitle("Most Likely Words") + xlab("")
        } else {
              # look at 2-grams
              sentence <- wordsplit(input$text, 2)
              search <- ngramsdat2[which(grepl(sentence, ngramsdat2$word, ignore.case = T) == T),]
              if(nrow(search) > 0){
                    # if 2-gram found take the last words and look at how many are found in the dataset
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
                    # most probable words
                    ggplot(search, aes(x = reorder(mostcommon, prob), y = prob)) + 
                          geom_bar(stat = "identity", color = "white", fill="blue") + theme_bw() +
                          coord_flip() + ylab("Score") + ggtitle("Most Likely Words") + xlab("")
              } else {
                    # most probable words
                    ggplot(ngramsdat1[1:50,], aes(x = reorder(word, frequency), y = frequency)) + 
                          geom_bar(stat = "identity", color = "white", fill="blue") + theme_bw() +
                          coord_flip() + ylab("Frequency") + ggtitle("Most Frequent Words") + xlab("")
              }
        }
  })
})

