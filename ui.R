## shiny application
## visualizes weighted street segments on a leaflet map

## user interface
ui = fluidPage(
  titlePanel("Street Segment Weights"),
  leafletOutput('myMap', height = 600),
  fluidRow(
    
    column(7, radioButtons("atts", 
                           label = h3("Attributes"), 
                           choices = list("Min. Speed" = "min_speed", 
                                          "Max. Speed" = "max_speed", 
                                          "Mean Speed" = "mean_speed",
                                          "VC Speed" = "vc_speed",
                                          "Min. Time" = "min_time", 
                                          "Max. Time" = "max_time", 
                                          "Mean TIme" = "mean_time"),
                           selected = "mean_speed", inline = FALSE))  
  )
  
)
