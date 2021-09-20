test_that("plots the char of the predicted mast probability", {
  plot_probability <- probPlot(mastFaSyl("85930_t2s_tp.nc", weighting = "auto"))
  plot(plot_probability)
})
