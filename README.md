# 📘 Pipeline foreMast : Téléchargement API CDS , Traitement R > Graphiques de prédiction

## 📌 Contexte
Cette amélioration ajoute au projet *foreMast* un pipeline complet permettant :

    - de télécharger automatiquement les données climatiques ERA5 via la **nouvelle API Copernicus CDS** ;
    - de traiter ces données avec le package R `foreMast` ;
    - de générer automatiquement les prédictions de masting et les graphiques associés ;
    - d’orchestrer l’ensemble via un **script Batch Windows**.

Ce pipeline vise à faciliter l’utilisation du modèle foreMast par des utilisateurs non experts, tout en garantissant une reproductibilité complète.

---

# 🧱 Architecture du pipeline
```bat
foreMast/
 ├── cmd/
 │    ├── install_python_libs.bat
 │    ├── run_pipeline.bat
 │    ├── script_download.py
 │    └── script_traitement.R
 ├── data/
 │    └── YYYYMMDD/
 │          ├── _zip/
 │          └── _csv/
 ├── livrable/
 │    └── YYYYMMDD/
 │          └── <timestamp>_chart_foremast.png
 ├── dossier/
 │    └── _functions/
 │          └── functions.R
 └── README.md
 ```
---
# ⚙️ 1. Installation des dépendances Python
Le script `install_python_libs.bat` installe automatiquement les bibliothèques nécessaires.

## 📌 Configuration préalable
Modifier le chemin absolu de Python :

```bat
    set PYTHON="D:\tools\WPy64-31180\python-3.11.8.amd64\python.exe"
```
cmd\install_python_libs.bat

```bat
Modules installés :
    cdsapi
    zipfile (stdlib)
    json (stdlib)
    datetime (stdlib)
    time (stdlib)
```
---
# ⚙️ 2. Script Python - Téléchargement via API CDS
Le script script_download.py :

    - lit les arguments : latitude, longitude, clé API ;
    - construit un rectangle géographique autour du point ;
    - télécharge les données ERA5 mensuelles ;
    - décompresse les fichiers NetCDF ;
    - organise les données dans data/YYYYMMDD/.

## 📌 Arguments
| Argument|Description|
| ----------- | ----------- |
| lat|Latitude|
| lon|Longitude|
| API_KEY|Clé CDS (format : uid:apikey)|

##  📌 Exemple
```bat
    python script_download.py 44.5 2.9 "12345:abcdefg-1234"
```
---

# ⚙️ 3. Script R - Traitement & prédiction foreMast
Le script script_traitement.R :

    * lit les arguments --lat et --lon ;
    * localise automatiquement le répertoire du projet ;
    * convertit les NetCDF en CSV ;
    * joint les données climatiques ;
    * calcule les moyennes estivales ;
    * génère la prédiction via mastFaSyl() ;
    * produit un graphique via probPlot() ;
    * sauvegarde le PNG dans livrable/YYYYMMDD/.

## 📌 Arguments
|Argument	| Description |
| ----------- | ----------- |
|--lat	| Latitude |
|--lon	| Longitude |

##  📌 Exemple
```bat
    Rscript script_traitement.R --lat 44.5 --lon 2.9
```
---
# ⚙️ 4. Script Batch principal - Orchestration du pipeline
Le script run_pipeline.bat :
 - demande à l’utilisateur :
     - latitude
     - longitude
     - clé API

 - exécute le script Python ;
 - exécute le script R.

## 📌 Paramétrage des chemins
```bat
    set PYTHON="D:\tools\WPy64-31180\python-3.11.8.amd64\python.exe"
    set RSCRIPT="C:\Users\...\R\R-4.4.0\bin\Rscript.exe"
```
## 📌 Exécution
cmd\run_pipeline.bat

---

# 🧪 5. Exemple de flux complet
1. L’utilisateur lance run_pipeline.bat.

2. Il saisit :
    |Argument	| Description |
    | ----------- | ----------- |
    |latitude  | 44.55|
    |longitude | 2.93|
    |clé API | uid:apikey|

3. Le script Python télécharge ERA5 → data/YYYYMMDD/.

4. Le script R :

    - convertit les NetCDF en CSV,
    - calcule les indicateurs climatiques,
    - génère la prédiction,
    - produit un graphique PNG.

5. Le résultat final est disponible dans :

    livrable/YYYYMMDD/<timestamp>_chart_foremast.png

---

# 📦 6. Dépendances
Python

    - Python ≥ 3.10
    - cdsapi
    - zipfile
    - json
    - datetime

R

    R ≥ 4.2
    Packages :
        - foreMast
        - terra
        - dplyr
        - lubridate
        - ncdf4
        - pacman
---

# 🧭 7. Points d’intégration pour les mainteneurs
Cette contribution :

    - n’altère pas les fonctions internes du package foreMast ;
    - ajoute un pipeline optionnel, simple à utiliser ;
    - respecte l’architecture existante ;
    - facilite la reproductibilité des analyses climatiques ;
    - prépare le terrain pour une automatisation future (CI/CD).
---

🙌 8. Remerciements

Merci aux mainteneurs du projet foreMast pour leur travail.
Cette contribution vise à enrichir l’écosystème en facilitant l’accès aux données climatiques et en automatisant la chaîne de prédiction.