
# This is the server logic for a Shiny web application.

library(shiny)
library(dplyr)
library(ggplot2)
library(stringr)
library(tidyr)
library(DT)

# Change upload size (csv)
options(shiny.maxRequestSize = 500*1024^2)

shinyServer(function(input, output) {
  
  dataTable <- reactive({
    inFile <- input$file1 # loads in the file from input field
    costs_in <- input$costs # loads in the costs from the input field
    
    if (is.null(inFile))
      return(NULL)
    
    data <- read.csv(inFile$datapath, header=input$header, sep=input$sep, 
                     quote=input$quote)
    
    # Select columns, count for each Recipient.Id and spread based on Event.Type
    goldenpop <- data %>%
      select(Recipient.Id, Event.Type) %>%
      group_by(Recipient.Id, Event.Type) %>%
      summarise(count = n()) %>%
      filter(!Event.Type == "") %>%
      mutate(Event.Type = str_replace_all(Event.Type, " ", ".")) %>%
      spread(Event.Type, count)
    
    # Fill in NAs
    goldenpop[is.na(goldenpop)] <- 0
    
    # Calculate values
    goldenpop <- goldenpop %>%
      select(Sent, Open, Click.Through, Clickstream) %>%
      filter(Sent > 0) %>%
      mutate(Activity.Score = Open + Clickstream + Click.Through,
             Activity.Rate = Activity.Score/Sent,
             Open.Rate = Open / Sent,
             costs = Sent * costs_in/1000)
    
    # Calculate costs
    result <- goldenpop  %>%
      mutate(Activity.Rate = round(Activity.Rate, 1)) %>%
      group_by(Activity.Rate) %>%
      summarise(Naklady = round(sum(costs), 2),
                Recipient.Nr = n()) %>%
      mutate(Cenovka = paste(round(Naklady, 0), "Kč", sep = " "))
    
  })
  
  output$gdata <- renderDataTable({
    if(is.null(dataTable())){return()}
    
    gdata <- datatable(dataTable())
    return(gdata)
  })
  
  output$graf <- renderPlot({
    result <- dataTable()
    
    # Assign graph limits
    max_lim_y <- max(1.05*result$Recipient.Nr)
    
    # Histogram with a pricetag
    ggplot(result,
           aes(Activity.Rate, Recipient.Nr)) +
      ggtitle("How much do inactive recipients costs?") +
      geom_bar(stat = "identity",
               fill = "orange",
               width = 0.09) +
      geom_text(aes(label = Cenovka,
                    hjust = 0.5,
                    vjust = -0.7),
                size = 5) +
      coord_cartesian(xlim = c(0, 1),
                      ylim = c(0, max_lim_y)) +
      scale_x_continuous(name = "Recipients Activity Rate",
                         breaks = seq(0, 1, 0.1)) +
      scale_y_continuous(name = "Number of recipients") +
      theme_bw() +
      theme(plot.title = element_text(size = 26,
                                      colour = "#7b8385",
                                      face="bold",
                                      lineheight = 4),
            axis.title.x = element_text(size = 20,
                                        colour = "#7b8385",
                                        face="bold",
                                        vjust = -0.5),
            axis.title.y = element_text(size = 20,
                                        colour = "#7b8385",
                                        face = "bold",
                                        vjust = -0.5))
    
  })
  
  
  output$tb <- renderUI({
    if(is.null(dataTable())) {
      includeHTML("welcome.html")
      strong("Data is not stored in any location.")
    } else {
      tabsetPanel(
        tabPanel("Outcome description", includeHTML("summary.html")),
        tabPanel("Visualize activity rate", plotOutput("graf", height = 600)),
        tabPanel("Activity rate table", dataTableOutput("gdata"))
      )
    }
  })
  
})
