library(shiny)
library(leaflet)
library(shinythemes)
key <- "AIzaSyAHFM3Ev3QYOeLtVKpjr3PCr6oX8RlNCaE"
register_google(key=key)


PawsIcon <- makeIcon(
  iconUrl = "https://image.flaticon.com/icons/svg/1152/1152398.svg",
  iconWidth = 18, iconHeight = 18
)

ui <- navbarPage("Pat Your Pet",
                 theme = shinytheme("simplex"),
                 
                 tabPanel("WELCOME!",icon=icon("heart"),
                          #img(src='~/Technica18/Draft1/1.png', align = "right"),
                          tags$h1("If you need Pet Insurance:"),
                          img(src='1.png', align = "right"),
                          p(a("Pet Insurance Comparison", href = "https://www.petinsurance.com/comparison", target = "_blank", icon=icon("star"))),
                          p(a("Pet Insurance Coverage Plan", href = "https://www.embracepetinsurance.com/coverage/pet-insurance-plan", target = "_blank", icon=icon("star")))

                 ),
                
                 tabPanel("Survey", icon=icon("bar-chart-o"),
                          
                selectInput('Pet kind', 'My Pet is...', c('Mammal', 'Reptile','marine')),
                selectInput('Flu', 'Symptoms', c('wet nose', 'Fever','Eye discharge', 'Others')),
                radioButtons('Urgent', 'Need a doctor in...', c('1 hour or less', '2-3 hour', '4-5 hour', 'Long-term appointment')),
                dateRangeInput("dates", label = h3("When would you like to see the doctor?")),
                checkboxGroupInput("Would you like...", label = h3("Checkbox group"), 
                                   choices = list("One Time Check-In" = 1, "Appointment" = 2, "Long-Term" = 3),
                                   selected = 1),
                checkboxInput("checkbox", label = "I agree to keep all the information from this survey confidential.", value = TRUE),
                
                actionButton('sumbit', 'submit survey')
                 ),
                
      tabPanel("Find",icon = icon("refresh"),
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
  output$value <- renderPrint({ input$checkbox })
  output$value <- renderPrint({ input$checkGroup })
  output$value <- renderPrint({ input$dates })
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