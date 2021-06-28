test_that("mastFaSyl calulate the predicted probability of beech mast events for a given site, using as main variables
          the mean summer temperature and precipitation, along with a negative autocorrelation factor", {
           test <-  mastFaSyl("85930_t2s_tp.nc")
           if (is.null(test) == TRUE){
             print("The file can not be open")
           } else {
             print(test)
           }
})
