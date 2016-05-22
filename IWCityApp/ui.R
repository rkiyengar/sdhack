##
## IncentiWise App
## 
## ui.R
##

ROUTE_ID_RANGE <- c(1, 30)
zip.codes <- c(92105,92104,92113,92102,92139,92116,92115,92107,92103,92114,92119,92122,92117,92111,92110)
routes <- c(ROUTE_ID_RANGE[1]:ROUTE_ID_RANGE[2])

ui <- fluidPage(
    
    title = "IWCityApp: IncentiWise City-Wide Data",
    titlePanel(h2(strong("IncentiWise City-Wide Data",style = "color:gray"))),
    hr(),
    br(),
    sidebarLayout(
        
        sidebarPanel(
            helpText("San Diego City Transit Data"),
            
            hr(),
            selectInput("selRegion", 
                        label = h5(strong("Select a Zipcode")),
                        choices = zip.codes,
                        selected = "Percent White"),
            selectInput("selRoute", 
                        label = h5(strong("Select a Route")),
                        choices = routes,
                        selected = "Percent White"),
            hr(),
            sliderInput("timeRange", 
                        label = h5(strong("Time (last 6 months)")),
                        min = -6, max = 0, value = c(-6, 0), sep = "")
            ),
        
        mainPanel(
            tabsetPanel(
                tabPanel("Key Stats", br(), tableOutput("tabStats1"), htmlOutput("tabHeading"),br(),
                         tableOutput("tabStats2")),
                tabPanel("Trends", 
                         br(),htmlOutput("tabHeading2"),
                         splitLayout(cellWidths = c("50%", "50%"), 
                                     plotOutput("tabPlot1"), plotOutput("tabPlot2"))
                         ),
                tabPanel("Summary", htmlOutput("tabSummary")) 
            )
        )
    )
)
