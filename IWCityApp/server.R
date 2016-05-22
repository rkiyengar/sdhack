##
## IncentiWise App
## 
## server.R
##

load(file="./data/iwcityapp.RData")

server <- function(input,output)
{
    getTable <- function(input)
    {
        zip <- input$selRegion
        zip.data.transit <- transit.data[transit.data$zip == zip,]
        zip.stats <- as.numeric(as.vector(zip.data.transit[1,2:5]))
        
        df <- data.frame(c("Population/Sq.Mile","Cost of Living Index","User Count",
                           "Avg Daily Travel Time (mins)"),
                         zip.stats
                         )
        
        names(df) <- c("General","Value")
        row.names(df) <- NULL
        
        #df <- as.data.frame(t(df))
        df
    }
    
    getACATable <- function(input)
    {
        zip <- input$selRegion
        zip.data.aca <- zipcode.data.aca[zipcode.data.aca$zip == zip,2:6]
        
        names(zip.data.aca) <- c("Aggregate","Bike","Walk","Transit","Ride-Share")
        row.names(zip.data.aca) <- c(1:6)
        
        #zip.data.aca <- as.data.framezip.data.aca(t(df))
        zip.data.aca
    }
    
    plotACATrend <- function(input,type)
    {
        par(mar=c(5,5,10,1))
    
        aca.data <- getACATable(input)
        
        plot.data <- aca.data$Bike
        type.string <- "Bike"
        if(type==2)
        {
            plot.data <- aca.data$Walk
            type.string <- "Walk"
        }
        if(type==3)
        {
            plot.data <- aca.data$Transit
            type.string <- "Transit"
        }
        if(type==4)
        {
            plot.data <- aca.data$Ride-Share
            type.string <- "Ride Share"
        }
        
        #main.lab <- paste0("Avg Credits Accrued/User: ",type.string,sep="")
        main.lab <- type.string
        
        p.y <- barplot(plot.data,
                horiz=T,
                names.arg=as.character(c(1:6)),
                main=main.lab,
                xlab="",ylab="",
                width=.1, space = .3,
                cex.names=0.8,las=1,
                col="deepskyblue",
                col.main ="gray20",
                border=NA,
                font.lab=2,
                font.axis=1)
        
        plot.data.formatted <- sapply(plot.data,round,digits=2)
        
        text(x = plot.data, y = p.y, label = plot.data.formatted, 
             pos = 4, cex = 0.8, col = "red")
             
        # finish up the rest of the plot
        x.lim <- round(1.1 * max(plot.data))
        axis(side=1,at=seq(0,x.lim + 1,by=round(x.lim/6)),las=0,font.axis=1)
        
        p <- recordPlot()
        
        #p.x <- barplot(plot.data,
        #               names.arg=as.character(c(1:6)),
        #               xlab="Months Prior",
        #               yaxt="n",
        #               ylab="Avg Credits Accrued per User",
        #               main="Bike",
        #               ylim=c(0,1.1 * max(plot.data)),
        #               cex.names=0.7,las=2,
        #               col="lightblue",
        #               border=NA,
        #               font.lab=2,
        #               font.axis=2)
        
        # add exact nos for each value atop each bar
        #text(x = p.x, y = plot.data, label = plot.data, 
        #     pos = 3, cex = 0.8, col = "red")
        
        #finish up the rest of the plot
        #axis(side=2,at=seq(0,round(max(plot.data),digits=2),by=5),las=0,font.axis=1)
        
        #p <- record.plot()
    }
    
    getSummary <- function(input)
    {
        text.summary <- "No information available"
        
        zip <- input$selRegion
        zip.data.transit <- transit.data[transit.data$zip == zip,]
        
        if(!is.null(zip.data.transit))
        {
            text <- paste0("Usage histories and key statistics for zip code: <b>",zip,"</b>",sep="")
            text.summary <- text
        }
        
        text.summary
    }
    
    
    output$tabStats1 <-  renderTable({
        getTable(input)}, include.rownames=FALSE, digits=0
    )
    
    output$tabHeading <- renderUI({HTML("<b>Average Credits Accrued per User</b>&nbsp(last 6 months)")})
    
    output$tabStats2 <-  renderTable({
        getACATable(input)}, include.rownames=TRUE, digits=2
    )
    
    output$tabHeading2 <- renderUI({HTML("<b>Average Credits Accrued per User</b>&nbsp(last 6 months)")})
    
    output$tabPlot1 <- renderPlot({
        
        p <- plotACATrend(input,1)
    })
    
    output$tabPlot2 <- renderPlot({
        
        p <- plotACATrend(input,3)
    })
    
    output$tabSummary <-  renderUI({
    
        #text.summary <- " "
        text.summary <- getSummary(input)
        HTML(paste("<br><br>",text.summary,sep=""))
    })
    
} 

shinyServer(server)