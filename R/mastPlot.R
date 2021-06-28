#' @title Plots the calculated mast probability of a site
#'
#' @description Plot the calculated mast probability on a line chart.
#'
#' @param prediction It is the table returned by the mastFaSyl function
#'
#' @importFrom ggplot2 "%+replace%"
#'
#' @return Returns the plot with a line chart of the predicted mast event probability
#'
#' @examples data <- mastFaSyl("inst/85930_t2p_tp.nc")
#' finalPlot <- mastPlot(data)
#'
#' @export
mastPlot <- function(prediction){
  Year <- prob <- NULL
  mast_plot <- ggplot2::ggplot(prediction, ggplot2::aes(x = Year, y = prob, group = 1)) +
    ggplot2::geom_point() +
    ggplot2::geom_line(color = "red") +
    ggplot2::annotate('rect', xmin = -Inf, xmax = Inf, ymin = .75, ymax = 1, alpha = .2, fill = 'darkgreen') +
    ggplot2::annotate('rect', xmin = -Inf, xmax = Inf, ymin = .5, ymax = .75, alpha = .2, fill = 'green') +
    ggplot2::annotate('rect', xmin = -Inf, xmax = Inf, ymin = 0, ymax = .5, alpha = .2, fill = 'lightgreen') +
    ggplot2::ggtitle('Yearly mast event probability') +
    ggplot2::theme_bw() %+replace% ggplot2::theme(text = ggplot2::element_text(size=10),
                                                    axis.text.x = ggplot2::element_text(angle = 90, vjust = 0.5, size= 9))
  return(mast_plot)
}
