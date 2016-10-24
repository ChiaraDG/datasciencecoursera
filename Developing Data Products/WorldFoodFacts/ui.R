library(shiny)
library(dplyr)
dat <- read.csv("Intakes.csv",sep = "")
# change names to dat variable to facilitate the user
names(dat) <- c("Country", "category", "Energy", "Fat","Sugar","Salt","Score", "healthy")
# take inly the variable to use
dat <- dat %>% select(Country,  category, Energy, Fat, Sugar, Salt, healthy)


# Define UI 
ui <- fluidPage(
      
      titlePanel("Food Facts by Country of Origin"),
      helpText("This Shiny App allows the user to summarise intakes of the selected variable in the chosen country
               and to show whether the aforementioned variable is associated with the food being healthy or not.
               The first panel (Summary) shows, the histogram, the summary statistics for the chosen variable as well as the 
               dataset used for deriving both. The second panel (Predict Healthy/Unhealthy Food) shows the results
               of a logistic regression where beign healthy/unhealthy is the outcome of interest and the selected
               variable is the only predictor. All the analyses are done by country. The user can select the
               country of interest"),
      sidebarLayout(
            sidebarPanel(
                  radioButtons("variableInput", "Select a Variable:",
                             choices = c("Energy", "Sugar", "Fat", "Salt")),
                  selectInput("countryInput", "Select a Country:",
                              choices = c("France", "Spain", "Portugal", "Belgium", "Switzerland",
                                          "United States","United Kingdom", "Australia", "Germany", "Italy"))
                  
            ),
            mainPanel(
                  tabsetPanel(
                        tabPanel("Summary", plotOutput("plot1"),
                                 br(), br(),
                                 verbatimTextOutput("results"),
                                 br(), br(),
                                 tableOutput("table")), 
                        tabPanel("Predict Healthy/Unhealthy Food", verbatimTextOutput("summary"),
                                 br(), br(),
                                 plotOutput("plot2"))
      )
)))
