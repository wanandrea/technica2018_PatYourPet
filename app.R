library(shiny)
library(leaflet)
library(shinythemes)
key <- "AIzaSyAHFM3Ev3QYOeLtVKpjr3PCr6oX8RlNCaE"
register_google(key=key)


PawsIcon <- makeIcon(
  iconUrl = "https://image.flaticon.com/icons/svg/1152/1152398.svg",
  iconWidth = 18, iconHeight = 18
)

ui <- navbarPage("Pet Clinic Draft 1",
                 theme = shinytheme("simplex"),
                 
                
                 tabPanel("Servey",
                          
                selectInput('Pet kind', 'My Pet is...', c('Mammal', 'Reptile','marine')),
                selectInput('Flu', 'Symptoms', c('wet nose', 'Fever','Eye discharge', 'Others')),
                radioButtons('Urgent', 'Need a doctor in...', c('1 hour or less', '2-3 hour', '4-5 hour', 'Long-term appointment')),
                actionButton('sumbit', 'submit survey')
                 ),
      tabPanel("Find",
               div(class="outer",
                   
                   tags$head(
                     #Include our custom CSS
                     includeCSS("styles.css"),
                     includeScript("gomap.js")
                   ),
    sidebarPanel(
      #User input address they want to search
      textInput("location", "Where are you?", "I'm at...."),
      verbatimTextOutput("value"),
      #Open Now
      selectInput('Open Now', 'Open Now', c('Yes', 'No')),
      #Price Range
      radioButtons('price', 'Price Range', c('$', '$$', '$$$', '$$$$', '$$$$$')),
      actionButton('add', 'Find')
    ),

    #display map
    mainPanel(leafletOutput("mymap"),
    p()
  ))
)
)

server <- function(input, output, session) {
  
  output$value <- renderText({ input$caption }) 
 
  
  observeEvent(
    input$add,{
      places<-google_places(search_string = "Pet Hospital, Washington,DC", radius=50000,price_range=c(2,4),key = key)
      lat = places$results$geometry$location$lat
      long = places$results$geometry$location$lng
      location <- expand.grid(lat,long)
      output$sum <- location
  })

  
  output$mymap <- renderLeaflet({
    dumloc <- read.csv("~/Technica18/Draft1/geo.csv")
    
    leaflet(data = dumloc)  %>%
      addTiles() %>% setView(-76.9973351, 38.899745, zoom = 10) %>%
      addMarkers(~long, ~lat,icon = PawsIcon) #, popup = ~as.character(Dummy)
  })
}

shinyApp(ui, server)