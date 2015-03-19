library(classInt)

## server
server = function(input, output) {
  map = leaflet() %>% addTiles(urlTemplate ='http://{s}.basemaps.cartocdn.com/dark_all/{z}/{x}/{y}.png',
                               attribution='&copy; <a href="http://www.openstreetmap.org/copyright">OpenStreetMap</a> &copy; 
                               <a href="http://cartodb.com/attributions">CartoDB</a>') 
  
  ## reactive function to get the clicked radio button
  refresh <- reactive({
    att <- input$atts
    breaks<-classIntervals(muenster_roads@data[att][[1]], 5, "kmeans")$brks
    breaks[1]<-0 # make first cut zero
    
    cuts <- cut(muenster_roads@data[att][[1]], breaks = breaks, right = FALSE)
    if (att == "vc_speed")
      colors <- colorRampPalette(c("khaki","red"))(5)[cuts]
    else
      colors <- colorRampPalette(c("red","yellow", "green"))(5)[cuts]
    
    map = map %>% addPolylines(data = muenster_roads, color = colors, weight = 3)
    map      
  })
  output$myMap = renderLeaflet(refresh())
}



