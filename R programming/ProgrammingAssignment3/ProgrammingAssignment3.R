#### Hospital that has the lowest 30-day mortality for one of the three outcomes in a pre-specified State. ####

dat <- read.csv("outcome-of-care-measures.csv")

# rename variables so that they have a shorter, more manageble name
rename <- c("Hospital.30.Day.Death..Mortality..Rates.from.Heart.Attack", 
            "Hospital.30.Day.Death..Mortality..Rates.from.Heart.Failure",
            "Hospital.30.Day.Death..Mortality..Rates.from.Pneumonia")
colnames(dat)[colnames(dat) %in% rename] <- c("HeartAttack", "HeartFailure", "Pneumonia")

# keep only variables needed in the analysis
keep <- c("Hospital.Name", "State", "HeartAttack", "HeartFailure", "Pneumonia")
dat <- dat[,colnames(dat) %in% keep]

# transfrom outcomes in numeric
dat$HeartAttack <- as.numeric(as.character(dat$HeartAttack))
dat$HeartFailure <- as.numeric(as.character((dat$HeartFailure)))
dat$Pneumonia <- as.numeric(as.character((dat$Pneumonia)))

# Look at the hospital that has the best (i.e. lowest)
# 30-day mortality for one of the three outcomes in a pre-specified State.

best <- function(state, outcome){
      # subset state
      datState <-subset(dat, State == state)
      # return the one hospital with lowest mortality
      # if outcome is heart attack
      if(outcome == "heart attack"){
            out <- datState$Hospital.Name[which.min(datState$HeartAttack)]
            }
      # if outcome is heart failure
      if(outcome == "heart failure"){
            out <- datState$Hospital.Name[which.min(datState$HeartFailure)]
            }
      # if outcome is pneumonia
      if(outcome == "pneumonia"){
            out <- datState$Hospital.Name[which.min(datState$Pneumonia)]
            }
      return(out)
}


#### Rank the hospitals by outcome in each state ####
rankhospital <- function(state, outcome, pick){
      # subset state
      datState <-subset(dat, State == state)
      # return the one hospital with lowest mortality
      # if outcome is heart attack
      if(outcome == "heart attack"){
            # sort dataset
            sortdat <- datState[order(datState$HeartAttack,datState$Hospital.Name),]
            sortdat <- sortdat[which(is.na(sortdat$HeartAttack) == F),]
            # pick how many we need
            if (is.numeric(pick)){out <- sortdat$Hospital.Name[pick]
            } else if(pick == "worst"){
                  # take worst hospital 
                  out <- sortdat$Hospital.Name[length(sortdat$Hospital.Name)]
            } else if(pick == "best"){
                  out <- sortdat$Hospital.Name[1]}
      }
      # if outcome is heart failure
      if(outcome == "heart failure"){
            # sort dataset
            sortdat <- datState[order(datState$HeartFailure,datState$Hospital.Name),]
            sortdat <- sortdat[which(is.na(sortdat$HeartFailure) == F),]
            # pick how many we need
            if (is.numeric(pick)){out <- sortdat$Hospital.Name[pick]
            } else if(pick == "worst"){
                  # take worst hospital 
                  out <- sortdat$Hospital.Name[length(sortdat$Hospital.Name)]
            } else if(pick == "best"){
                  out <- sortdat$Hospital.Name[1]}
      }
      # if outcome is pneumonia
      if(outcome == "pneumonia"){
            # sort dataset
            sortdat <- datState[order(datState$Pneumonia,datState$Hospital.Name),]
            sortdat <- sortdat[which(is.na(sortdat$Pneumonia) == F),]
            # pick how many we need
            if (is.numeric(pick)){out <- sortdat$Hospital.Name[pick]
            } else if(pick == "worst"){
                  # take worst hospital 
                  out <- sortdat$Hospital.Name[length(sortdat$Hospital.Name)]
            } else if(pick == "best"){
                  out <- sortdat$Hospital.Name[1]}
      }
      return(out)
      
}


#### Which hospital in each State has a pre-specified ranking for the outcome of interest ####

rankall <- function(state, outcome){
      # if outcome is heart attack
      if(outcome == "heart attack"){
      # sort dataset
      sortdat <- dat[order(dat$State,dat$HeartAttack),]
      sortdat <- sortdat[which(is.na(sortdat$HeartAttack) == F),]
      sortdat <- subset(sortdat, select = c("State", "HeartAttack","Hospital.Name"))
      if(pick == "worst"){
            # take worst rate for each state
            statehospital <- split(sortdat,sortdat$State)
            selectworst <- function(x){x[nrow(x),]}
            rate <- lapply(statehospital, selectworst)
            out <- do.call(rbind.data.frame, rate)
      } else if(pick == "best"){
            # take best rate for each state
            statehospital <- split(sortdat,sortdat$State)
            selectbest <- function(x){x[1,]}
            rate <- lapply(statehospital, selectbest)
            out <- do.call(rbind.data.frame, rate)}
      }
      # if outcome is heart failure
      if(outcome == "heart failure"){
            # sort dataset
            sortdat <- dat[order(dat$State,dat$HeartFailure),]
            sortdat <- sortdat[which(is.na(sortdat$HeartFailure) == F),]
            sortdat <- subset(sortdat, select = c("State", "HeartFailure","Hospital.Name"))
            if(pick == "worst"){
                  # take worst rate for each state
                  statehospital <- split(sortdat,sortdat$State)
                  selectworst <- function(x){x[nrow(x),]}
                  rate <- lapply(statehospital, selectworst)
                  out <- do.call(rbind.data.frame, rate)
            } else if(pick == "best"){
                  # take best rate for each state
                  statehospital <- split(sortdat,sortdat$State)
                  selectbest <- function(x){x[1,]}
                  rate <- lapply(statehospital, selectbest)
                  out <- do.call(rbind.data.frame, rate)}
      }
      # if outcome is pneumonia
      if(outcome == "pneumonia"){
            # sort dataset
            sortdat <- dat[order(dat$State,dat$Pneumonia),]
            sortdat <- sortdat[which(is.na(sortdat$Pneumonia) == F),]
            sortdat <- subset(sortdat, select = c("State", "Pneumonia","Hospital.Name"))
            if(pick == "worst"){
                  # take worst rate for each state
                  statehospital <- split(sortdat,sortdat$State)
                  selectworst <- function(x){x[nrow(x),]}
                  rate <- lapply(statehospital, selectworst)
                  out <- do.call(rbind.data.frame, rate)
            } else if(pick == "best"){
                  # take best rate for each state
                  statehospital <- split(sortdat,sortdat$State)
                  selectbest <- function(x){x[1,]}
                  rate <- lapply(statehospital, selectbest)
                  out <- do.call(rbind.data.frame, rate)}
      }
      return(out)
}