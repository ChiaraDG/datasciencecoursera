
# set working directory
setwd("./en_US")

#### Read data ####

# Read the English Twitter dataset
con <- file("en_US.twitter.txt", "r") 
# Read lines of text (skip nul lines)
twitter <- readLines(con, skipNul = TRUE)
# close connection
close(con)

# Read the English blogs dataset
con <- file("en_US.blogs.txt", "r") 
# Read lines of text (skip nul lines)
blogs <- readLines(con, skipNul = TRUE)
# close connection
close(con)

# Read the English news dataset
con <- file("en_US.news.txt", "r") 
# Read lines of text (skip nul lines)
news <- readLines(con, skipNul = TRUE)
# close connection
close(con)

# Read in profanity
con <- file("profanity.txt", "r") 
# Read lines of text (skip nul lines)
profanity <- readLines(con, skipNul = TRUE)
# close connection
close(con)


#### Longest line of the dataset ####
# max(nchar(blogs))
# max(nchar(news))
# max(nchar(twitter))

#### love hate ratio ####

# nlove <- length(grep("love",twitter))
# nhate <- length(grep("hate",twitter))
# nlove/nhate

#### biostat twitter and string matching ####

# twitter[grep("biostat",twitter)]
# stringtomatch <- c("A computer once beat me at chess, but it was no match for me at kickboxing")
# length(grep(stringtomatch,twitter))

#### create a training and a test data using sampling: ####

# Twitter data
# set seed for reprobucibility
set.seed(123)
# create sample data
select <- rbinom(length(twitter), 1, 0.05)
twitterSample <- twitter[which(select == 1)]

# News data
# set seed for reprobucibility
set.seed(12)
# create sample data
select <- rbinom(length(news), 1, 0.05)
newsSample <- news[which(select == 1)]

# Blogs data
# Twitter data
# set seed for reprobucibility
set.seed(13)
# create sample data
select <- rbinom(length(blogs), 1, 0.05)
blogsSample <- blogs[which(select == 1)]

