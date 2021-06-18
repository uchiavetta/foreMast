#' @title Plots the calculated mast probability of a site
#'
#' @description Plot the calculated mast probability on a line chart. The plot can be saved as pdf setting
#'              printPlot = TRUE
#'
#' @param predictionT It is the table returned by the mastBeech function
#' @param printPlot To print the plot as pdf, set the parameter to TRUE (FALSE by default)
#'
#' @importFrom ggplot2 "%+replace%"
#'
#' @return If printPlot == FALSE, returns the plot without printing it
#'
#'@export
mastPlot <- function(predictionT, printPlot = FALSE){
  Year <- prob <- NULL
  if (printPlot == FALSE){
    mast_plot <- ggplot2::ggplot(predictionT, ggplot2::aes(x = Year, y = prob, group = 1)) +
      ggplot2::geom_point() +
      ggplot2::geom_line(color = "red") +
      ggplot2::annotate('rect', xmin = -Inf, xmax = Inf, ymin = .75, ymax = 1, alpha = .2, fill = 'darkgreen') +
      ggplot2::annotate('rect', xmin = -Inf, xmax = Inf, ymin = .5, ymax = .75, alpha = .2, fill = 'green') +
      ggplot2::annotate('rect', xmin = -Inf, xmax = Inf, ymin = 0, ymax = .5, alpha = .2, fill = 'lightgreen') +
      ggplot2::ggtitle('Yearly mast event probability') +
      ggplot2::theme_bw() %+replace% ggplot2::theme(text = ggplot2::element_text(size=15),
                                                    axis.text.x = ggplot2::element_text(angle = 90, vjust = 0.5, size=11))
    return(mast_plot)
  } else {
    grDevices::pdf("mast prediction.pdf", width = 8.3, height = 11.7)
    mast_plot <- ggplot2::ggplot(predictionT, ggplot2::aes(x = Year, y = prob, group = 1)) +
      ggplot2::geom_point() +
      ggplot2::geom_line(color = "red") +
      ggplot2::annotate('rect', xmin = -Inf, xmax = Inf, ymin = .75, ymax = 1, alpha = .2, fill = 'darkgreen') +
      ggplot2::annotate('rect', xmin = -Inf, xmax = Inf, ymin = .5, ymax = .75, alpha = .2, fill = 'green') +
      ggplot2::annotate('rect', xmin = -Inf, xmax = Inf, ymin = 0, ymax = .5, alpha = .2, fill = 'lightgreen') +
      ggplot2::ggtitle('Yearly mast event probability') +
      ggplot2::theme_bw() %+replace% ggplot2::theme(text = ggplot2::element_text(size=15),
                                                    axis.text.x = ggplot2::element_text(angle = 90, vjust = 0.5, size=11))
    grDevices::dev.off()
  }

}
