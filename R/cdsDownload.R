#' @title Download of the climate data.
#'
#' @description Create a .nc file, containing the mean temperature and precipitation records of a defined location,
#' downloaded from the ECMFWR "ERA-5 Land monthly averaged data", via the Copernicus CDS API.
#' Before using, the registration to the Copernicus CDS site is required (https://cds.climate.copernicus.eu/#!/home)
#' as well as the acceptance of the terms and conditions here: https://cds.climate.copernicus.eu/cdsapp/#!/terms/licence-to-use-copernicus-products.
#'
#' @param U_ID The user ID for the authentication in the Copernicus CDS service (string)
#' @param API_Key The key needed to make an API request (string)
#' @param lat The latitude of the site of interest, expressed in decimals with a single decimal digit.
#'            For southing latitude values use a negative number (integer)
#' @param lon The longitude of the site of interest, expressed in decimals with a single decimal digit.
#'            For westing longitude values, use a negative number (integer)
#' @param sPath The path of the directory where the file is going to be saved (string)
#' @param site_id Set as empty, it is a string where it is possible to insert the study area id, which will be
#'                reported in the file name
#'
#'@examples
#'\dontrun{
#' user_id <- "39434" #example not working user id
#' user_key <- "0683788m-2136-2716-61g9-g4b97f8e4l1b" #example not working key
#' N <- 44.3
#' E <- 11.2
#
#' cdsDownload(U_ID = user_id, API_Key = user_key, lat = N, lon = E, sPath = dir, site_id = "")
#'}
#'@export
cdsDownload <- function(U_ID, API_Key, lat, lon, sPath = getwd(), site_id = ""){
  cat("\n")
  cat("Check the download request progress at https://cds.climate.copernicus.eu/cdsapp#!/yourrequests")
  cat("\n")
  cat("\n")
  dir.create(sPath, showWarnings = F)
  ecmwfr::wf_set_key(user = U_ID, key = API_Key, service = 'cds')
  start.year = 1981
  end.year = format(Sys.time(), "%Y") #Current year
  yearL = as.character(start.year:end.year)
  monthL = stringr::str_pad(1:12, 2, pad = "0")
  #selezione dei parametri e delle variabili d'interesse
  request <- list(
    format = "netcdf",
    product_type = "monthly_averaged_reanalysis",
    variable = c("2m_temperature", "total_precipitation"),
    year = yearL,
    month = monthL,
    time = "00:00",
    area = c(lat, lon, lat, lon),
    dataset_short_name = "reanalysis-era5-land-monthly-means",
    target = paste0(U_ID, "_", site_id, "_t2s_tp.nc")
  )
  file <- ecmwfr::wf_request(
    user = U_ID,
    request = request,
    transfer = TRUE,
    path = sPath,
  )
}
