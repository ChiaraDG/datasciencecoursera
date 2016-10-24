library(shiny)
library(dplyr)
dat <- read.csv("Intakes.csv",sep = "")
# change names to dat variable to facilitate the user
names(dat) <- c("Country", "category", "Energy", "Fat","Sugar","Salt","Score", "healthy")
# take inly the variable to use
dat <- dat %>% select(Country, category, Energy, Fat, Sugar, Salt, healthy)

# Define server logic required to draw a histogram
shinyServer(function(input, output) {
      # output histogram
      output$plot1 <- renderPlot({
            # select variable and country
            filtered <- dat %>% filter(Country == input$countryInput)
            x <- filtered[,input$variableInput]
            hist(log(x), main = "Histogram of the selected variable (log-scale)", col = "green")
      })
      # output summary statistics
      output$results <- renderPrint({
            # take the imput variable and country
            filtered <- dat %>% filter(Country == input$countryInput)
            x <- filtered[,input$variableInput]
            summary(x)
      
      })
      # output table with first 10 based on the selected nutrient
      output$table <- renderTable({
            # take the imput variable and country
            filtered <- dat %>% filter(Country == input$countryInput) %>% group_by(category)
            x <- filtered[,input$variableInput]
            filtered[order(-x),][1:10,]
      })
      # fit logistic model to predict healthy/unhealty food
      output$summary <- renderPrint({
            filtered <- dat %>% filter(Country == input$countryInput) 
            x <- filtered[,input$variableInput]
            mod <- glm(filtered$healthy ~ x, family = "binomial")
            summary(mod)
      })
      # output boxplot of input variable by helthy/unhealthy
      output$plot2 <- renderPlot({
            # select variable and country
            filtered <- dat %>% filter(Country == input$countryInput)
            x <- filtered[,input$variableInput]
            boxplot(log(x) ~ filtered$healthy, main = "Boxplot of the selected variable (log-scale)", 
                    col = c("blue", "red"))
      })
})