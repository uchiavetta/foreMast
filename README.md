# foreMast
This package is a tool that can be used to forecast masting events of European beech (Fagus sylvatica L.) based on climatic cues

## Installation
The package can be installed typing:
```r
devtools::install_github("uchiavetta/foreMast")
```
The package is composed by three functions:

###a) cdsDownload(U_ID, API_KEY, lat, lon, sPath, site = "")
This function allow to download climatic data of the monthly average temperatures and total precipitations. The       data come from the "ERA5-Land monthly averaged data from 1981 to present". They are downloaded via the Copernicus
CDS API, therefore the registration is required (https://cds.climate.copernicus.eu/#!/home).
On the user page, the UID and API KEY are reported, which are neded as parameters for the function that works as follow:
```r
user = "xxxxx" 
key = "xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx" #use the UID and the API key in your Copernicus CDS User profile
N = 43.2 
E = 11.3 #for southing and westing coordinates use negative values
siteName = "random_place" # 
sPath = "~/download" #insert the path for the directory where the file should be downloaded

```

