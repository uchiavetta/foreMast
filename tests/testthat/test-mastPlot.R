test_that("plots the char of the predicted mast probability", {
  probPlot <- mastPlot(mastFaSyl("C:/Users/seba_/Documents/foreMast/inst/85930_t2s_tp.nc"))
  plot(probPlot)
})
