library(quantmod)
library(RCurl)


shinyServer(function(input, output) {
  
  dataInput <- reactive({  
    out <-try(is.character(getURL("http://www.rstudio.com"))) == TRUE
    validate(
      need(out==TRUE,
           "Please check your internet connection and restart application" ))
    
    getSymbols(input$stock, src = "yahoo", 
               from = input$daterange[1],
               to = input$daterange[2],
               auto.assign = FALSE)
   
  })
  
  
  finalInput <- reactive({
    if (input$scale=="Daily") d<-dataInput()
    else if (input$scale=="Weekly") d<-to.weekly(dataInput())
    
    return(d)
    })
  
  output$text1 <- renderText({ 
    
    paste ("You have selected ", tolower(input$scale)," chart for ",input$stock, " with ", input$indicator)
  })
  
  output$indicatorPlot <- renderPlot({
    if (input$scale=="Weekly") 
      validate(
        need((input$daterange[2]-input$daterange[1])>360,
       "To make the indicators performe correctly the time span is to be no less than 360 days for a weekly scale"))
             
    else if
    (input$scale=="Daily") 
      validate(
        need((input$daterange[2]-input$daterange[1])>60,
       "To make the indicators performe correctly the time span is to be no less than 60 days for a daily scale"
             )
      )
    
    chartSeries(finalInput(),theme = chartTheme("white"), 
                type = "line")
    if (input$indicator=="RSI") addRSI(input$range)
    else if (input$indicator=="MACD") addMACD()
    else addROC()
   
  })
})