# ---------------------------------------------------------------------------
# Nom : Gestion forestière
# Creation : 03/02/2026
# Modification : 20/02/2026
# Auteur(s) : Jéros VIGAN
# Projet : Prédire le "masting" du hêtre avec un script R
# ---------------------------------------------------------------------------

# ===============================================================
# Lecture des arguments du batch
# ===============================================================
args <- commandArgs(trailingOnly = TRUE)

parse_arg <- function(flag) {
  idx <- which(args == flag)
  if (length(idx) == 0) return(NA)
  return(args[idx + 1])
}

lat   <- as.numeric(parse_arg("--lat"))
lon   <- as.numeric(parse_arg("--lon"))

cat("Arguments reçus :\n")
print(list(lat=lat, lon=lon))
Sys.sleep(2)

# =============================================================================
#  Debut du traitement
# =============================================================================
start.time <- Sys.time()

args_full <- commandArgs(trailingOnly = FALSE)
file_arg <- grep("--file=", args_full, value = TRUE)

if (length(file_arg) == 0) { stop("Impossible de détecter le chemin du script.") }

script_path <- normalizePath(sub("--file=", "", file_arg))
dir_setup <- dirname(script_path)
base <- normalizePath(dirname(dir_setup))

cat("Chemin du script :", script_path, "\n")
cat("Répertoire de base :", base, "\n")
Sys.sleep(2)

# =============================================================================
#  IMPORTATION DES MODULES
# =============================================================================
if(!require("pacman")){
  suppressMessages(install.packages("pacman"))
  suppressMessages(library("pacman"))
}
suppressMessages(p_load("foreMast","terra","dplyr","lubridate"))

# =============================================================================
# Fonctions
# =============================================================================
path_function<-normalizePath(file.path(base,'cmd',"_functions","functions.R"), mustWork = FALSE)
source(path_function)

# =============================================================================
# DECLARATION DU DOSSIER DE TRAVAIL
# =============================================================================
setwd(base)
paste("le dossier de travail est:",getwd())
#paste("le fichier", list.files(), "se trouve dans ce dossier")
Sys.sleep(2)

# =============================================================================
# IMPORTATION DES DONNÉES
# =============================================================================
file1 <- normalizePath(file.path(base,"data",format(Sys.time(), "%Y%m%d"),"_zip","data_stream-moda_stepType-avgua.nc"), mustWork = FALSE)
file2 <- normalizePath(file.path(base,"data",format(Sys.time(), "%Y%m%d"),"_zip","data_stream-moda_stepType-avgad.nc"), mustWork = FALSE)

nc1 <- ncdf4::nc_open(file1)
nc2 <- ncdf4::nc_open(file2)

r <- rast(file1)
names(r)
res(r)
ext(r)
Sys.sleep(2)

r <- rast(file2)
names(r)
res(r)
ext(r)
Sys.sleep(2)

# =============================================================================
# Conversion en CSV
# =============================================================================
dir <- normalizePath(file.path(base,"data",format(Sys.time(), "%Y%m%d"),"_csv"), mustWork = FALSE)

if (!dir.exists(dir)) {success <- dir.create(dir, recursive = TRUE, showWarnings = FALSE)}

csv1<-normalizePath(file.path(base,"data",format(Sys.time(), "%Y%m%d"),"_csv","avgua.csv"), mustWork = FALSE)
csv2<-normalizePath(file.path(base,"data",format(Sys.time(), "%Y%m%d"),"_csv","avgad.csv"), mustWork = FALSE)

lat=44.549255
lon=2.93311

nc_to_monthly_csv(file1, lat, lon, csv1)
nc_to_monthly_csv(file2, lat , lon, csv2)
Sys.sleep(2)

# ===============================================================
# Jointure des données
# ===============================================================
df1 <- read.csv(csv1)
df2 <- read.csv(csv2)

# ETL sur les dates
df1$date <- as.Date(df1$date)
df2$date <- as.Date(df2$date)

head(df1,5)
head(df2,5)
Sys.sleep(2)

#Joint
df_join <- df1 %>%
  inner_join(df2, by = c("date", "year", "month"), suffix = c("_a", "_d"))

head(df_join,5)
Sys.sleep(2)

df_join$t2m <- df_join$var_a - 273.15
df_join$tp  <- df_join$var_d * 1000

df_summer <- df_join %>%
  filter(month %in% c(6,7,8)) %>%
  group_by(year) %>%
  summarise(
    tmean = mean(t2m),
    pmean = mean(tp)
  )

head(df_summer,5)
Sys.sleep(2)

# ===============================================================
# Traitement
# ===============================================================
fName <- normalizePath(file.path(base,"data",format(Sys.time(), "%Y%m%d"),"_csv","climat_foremast.csv"), mustWork = FALSE)
write.csv(df_summer, fName, row.names = FALSE)

# Classification
mast = mastFaSyl(fName, weighting = "standard")

# Graphique
chart = probPlot(prediction = mast)
plot(chart)
Sys.sleep(2)

# ===============================================================
# Sauvegarde du graphique en PNG
# ===============================================================
out_dir <- normalizePath( file.path(base, "livrable", format(Sys.time(), "%Y%m%d")), mustWork = FALSE )
if (!dir.exists(out_dir)) {success <- dir.create(out_dir, recursive = TRUE, showWarnings = FALSE)}

timestamp <- format(Sys.time(), "%Y%m%d_%H%M%S00")
png_file <- normalizePath(file.path(base, "livrable", format(Sys.time(), "%Y%m%d"), paste0(timestamp, "_chart_foremast.png")),mustWork = FALSE)

png(filename = png_file, width = 1600, height = 1000, res = 150)
plot(chart)
dev.off()

cat("\nGraphique sauvegardé dans :", png_file, "\n")
Sys.sleep(2)

# =============================================================================
#  Fin du traitement
# =============================================================================
end.time <- Sys.time()
time.taken <- round(end.time - start.time,2)
print('\nFIN')
paste("\nla durée de traitement est:",time.taken)
