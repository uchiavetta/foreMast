cdsDownload <- function(U_ID, API_Key, lat, lon, sPath){

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
    target = paste0(lat, "_", lon, "_t2s_tp.nc")
  )

  file <- ecmwfr::wf_request(
    user = U_ID,
    request = request,
    transfer = TRUE,
    path = sPath,
  )

}
