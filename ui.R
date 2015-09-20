library(shiny)
shinyUI(fluidPage(
  titlePanel("Tech stocks technical indicators"),
  
  sidebarLayout(
    sidebarPanel(
      helpText("Build a stock chart with  technical indicators"),
      
      selectInput("stock", 
                  label = "Choose a stock to display",
                  choices = list("AAPL", "GOOG",
                                 "MSFT", "INTC","IBM"),
                  selected = "AAPL"),
    
      dateRangeInput("daterange", "Date range:",
                   start = "2013-01-01",
                   end   = Sys.Date()),
      
      radioButtons("scale", "Time scale",
                   c("Daily",
                     "Weekly"
                    )),
      
      radioButtons("indicator", "Technical indicator",
                   c("RSI",
                     "MACD",
                     "ROC"
                     ),selected="RSI"),
      
    conditionalPanel(
      "input.indicator == 'RSI'",
      sliderInput("range", "Days to average over (for RSI only)", min=2, max=14, value=1)),
    
    helpText("To see help documentation",a(href="https://maximez.shinyapps.io/SMRD", target="_blank","Click here"))
    ),
    
    mainPanel(
      textOutput("text1"),
      plotOutput("indicatorPlot"))
  )
)
)