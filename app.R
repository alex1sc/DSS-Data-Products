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
  sidebarLayout(
    sidebarPanel(
      radioButtons( "radio", "Map Layout:",
                    c( "Standard"      = "Standard",
                       "Thunderforest" = "Thunderforest.Landscape",
                       "Watercolor"    = "Stamen.Watercolor",
                       "TonerHybrid"   = "Stamen.TonerHybrid",
                       "Positron"      = "CartoDB.Positron")),
      plotOutput("distPlot")),  
    
    mainPanel(
      tabsetPanel(
        tabPanel( "Find eXtra Trees", 
                  plotlyOutput( "Plot", width = "600px", height = "300px"),
                  br(),
                  leafletOutput( "Map", width = "600px", height = "300px")),
        
        tabPanel( "Documentation",  
                  h3( "The goal of this app is to click on a tree on the 
                                first plot regarding its caracteristics. 
                                And then look at its location on the map below the plot."),
                  h3( "On the left side bar you can also choose a landscape type for the map."),
                  br(),
                  h3( "In the third tab 'Other eXtra' there are also nice trees from the Jardin des Plantes.")),

                tabPanel( "Other eXtras", uiOutput( "PDF"))
                  
      ))))
##########################################################
server <- function( input, output){
  
  output$PDF <- renderUI({
    PDFfile = "http://www.mnhn.fr/sites/mnhn.fr/files/parcours/arbres_historiques_jardin_des_plantes.pdf"
    tags$iframe(
      src = PDFfile,
      width = "100%",
      height = "800px")
  })
  
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
    m <- leaflet() 
    
    if( input$radio == "Standard") m <- m %>% addTiles()
    else m <- m %>% addProviderTiles( input$radio) 
    
     m <- m %>%
      setView( lng = 2.348785, lat = 48.853402, zoom = 11) %>%
      addMarkers( lng = ~ Y, lat = ~ X,
                  popup = ~ Popup,
                  icon = GreenMarker,
                  data = XTreesParis)
    
    output$value <- renderPrint({ input$radio })    
    
    if( ! is.null( clicked)) {
      
      ## find the coordinate of the clicked tree
      PinkTree <- XTreesParis %>% 
        filter( Year == clicked$x, 
                Height == clicked$y)
      
      m %>% 
        addMarkers( lng = ~ Y, lat = ~ X,
                    popup = ~ Popup,
                    icon = PinkMarker,
                    data = PinkTree)}
    else {
    m }
  })}

##########################################################
shinyApp(ui, server)
##########################################################
