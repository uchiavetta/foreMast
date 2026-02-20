nc_to_monthly_csv <- function(ncfile, lat, lon, outfile) {

  r <- rast(ncfile)

  # Détection automatique des variables
  varname <- names(r)[1]   # ex: "t2m_valid_time=-946771200"

  # Extraction du nom de variable (avant "_valid_time")
  basevar <- sub("_valid_time.*", "", varname)

  # Extraction des dates depuis les noms de couches
  dates <- as.numeric(sub(".*valid_time=", "", names(r)))
  dates <- as_datetime(dates)

  # Extraction au point
  pt <- vect(cbind(lon, lat), crs = crs(r))
  values <- extract(r, pt)[1, -1]

  df <- data.frame(
    date = dates,
    var  = as.numeric(values)
  )

  df$year  <- year(df$date)
  df$month <- month(df$date)

  write.csv(df, outfile, row.names = FALSE)
  message("CSV créé : ", outfile)
}
