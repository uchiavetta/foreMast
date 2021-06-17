#' Download of the climate data.
#'
#' Create a .nc file, containing the mean temperature and precipitation records of a defined location,
#' downloaded from the ECMFWR "ERA-5 Land monthly averaged data", via the Copernicus CDS API.
#' Before using, the registration to the Copernicus CDS site is necessary.
#'
#' @param U_ID The user ID for the authentication in the Coprnicus CDS service (string)
#' @param API_Key The key needed to make an API request (string)
#' @param lat The latitude of the site of interest, expressed in decimals with a single decimal value (integer)
#' @param lon The longitude of the site of interest, expressed in decimals with a single decimal value (integer)
#' @param sPath The path of the directory where the file is going to be saved (string)
#'
#' @return
#' @export
#'
#' @examples

cdsDownload <- function(U_ID, API_Key, lat, lon, sPath, site_id = ""){
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
