#Libraries
library(shiny)
library(shinydashboard)
library(plotly)
library(datasets)
library(skimr)
library(zoo)
library(ggfortify)
library(dplyr)
library(ggplot2)
library(skimr)
library(lubridate)
library(stats)

#Data improting and formatting
NFLX <- read.csv("NFLX.csv")
NFLX$Date <- as.Date(NFLX$Date, format = "%m/%d/%Y")
NFLX$Date <- format(NFLX$Date, "%Y-%m-%d")
NFLX$Date <- as.Date(NFLX$Date)

#color
defaultColor = "red"

#Server
shinyServer(function(input,output,session){
  
  # Dataset Plotting
  output$dsp <- renderDataTable({
    NFLX
  })
  
  #Data structure
  output$st <- renderPrint({
    str(NFLX)
  })
  
  #Data summary
  output$sum <- renderPrint({
    summary(NFLX)
  })
  
  #Line graph overall plotting
  output$lop <- renderPlotly({
    ggplot(NFLX[NFLX$Date > input$lsd & NFLX$Date < input$led, ], aes(x = Date, y = Close ,col =defaultColor)) +
      geom_line() + 
      scale_x_date(date_labels = "%m-%Y")
  })
  
  #Line graph year plotting
  lastYear <- tail(NFLX, 365)
  output$lyp <- renderPlotly({
    ggplot(lastYear, aes(x = Date, y = Close, col = defaultColor)) +
      geom_line() + 
      scale_x_date(date_labels = "%m-%Y")
  })
  
  #Line graph month plotting
  lastMonth <- tail(NFLX, 30)
  output$lmp <- renderPlotly({
    ggplot(lastMonth, aes(x = Date, y = Close, col = defaultColor)) +
      geom_line() + 
      scale_x_date(date_labels = "%d-%m")
  })
  
  #Scatter plot plotting
  output$spp <- renderPlotly({
    p <- ggplot(NFLX[NFLX$Date > input$ssd & NFLX$Date < input$sed, ], aes(x=Date, y=Close, size=Volume, col = defaultColor)) +
      geom_point() +
      geom_smooth(method=input$fit) +
      labs(x = "Date",
           y = "Close")
    ggplotly(p)
  })
  
  #Boxplot Closing plotting
  output$bcp <- renderPlotly({
    plot_ly(data= NFLX,y = ~Close, type = "box", color = defaultColor)
  })
  
  #Histogram volume plotting
  output$hvp <- renderPlotly({
    plot_ly(data = NFLX,x=~Volume,type = "histogram",color = defaultColor)
  })

  #Probability distribution plotting
  m <- mean(NFLX$Volume)
  sd <- sd(NFLX$Volume)
  output$pdp <- renderPlotly({
    ggplot(NFLX, aes(x = Volume, y = pnorm(Volume,mean = m,sd = sd), col = defaultColor)) +
      geom_point() 
  })
  
  #Regression model summary
  output$rms <- renderPrint({
    summary(model)
  })
  
  #Regression model prediction
  model <- lm(Close ~ Open, data=NFLX)
  output$rm <- renderValueBox({
    valueBox(
      color = defaultColor, value = predict.lm(model, newdata = data.frame(Open = c(input$num))) ,subtitle = "Expected Closing of NFLX depending on Opening value"
    )
  })
  
  #Descriptive confidence interval
  output$dci <- renderPrint({
    cat("Confidence interval of Open:", (t.test(NFLX$Open)$conf.int)[1:2], "\n")
    cat("Confidence interval of High:", (t.test(NFLX$High)$conf.int)[1:2], "\n")
    cat("Confidence interval of Low:", (t.test(NFLX$Low)$conf.int)[1:2], "\n")
    cat("Confidence interval of Close:", (t.test(NFLX$Close)$conf.int)[1:2], "\n")
    cat("Confidence interval of Volume:", (t.test(NFLX$Volume)$conf.int)[1:2], "\n")
  })
  
  #Regression confidence interval
  output$rci <- renderPrint({
    cat("Confidence interval of slope(Open) cofficient:", confint(model)["Open",], "\n")
    cat("Confidence interval of intercept cofficient:", confint(model)["(Intercept)",], "\n")
  })
  
})