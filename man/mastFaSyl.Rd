% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/mastFaSyl.R
\name{mastFaSyl}
\alias{mastFaSyl}
\title{Beech mast probability calculation}
\usage{
mastFaSyl(
  fName,
  csv.coordinates = c(NULL, NULL),
  weighting = "",
  weights = c(NULL, NULL),
  adverseEvent = "N"
)
}
\arguments{
\item{fName}{The name of the netCDF file to be loaded or the csv file with the climate data.
The csv has to be composed by 3 columns, the first one with the years of the observation, the second one
with the mean summer temperatures for each year, the last one with the mean precipitations for each year.
You can name the columns as you whish, but the column order must mandatorily follow the instruction above!}

\item{csv.coordinates}{It is an array, containing the values of latitude and longitude for the location to
which the csv refers. It is needed only when using the "auto" mode in the weighting parameter.}

\item{weighting}{A string that states the way the weights are set in the mast algorithm:
\itemize{
\item standard: the weights used are those that best fit on average among all the field data observed in
comparison to the forecast made using the mastFaSyl function (wt = 3 and wt = 1),
\item auto: the weights are automatically taken from those of the nearest point to the one of interest. The reference
points are those of the MASTREE dataset used to compare field observation with forecasts made using the mast
algorithm.
\item manual: the weights are manually inserted as an array of two integer, the first one for the temperature and
the second one for the precipiation.
}}

\item{weights}{Only when weighting is set to manual. It is an array with two integer, the first one with the weight
to be used for the temperatures, and the second one with that for the precipitation.}

\item{adverseEvent}{Y/N string. It is automatically setted to N (no). If there were adverse events to masting such as
late frosts or summer droughts, the parameter has to be set to Y (yes)}
}
\value{
The function returns a table with 2 columns, the first one with the years and the second one with
the associated probability of the mast event
}
\description{
Calculate the mast probability over a time series, including the current year,
using as input the file downloaded from the Copernicus CDS API or a csv file with local data or observations.
}
\examples{
\dontrun{
mastFaSyl("39434_t2p_tc.nc", weighting = standard)
}

}
