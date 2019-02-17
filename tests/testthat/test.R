context("SF3B1ness score test")

test_that("SF3B1ness_recount2", {
  recount2_junction_coverage <- system.file("extdata/recount2/SRP056033.junction_coverage.tsv.gz", package="SF3B1ness")
  SF3B1ness_recout2 <- SF3B1ness_recount2(recount2_junction_coverage)
  expect_equal(SF3B1ness_recout2$Score[1], 4072.4567, tolerance = 0.01, scale = 1)
  expect_equal(SF3B1ness_recout2$Score[2], 2371.6221, tolerance = 0.01, scale = 1)
  expect_equal(SF3B1ness_recout2$Score[3], 582.2842, tolerance = 0.01, scale = 1)
  expect_equal(SF3B1ness_recout2$Score[4], 3343.1969, tolerance = 0.01, scale = 1)
  expect_equal(SF3B1ness_recout2$Score[5], -731.3169, tolerance = 0.01, scale = 1)
  expect_equal(SF3B1ness_recout2$Score[6], 4457.2123, tolerance = 0.01, scale = 1)
  expect_equal(SF3B1ness_recout2$Score[7], -504.2580, tolerance = 0.01, scale = 1)
  expect_equal(SF3B1ness_recout2$Score[8], 4156.5764, tolerance = 0.01, scale = 1)
})

test_that("SF3B1ness_SJ", {
  SJ_file1 <- system.file("extdata/SJ_hg19/CCLE-MUTZ-3-RNA-08.SJ.out.tab", package="SF3B1ness")
  SF3B1ness_SJ1 <- SF3B1ness_SJ(SJ_file1)
  expect_equal(SF3B1ness_SJ1$Score[1], 1866.85, tolerance = 0.01, scale = 1)

  SJ_file2 <- system.file("extdata/SJ_hg19/CCLE-MUTZ-5-RNA-08.SJ.out.tab", package="SF3B1ness")
  SF3B1ness_SJ2 <- SF3B1ness_SJ(SJ_file2)
  expect_equal(SF3B1ness_SJ2$Score[1], -559.3431, tolerance = 0.01, scale = 1)
})
