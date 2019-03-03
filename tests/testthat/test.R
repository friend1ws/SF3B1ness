context("SF3B1ness score test")

test_that("SF3B1ness_recount2", {
  recount2_junction_coverage <- system.file("extdata/recount2/SRP056033.junction_coverage.tsv.gz", package="SF3B1ness")
  SF3B1ness_recout2 <- SF3B1ness_recount2(recount2_junction_coverage)
  expect_equal(SF3B1ness_recout2$Score[1], 2970.10654, tolerance = 0.01, scale = 1)
  expect_equal(SF3B1ness_recout2$Score[2], 1393.82765, tolerance = 0.01, scale = 1)
  expect_equal(SF3B1ness_recout2$Score[3], -54.03809, tolerance = 0.01, scale = 1)
  expect_equal(SF3B1ness_recout2$Score[4], 2257.09786, tolerance = 0.01, scale = 1)
  expect_equal(SF3B1ness_recout2$Score[5], -1026.42436, tolerance = 0.01, scale = 1)
  expect_equal(SF3B1ness_recout2$Score[6], 3327.38061, tolerance = 0.01, scale = 1)
  expect_equal(SF3B1ness_recout2$Score[7], -767.68221, tolerance = 0.01, scale = 1)
  expect_equal(SF3B1ness_recout2$Score[8], 3095.03185, tolerance = 0.01, scale = 1)
})

test_that("SF3B1ness_SJ", {
  SJ_file1 <- system.file("extdata/SJ_hg19/CCLE-MUTZ-3-RNA-08.SJ.out.tab", package="SF3B1ness")
  SF3B1ness_SJ1 <- SF3B1ness_SJ(SJ_file1)
  expect_equal(SF3B1ness_SJ1$Score[1], 983.4035, tolerance = 0.01, scale = 1)

  SJ_file2 <- system.file("extdata/SJ_hg19/CCLE-MUTZ-5-RNA-08.SJ.out.tab", package="SF3B1ness")
  SF3B1ness_SJ2 <- SF3B1ness_SJ(SJ_file2)
  expect_equal(SF3B1ness_SJ2$Score[1], -1204.27, tolerance = 0.01, scale = 1)
})
