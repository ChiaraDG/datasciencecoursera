library(shiny)
library(stringi)
library(quanteda)
library(data.table)
library(ggplot2)

# Define UI
shinyUI(fluidPage(
  
  # Application title
  titlePanel("Next Word Predictor"),
  helpText("Input a word or a sentence and press submit. The output is
           computed using the stupid back-off algorithm. The app will return: a table with the 3
           (or less if 3 words were found) most likely word and a histogram plotting each of the possible
           words together with their probability.
           The second panel (Code and Reference) summarises the model used and gives the 
           user multiple sources on natural language processing. 
           NOTE: the algorithm works only when English words/sentence are inputed"),
  
  # Sidebar with a slider input for number of bins 
  sidebarLayout(
    sidebarPanel(
          textInput("text", "Type Here:", "text here"),
          p("Click the submit button to update the word prediction"),
          submitButton("Submit"),
          helpText("Note: depending on your input, the app might take time to run.")
    ),
    
    # Show a plot of the generated distribution
    mainPanel(
          tabsetPanel(
                tabPanel("Next Word", 
                         verbatimTextOutput("best3"),
                         br(), br(),
                         plotOutput("plot1")),
                tabPanel("Code and Reference",
                         includeMarkdown("include.md"))
          )
    )
  )
))
