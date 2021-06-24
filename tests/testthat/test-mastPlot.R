test_that("plots the char of the predicted mast probability", {
  probPlot <- mastPlot(mastFaSyl("inst/85930_t2s_tp.nc"))
  plot(probPlot)
})
