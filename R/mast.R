mast <- function(year.list, filePath){

  nc <- ncdf4::nc_open(filePath)

  # ##creazione delle time series delle variabili climatiche
  t2m <- ts(ncdf4::ncvar_get(nc, varid= "t2m" )-273.15, frequency = 12, start = c(as.numeric(year.list[[1]][1]), 1))
  tp <- ts(ncdf4::ncvar_get(nc, varid= "tp" )*1000, frequency = 12)

  Tmean.df <- data.frame(.preformat.ts(t2m),stringsAsFactors = FALSE) #cambio la classe in data.frame
  Tmean.s <- t <- (as.numeric(Tmean.df$Jun) + as.numeric(Tmean.df$Jul) + as.numeric(Tmean.df$Aug))/3

  P.df <- data.frame(.preformat.ts(tp),stringsAsFactors = FALSE)
  P.s <- p <- (as.numeric(P.df$Jun) + as.numeric(P.df$Jul) + as.numeric(P.df$Aug))/3

  # #funzione fuzzy OK
  # #st1 e' lo score a t-1, e' tanto maggiore quanto e' alto il percentile in T e basso in P
  # #st2 e' lo score a t-2, e' tanto maggiore quanto e' basso il perentile in T e alto in P
  # #wt e wp sono i pesi da dare a T (variabile primaria) e P (variabile secondaria) di default impostato 2:1
  # # t = vettore con le temperature medie estive (mesi: attualmente Giu, Lug, Ago... ma e' possibile variare)
  # # p = come sopra ma precipitazione (cumulata o media ? indifferente)
  # # hist.p = pasciona storica (se disponibile), altrimenti viene considerata la probabilit? stimata. Viene
  # #          considerato il complementare al quadrato del percentile di questa serie.
  # #          Deve essere di lunghezza pari a t e p
  # # syear =  l'anno in cui iniziano le osservazioni, se omesso, viene automaticamente calcolato
  # #         considerando l'ultima osservazione di t e p come relative all'attualit?
  # # wsp = peso della pasciona dell'anno precedente sullo score attuale
  ffst0 <- function(t, p, hist.p=NULL, wt=2, wp=1,
                    syear=as.numeric(format(Sys.Date(), "%Y")) - length(t),
                    wsp = 0.5){
    if(length(t)!=length(p)){
      options(error = NULL)
      stop("Error: t and p must have same length")
    } else {
      st1 <- (wt*(percent_rank(lag(t,0)))+wp*(1-percent_rank(lag(p,0))))/(wp+wt)
      st2 <- (wt*(1-percent_rank(lag(t,1)))+wp*(percent_rank(lag(p,1))))/(wp+wt)
      st0 <- round((st2+st1)/2,2)
      if(is.null(hist.p)){
        sp <- (1-(percent_rank(lag(c(st0,0.5), 1)))[-1]^2) #sp teorico
      } else {
        lhp <- length(hist.p)
        spt <- (1-(percent_rank(lag(c(st0,0.5), 1)))[-1]^2) #sp teorico
        spt <- head(spt, lhp)
        sp <- c(spt, sph)
      }
      st0p <- round(percent_rank((st2+st1+wsp*sp)/(2+wsp)),2)
      years <- (syear+2):(syear+length(t))
      return(data.frame('Year' = as.character(years), 'prob' = (st0p[-1])))
    }

  }

  st0s <- ffst0(t=t, p=p, syear = 1981)

  # mast_plot <- ggplot2::ggplot(st0s, aes(x = Year, y = prob, group = 1)) +
  #   geom_point() +
  #   geom_line(color = "red") +
  #   annotate('rect', xmin = -Inf, xmax = Inf, ymin = .75, ymax = 1, alpha = .2, fill = 'darkgreen') +
  #   annotate('rect', xmin = -Inf, xmax = Inf, ymin = .5, ymax = .75, alpha = .2, fill = 'green') +
  #   annotate('rect', xmin = -Inf, xmax = Inf, ymin = 0, ymax = .5, alpha = .2, fill = 'lightgreen') +
  #   ggtitle('Yearly mast event probability') +
  #   theme_bw() %+replace% theme(text = element_text(size=15),
  #                               axis.text.x = element_text(angle = 90, vjust = 0.5, size=11))
  return(st0s)
}



