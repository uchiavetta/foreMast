#' @title Beech mast probability calculation
#'
#' @description Calculate the mast probability over a time series, including the current year,
#' using as input the file downloaded from the Copernicus CDS API or a csv file with local data or observations.
#'
#' @param fName The name of the netCDF file to be loaded or the csv file with the climate data.
#' The csv has to be composed by 3 columns, the first one with the years of the observation, the second one
#' with the mean summer temperatures for each year, the last one with the mean precipitations for each year.
#' You can name the columns as you whish, but the column order must mandatorily follow the instruction above!
#'
#' @param lat Only when loading the csv. It is the latitude of the location from where the data were gathered
#'
#' @param lon Only when loading the csv. It is the longitude of the location from where the data were gathered
#'
#' @param autoWeights Y or N: if Y, the weights used to calculate the mast probability are those of the nearest
#' point to the one of interest; if N, the weights used are those that best fit on average among all the field
#' data observed in comparison to the forecast made using the mastFaSyl function (wt = 3 and wt = 1).
#'
#' @return The function returns a table with 2 columns, the first one with the years and the second one with
#' the associated probability of the mast event
#'
#' @examples
#' \dontrun{
#' mastFaSyl("39434_t2p_tc.nc")
#' }
#'
#' @export
mastFaSyl <- function(fName, lat = NULL, lon = NULL, autoWeights = ""){

  distanceFromPoint <- NULL
  # dataset with the data of the Mastree points
  #mt_bioreg <- utils::read.csv("data/mastree_biogeoreg.csv")
  mt_bioreg <- lapply(list.files(system.file('extdata', package = 'foreMast'), pattern = "csv",
                                 full.names = TRUE), utils::read.csv)
  mt_bioreg <- mt_bioreg[[1]]

  if(base::grepl("\\.nc$", fName) == TRUE){

    nc <- ncdf4::nc_open(fName)
    data.years <- ncdf4::ncvar_get(nc,"time")
    lat <- base::round(ncdf4::ncvar_get(nc, "latitude"), 2)
    lon <- base::round(ncdf4::ncvar_get(nc, "longitude"), 2)

    # this function extracts the time from the nc file, converting it from seconds-from-1900 to year
    conversion <- function(x){
      converted <- base::floor((x/24)/365)
      converted <- converted + 1900
    }

    data.year <- base::lapply(data.years, conversion)
    start.year <- data.year[[1]]

    # time series of the climate variables
    t2m <- stats::ts(ncdf4::ncvar_get(nc, varid= "t2m" )-273.15, frequency = 12,
                     start = c(as.numeric(start.year, 1)))
    tp <- stats::ts(ncdf4::ncvar_get(nc, varid= "tp" )*1000, frequency = 12)

    Tmean.df <- data.frame(stats::.preformat.ts(t2m), stringsAsFactors = FALSE) # from time series to data frame
    Tmean.s <- t <- (as.numeric(Tmean.df$Jun) + as.numeric(Tmean.df$Jul) + as.numeric(Tmean.df$Aug))/3

    P.df <- data.frame(stats::.preformat.ts(tp),stringsAsFactors = FALSE)
    P.s <- p <- (as.numeric(P.df$Jun) + as.numeric(P.df$Jul) + as.numeric(P.df$Aug))/3

  } else {
    # this part works when a csv file is passed to the function

    if(is.null(lat) | is.null(lon)){
      stop("Error: please insert lat and lon")
    } else {
      climateDf <- utils::read.csv(fName)
      start.year <- min(climateDf[1])

      t <- climateDf[2][1:nrow(climateDf), ]
      p <- climateDf[3][1:nrow(climateDf), ]
    }

  }

  # st1 is the score at t-1: it is as greater as higher is the percentile of T and lower is the percentile of P
  # st2 is the score at t-2: it is as greater as lower is the percentile in T and higher the percentile in P
  # wt e wp sono i pesi da dare a T (variabile primaria) e P (variabile secondaria) di default impostato 2:1
  # wt and wp are the weight of T and P and depend on those of the nearest points in the mastree dataset, when
  # the same biogeographical region is present, otherwise they are setted with default values (3:1 respectively)
  # t is the array of the mean summer temperatures (June, July, August)
  # p is the array of the mean summer precipitations
  # wsp = weight of the mast event of the previous year on the present score
  ffst0 <- function(t, p, start.year, wt=NULL, wp=NULL, wsp = 0.5){
    if(length(t)!=length(p)){
      options(error = NULL)
      stop("Error: t and p must have same length")
    } else {
      st1 <- (wt*(dplyr::percent_rank(dplyr::lag(t,0)))+wp*(1-dplyr::percent_rank(dplyr::lag(p,0))))/(wp+wt)
      st2 <- (wt*(1-dplyr::percent_rank(dplyr::lag(t,1)))+wp*(dplyr::percent_rank(dplyr::lag(p,1))))/(wp+wt)
      st0 <- round((st2+st1)/2,2)
      sp <- (1-(dplyr::percent_rank(dplyr::lag(c(st0,0.5), 1)))[-1]^2)
      st0p <- round(dplyr::percent_rank((st2+st1+wsp*sp)/(2+wsp)),2)
      years <- (start.year+2):(start.year+length(t))
      return(data.frame('Year' = as.character(years), 'prob' = (st0p[-1])))
    }

  }

  ## checking for the nearest point in the Mastree dataset
  dist.list <- list()
  for(i in 1:nrow(mt_bioreg)){
    dist <- geosphere::distm(c(lon, lat), c(mt_bioreg$lon[i], mt_bioreg$lat[i]), fun = geosphere::distHaversine)
    dist.matrix <- data.frame(id = mt_bioreg$id[i], distanceFromPoint = dist, bioreg = mt_bioreg$biogeoregion[i],
                              b_wt = mt_bioreg$auto_wt[i], b_wp = mt_bioreg$auto_wp[i])
    dist.list[[i]] <- dist.matrix
  }

  bind.df <- dist.list[[1]][0, ]
  for(j in dist.list){
    bind.df <- rbind(bind.df, j)
  }

  # nearest point
  min.distance <- dplyr::filter(bind.df, distanceFromPoint == min(distanceFromPoint))

  if(is.null(autoWeights)){
    stop("Error: please insert Y for the automatic weights or N for those of the nearest point")
  }
  else if(autoWeights == "Y"){
    # application of the function to calculate mast using as wt and wp the best weights auto-combination
    st0s <- ffst0(t=t, p=p, start.year = start.year, wt=3, wp=1)
  }
  else{
    # application of the function to calculate mast using as wt and wp the wheights of the nearest point
    st0s <- ffst0(t=t, p=p, start.year = start.year, wt=min.distance$b_wt, wp=min.distance$b_wp)
  }

  return(st0s)
}
