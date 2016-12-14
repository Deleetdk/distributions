
# This is the user-interface definition of a Shiny web application.
# You can find out more about building applications with Shiny here:
#
# http://shiny.rstudio.com
#

library(shiny)

shinyUI(fluidPage(

  # Application title
  titlePanel("Distributions"),

  # Sidebar with a slider input for number of bins
  sidebarLayout(
    sidebarPanel(
      selectInput("dist",
                  label = "Choose a distribution",
                  choices = c("Normal",
                              "Student t",
                              "Chi",
                              "F",
                              "Beta",
                              "Binominal",
                              "Poisson",
                              "Gamma",
                              "Exponential",
                              "Log-normal"
                              ),
                  selected = "normal",
                  multiple = FALSE,
                  selectize = TRUE
                  ),
      #mean
      conditionalPanel(
        condition = "['Normal', 'Log-normal'].includes(input.dist)",
        numericInput("mean",
                     label = "Mean (µ)",
                     value = 0
                     )
        ),
      
      #sd
      conditionalPanel(
        condition = "['Normal', 'Log-normal'].includes(input.dist)",
        numericInput("sd",
                     label = "Standard deviation (sd, σ²)",
                     value = 1
                     )
      ),
      
      #df 1
      conditionalPanel(
        condition = "['Student t', 'Chi', 'F'].includes(input.dist)",
        numericInput("df",
                     label = "Degrees of freedom (df)",
                     value = 10
        )
      ),
      
      #df 2
      conditionalPanel(
        condition = "['Student t', 'Chi', 'F'].includes(input.dist)",
        numericInput("df2",
                     label = "Degrees of freedom 2 (df)",
                     value = 10
        )
      ),
      
      #ncp
      conditionalPanel(
        condition = "['Student t', 'Chi', 'F', 'Beta'].includes(input.dist)",
        numericInput("ncp",
                     label = "Non-centrality parameter (delta)",
                     value = 0
        )
      ),
      
      #prob
      conditionalPanel(
        condition = "['Binominal'].includes(input.dist)",
        numericInput("prob",
                     label = "Probability of success (p)",
                     value = .5,
                     min = 0,
                     max = 1,
                     step = .1
        )
      ),
      
      #trials
      conditionalPanel(
        condition = "['Binominal'].includes(input.dist)",
        numericInput("trials",
                     label = "Number of trials",
                     value = 5,
                     min = 0
        )
      ),
      
      #shape 1
      conditionalPanel(
        condition = "['Beta', 'Gamma'].includes(input.dist)",
        numericInput("shape",
                     label = "Shape",
                     value = .5
        )
      ),
      
      #shape 2
      conditionalPanel(
        condition = "['Beta'].includes(input.dist)",
        numericInput("shape2",
                     label = "Shape 2",
                     value = .5
        )
      ),
      
      #lambda
      conditionalPanel(
        condition = "['Poisson'].includes(input.dist)",
        numericInput("lambda",
                     label = "Lambda (λ)",
                     value = 4
        )
      ),
      
      #rate
      conditionalPanel(
        condition = "['Poisson', 'Exponential'].includes(input.dist)",
        numericInput("rate",
                     label = "Rate",
                     value = 1
        )
      ),
      
      #vline
      checkboxInput("vline",
                    label = "Add vertical line at 0?",
                    value = T
                    ),
      
      #seed
      numericInput("seed",
                  label = "Seed (for number generation)",
                  value = 1
                  )
    ),

    # Show a plot of the generated distribution
    mainPanel(
      HTML("<p>Much of statistics employs one or more <a href='https://en.wikipedia.org/wiki/List_of_probability_distributions'>(probability) distributions</a> in the modeling or simulation of data. The parameters of the distributions makes it possible to briefly describe the distribution of values. One can also proceed reversely and use the distribution parameters to simulate datasets. One can then play around with the parameters to get a feel for how they work.</p>"),
      plotOutput("dist"),
      hr(),
      HTML("<p>Made by <a href='http://emilkirkegaard.dk/'>Emil O. W. Kirkegaard</a> using <a href='http://shiny.rstudio.com/'>Shiny</a> for R. Source code available <a href=''>on Github</a>.</p>")
    )
  )
))
