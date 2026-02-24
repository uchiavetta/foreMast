# -*- coding: utf-8 -*-
"""
# ---------------------------------------------------------------------------
# Nom : Gestion forestière
# Creation : 03/02/2026
# Modification : 20/02/2026
# Auteur(s) : Jéros VIGAN
# Projet : Prédire le "masting" du hêtre avec un script R
# Description : Ce script permet de se connecter à l'API https://cds.climate.copernicus.eu/datasets pour télécharger des données.
# ---------------------------------------------------------------------------
"""
### ===============================================================
### Importation des packages
### ===============================================================
import os
import sys
import json
import time
import zipfile
from datetime import datetime
import cdsapi

### ===============================================================
### Fonctions
### ===============================================================

def cdsDownload(API_Key: str, areaL: list, path: str, start_year: int = 1940):
	print("\nTéléchargement des données depuis : {} avec l'API : {}\n".format(
		"https://cds.climate.copernicus.eu/datasets","https://cds.climate.copernicus.eu/api"))

	#Paramètres
	URL = 'https://cds.climate.copernicus.eu/api'
	end_year = int(datetime.now().strftime("%Y"))
	yearL: list = [str(x) for x in range(start_year, end_year)]
	monthL: list = [f"{m:02d}" for m in range(1, 13)]
	target = os.path.join(path, 'monthly_averaged_reanalysis.zip')
	dataset = 'reanalysis-era5-single-levels-monthly-means'

	#Requete
	client = cdsapi.Client(url=URL, key=API_Key)
	request = {
            'product_type': ['monthly_averaged_reanalysis'],
         	  'variable': ["2m_temperature", "total_precipitation"],
         	  'year': yearL,
         	  'month': monthL,
         	  'time': ['00:00'],
         	  'data_format': 'netcdf',
         	  "area": areaL
	}
	client.retrieve(dataset, request, target)
	return target


def zipfilecdsDownload(file, path: str):
    if not zipfile.is_zipfile(file):
        print("Le fichier téléchargé est un NetCDF valide")
    else:
        print("\nLe fichier téléchargé est un ZIP, extraction en cours...")
        if not os.path.exists(path):
            os.makedirs(path)

        with zipfile.ZipFile(file, "r") as z:
          z.extractall(path)

          print(
              "\nExtraction terminée. Fichiers disponibles dans : {}\n".format(path))
          print("\nContenu extrait :")
          for f in os.listdir(path):
              print(" -", f)

def rectangle_point(lat,lon):
        #rectangle géographique
        delta = 1 # marge en degrés
        return[ lat + delta, # Nord (N)
                lon - delta, # Ouest (W)
                lat - delta, # Sud (S)
                lon + delta # Est (E)
                ]

#Debut du programme
debut = datetime.now()
file_date = debut.strftime("%Y%m%d")

### ===============================================================
###  Paramètres
### ===============================================================
if len(sys.argv)>1:
    lat:float=float(sys.argv[1])
    lon:float=float(sys.argv[2])
    API_Key:str=sys.argv[3]
else:
    lat=0
    lon=0
    API_Key=''

if lat==0:
    lat:float=float(input("\n=== Merci de saisir la latitude === :  "))

if lon==0:
    lon:float=float(input("\n=== Merci de saisir la longitude === :  "))

if len(API_Key)==0:
    API_Key:str=input("\n=== Merci de saisir la clé de connexion === :  ")

if lat ==0 or lon==0 or len(API_Key)==0:
    sys.exit()
    print("\n les paramètres manquantes !")
    print("\n Fin programme !")

time.sleep(2)

### ===============================================================
### Téléchargement & Dezipper des fichiers
### ===============================================================
areaL: list = rectangle_point(lat,lon)
print("\n-- Latitude :{} -- Longitude : {} -- Zone (rectangle géographique) : {}".format(lat,lon,areaL))
time.sleep(2)

path:str=os.path.abspath(os.path.dirname(os.path.dirname(os.path.realpath("__file__"))))
os.chdir(path)
print('\nle dossier de travail :', os.getcwd())
time.sleep(2)

path: str = os.path.join(path,'data',file_date)
os.makedirs(path, exist_ok=True)

prod = cdsDownload(API_Key, areaL, path, start_year=1940)
time.sleep(2)

path_zip: str = os.path.join(path, "_zip")
zipfilecdsDownload(prod, path_zip)
time.sleep(2)

##Fin du programme
print("\nFIN")
print('\nLa durée de traitement est ' + str(datetime.now() - debut)+"\n")
