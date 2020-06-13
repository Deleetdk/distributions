
# This is the server logic for a Shiny web application.
# You can find out more about building applications with Shiny here:
#
# http://shiny.rstudio.com
#

library(shiny)
library(tidyverse)
sample_size = 1e4

shinyServer(function(input, output) {
  
  output$dist <- renderPlot({
    #generate data
    set.seed(input$seed)
    switch(input$dist,
           "Normal" = {
             x = rnorm(sample_size, mean = input$mean, sd = input$sd)
             px = dnorm(x, mean = input$mean, sd = input$sd)
             },
           "Student t" = {
             x = rt(n = sample_size, df = input$df, ncp = input$ncp)
             px = dt(x, df = input$df, ncp = input$ncp)
             },
           "Chi" = {
             x = rchisq(n = sample_size, df = input$df, ncp = input$ncp)
             px = dchisq(x, df = input$df, ncp = input$ncp)
             },
           "F" = {
             x = rf(n = sample_size, df1 = input$df, df2 = input$df2, ncp = input$ncp)
             px = df(x, df1 = input$df, df2 = input$df2, ncp = input$ncp)
             },
           "Beta" = {
             x = rbeta(n = sample_size, shape1 = input$shape, shape2 = input$shape2, ncp = input$ncp)
             px = dbeta(x, shape1 = input$shape, shape2 = input$shape2, ncp = input$ncp)
             },
           "Binominal" = {
             x = rbinom(n = sample_size, size = input$trials, prob = input$prob)
             px = dbinom(x, size = input$trials, prob = input$prob)
             },
           "Poisson" = {
             x = rpois(n = sample_size, lambda = input$lambda)
             px = dpois(x, lambda = input$lambda)
             },
           "Gamma" = {
             x = rgamma(n = sample_size, shape = input$shape, rate = input$rate)
             px = dgamma(x, shape = input$shape, rate = input$rate)
             },
           "Exponential" = {
             x = rexp(n = sample_size, rate = input$rate)
             px = dexp(x, rate = input$rate)
             },
           "Log-normal" = {
             x = rlnorm(n = sample_size, meanlog = input$mean, sdlog = input$sd)
             px = dlnorm(x, meanlog = input$mean, sdlog = input$sd)
             }
           )
    
    #put in a df
    d = tibble(
      x = x,
      px = px
    )
    
    #remove theoretical if nonsensical
    if (input$dist %in% c("Beta", "Binominal", "Poisson", "Gamma")) d$px = NA
    
    #theoretical value adjustments
    binwidth = (max(x) - min(x)) / input$bins
    
    #plot
    gg = ggplot(d, aes(x)) +
      geom_histogram(aes(y = ..count.. / sum(..count..)), binwidth = binwidth) +
      # geom_histogram(bins = 100) +
      #hack solution to get proportion on y
      #pls implement as an options Hadley!
      # scale_y_continuous("Percent", labels = scales::percent) +
      ylab("density") +
      # scale_x_continuous(breaks = seq(floor(min(x)), ceiling(max(x)), length.out = 10)) +
      #add theoretical density
      geom_line(aes(x = x, y = px * binwidth)) +
      # not quite as good as I want, so use default
      theme_bw()
      #nicer theme
    
    #add vertical line?
    if (input$vline) gg = gg + geom_vline(aes(xintercept = 0), linetype = "dashed")
    
    #return plot
    gg
  })

})
