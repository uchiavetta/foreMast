<img src="inst/logo_foreMast.png" width="100">

# foreMast



This package is a tool that can be used to forecast masting events of European beech (*Fagus sylvatica L.*) based on monthly climatic cues (precipitation and mean temperature) which are available from the Copernicus ERA-5 Climate Data Hub

## Installation
The package can be installed typing:
```r
devtools::install_github("uchiavetta/foreMast")
```

## Functions
The package is composed by three functions:

### a) cdsDownload(U_ID, API_KEY, lat, lon, sPath, site = "")
This function allow to download the data of the monthly average temperatures and total precipitations, from 1981 to the current date. The data come from the "ERA5-Land monthly averaged data from 1981 to present". They are downloaded via the Copernicus CDS API, therefore the registration is required (https://cds.climate.copernicus.eu/#!/home).
On the user page, the UID and API KEY are reported, which are needed as parameters for the function that works as follow:
```r
user = "xxxxx" 
key = "xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx" #use the UID and the API key in your Copernicus CDS User profile
N = 43.2 
E = 11.3 #for southing and westing coordinates use negative values
siteId = "siteName" #it will be attached to the name of the file to be downloaded, along with the user id
dir = "~/download" #insert the path for the directory where the file should be downloaded

cdsDownload(U_ID = user, API_KEY = key, lat = N, lon = E, sPath = dir, site = "")
```
After that, a file with the NetCDF extension (.nc) will be saved in the directory passed as parameter, containing all the neded data.

### b) mastFaSyl(fName)
This function is the core of the package and contains the algorithm that calculate the mast probability, given the downloaded file with the climate cues, returning as output a table with one column containing the year series and a second one with the predicted probability (calculated as percent rank):

```r
data = "~/download/xxxxx_siteName_t2p_tp.nc"
mast = mastFaSyl(fName = data)
```
### c) mastPlot(prediction)
This third function takes the previous function output and plots it returning a line chart divided in three main areas: 
1. a lightgreen one for the values that go from 0 to 0.5 (low seed production probability); 
2. a green one for the values between 0.5 and 0.75 (medium seed production probability);
3. a darkgreen one for the values that go from 0.75 and 1 (high/very high large seed production probability).

```r
mast = mastFaSyl(fName = data)
chart = mastPlot(prediction = mast)
plot(chart)
```
<img src="inst/examplot.png" width="400">
