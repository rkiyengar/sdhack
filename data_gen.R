
##
## SmartCity Hackathon
##
## Synth Data Generator
##
##

# function to generate synthetic data for city-interface
gen_data <- function()
{
    #zip codes of interest (sample)
    zip.codes <- c(92105,92104,92113,92102,92139,92116,92115,92107,
                   92103,92114,92119,92122,92117,92111,92110)
    
    # DEMOGRAPHIC DATA
    
    # cost of living index
    COL_INDEX_RANGE <- c(0,150)
    # population  per square mile (per zip code)
    # can be obtained from ZCTA - zip code tabulation area; the zip code equivalent of census blocks
    POP_PER_SQ_MILE <- c(100,12000)    
    # average daily travel time (workers 16+) in minutes per area
    ADTT_MINS_AREA_RANGE <- c(10, 180)
    # users of iwcityapp
    USER_COUNT <- c(4000,73000)
    # average credit accurals per user
    ACA_RANGE <- c(0,30)
    
    # traffic counts

    # ridership count
    RIDER_COUNT_RANGE <- c(0,20000)
    
    # streets per zip code
    ROUTE_ID_RANGE <- c(1, 30)
    
    STSZ <- ROUTE_ID_RANGE[2]
    SZ <- length(zip.codes) 
    
    # general data
    transit.data <- data.frame(zip=zip.codes,
                               ppsqm=as.integer(runif(SZ,POP_PER_SQ_MILE[1],POP_PER_SQ_MILE[2])),
                               col.index=as.integer(runif(SZ,COL_INDEX_RANGE[1],COL_INDEX_RANGE[2])),
                               user.count=as.integer(runif(SZ,USER_COUNT[1],USER_COUNT[2])),
                               adtt=as.integer(runif(SZ,ADTT_MINS_AREA_RANGE[1],ADTT_MINS_AREA_RANGE[2])))
    
    # function to generate 6-month avg accrued credits data for the 
    # given zip code
    genACAData <- function(zip.in)
    {
        zipcode.data.credits <- data.frame(
            zip=rep(zip.in,6),
            total=runif(6,ACA_RANGE[1],ACA_RANGE[2]),
            bike=runif(6,ACA_RANGE[1],ACA_RANGE[2]/3),
            walk=runif(6,ACA_RANGE[1],ACA_RANGE[2]/5),
            transit=runif(6,ACA_RANGE[1],ACA_RANGE[2]/4),
            ride=runif(6,ACA_RANGE[1],ACA_RANGE[2]/10)                   
        )
    }
    
    # zip specific data
    zipcode.data.aca <- as.data.frame(do.call(rbind,sapply(zip.codes,genACAData,simplify = FALSE)))
    
    zipcode.data.street <- data.frame(street=c(ROUTE_ID_RANGE[1]:ROUTE_ID_RANGE[2]),
                                      rider.count=as.integer(runif(STSZ,RIDER_COUNT_RANGE[1],RIDER_COUNT_RANGE[2])))
    
    save(transit.data,zipcode.data.aca,zipcode.data.street,file = "./iwcityapp.RData")
}





