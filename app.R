library(shiny)
library(leaflet)
library( plotly)

XTreesParis <- read.csv( "arbresremarquablesparis2011.csv", 
                         header = TRUE, sep = ";")

XTreesParis$X <- sub( pattern = ", \\d+.\\d+$", "", XTreesParis$Geo.point)
XTreesParis$Y <- sub( pattern = "^\\d+.\\d+, ", "", XTreesParis$Geo.point)

XTreesParis$Popup <- paste( XTreesParis$NOM.COMMUN, "-",
                            "Year:", XTreesParis$ANNEE.PLANTATION, 
                            "Height:", XTreesParis$HAUTEUR, "Meters")

colnames( XTreesParis)[  6] <- "Year"
colnames( XTreesParis)[  7] <- "Height"
colnames( XTreesParis)[  8] <- "Circumference"
colnames( XTreesParis)[ 10] <- "Name"

GreenMarker <- makeIcon(
  iconUrl = "Green32.png",
  iconWidth = 32, iconHeight = 32)

PinkMarker <- makeIcon(
  iconUrl = "Pink64.png",
  iconWidth = 64, iconHeight = 64)

##########################################################
ui <- fluidPage(
  HTML( "<h1/>eXtra Trees in Paris - <a href = \"http://opendata.paris.fr/explore/dataset/arbresremarquablesparis2011/\">Paris Open Data</a></h1>"),
  
    mainPanel(
      h3( "Click on a tree on the first plot to get its location on the map"),
      plotlyOutput( "Plot", width = "600px", height = "300px"),
      br(),
      leafletOutput( "Map", width = "600px", height = "300px"),
      br(),
      HTML( "<h3/>And there are even more eXtra trees <a href = \"https://www.mnhn.fr/sites/mnhn.fr/files/parcours/arbres_historiques_jardin_des_plantes.pdf\">in Jardin des Plantes</a></h3>")))

##########################################################
server <- function( input, output){
  
  output$Plot <- renderPlotly({
    plot_ly( XTreesParis, 
             x = ~ Year, 
             y = ~ Height, 
             text = ~ Name,
             name = "",
             color = ~ Circumference, 
             size = ~ Circumference)})
  
  output$Map <- renderLeaflet({
    clicked <- event_data( "plotly_click")
    if( ! is.null( clicked)) {
      
      ## find the coordinate of the clicked tree
      PinkTree <- XTreesParis %>% 
        filter( Year == clicked$x, 
                Height == clicked$y)
      
      leaflet() %>%
        addTiles() %>%
        setView( lng = 2.348785, lat = 48.853402, zoom = 11) %>%
        addMarkers( lng = ~ Y, lat = ~ X,
                    popup = ~ Popup,
                    icon = GreenMarker,
                    data = XTreesParis) %>%
        addMarkers( lng = ~ Y, lat = ~ X,
                    popup = ~ Popup,
                    icon = PinkMarker,
                    data = PinkTree)}
    else {
      leaflet() %>%
        addTiles() %>%
        setView( lng = 2.348785, lat = 48.853402, zoom = 11) %>%
        addMarkers( lng = ~ Y, lat = ~ X,
                    popup = ~ Popup,
                    icon = GreenMarker,
                    data = XTreesParis)}
})}

##########################################################
shinyApp(ui, server)
##########################################################
