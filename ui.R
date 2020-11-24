
# This is the user-interface definition of a Shiny web application.
#

library(shiny)
library(dplyr)

shinyUI(fluidPage(
  
  titlePanel("How much do we spend on emailing activities?"),
  
  sidebarLayout(
    position = "right",
    
    sidebarPanel(
      img(src = "https://rispirate.files.wordpress.com/2015/11/cc.png?w=150", align = "left", height = 60),
      br(),
      br(),
      br(),
      br(),
      br(),
      strong("Costs for sending 1000 emails:"),
      sliderInput("costs", "", min = 0, max = 200, step = 0.5,
                  value = 0),
      
      br(),
      fileInput('file1', 'Load CSV file exported from IBM Marketing Cloud:',
                accept=c('text/csv', 
                         'text/comma-separated-values,text/plain', 
                         '.csv')),
      tags$hr(),
      checkboxInput('header', 'Header', TRUE),
      radioButtons('sep', 'Separator',
                   c(Comma=',',
                     Semicolon=';',
                     Tab='\t'),
                   ','),
      radioButtons('quote', 'Quote',
                   c(None='',
                     'Double Quote'='"',
                     'Single Quote'="'"),
                   '"')
    ),
    
    mainPanel(
      uiOutput("tb")
    )
  )
))
