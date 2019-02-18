#' Information on SF3B1 associated splicing junctions
#'
#' A dataset containing various information (recount2 junction ID, coordinates
#' and parameter for zero-inflated beta-binomial (ZIBB) distributions) on
#' SF3B1 associated splicing junctions and their normal counter parts.
#'
#'
#' @format A data frame with 575 rows and 12 variables:
#' \describe{
#'   \item{Junction_ID_Alt}{Recount2 junction ID for SF3B1 associated splicing junction}
#'   \item{Junction_ID_Ref}{Recount2 junction ID for corresponding normal splicing junction}
#'   \item{Junction_Key_Alt_GRCh38}{GRCh38 coordinates for SF3B1 associated splicing junction}
#'   \item{Junction_Key_Ref_GRCh38}{GRCh38 coordinates for corresponding normal splicing junction}
#'   \item{Junction_Key_Alt_GRCh37}{GRCh37 coordinates for SF3B1 associated splicing junction}
#'   \item{Junction_Key_Ref_GRCh37}{GRCh37 coordinates for corresponding normal splicing junction}
#'   \item{Alpha_0}{The 1st shape parameter of ZIBB distribution for wild type SF3B1}
#'   \item{Beta_0}{The 2nd shape parameter of ZIBB distribution for wild type SF3B1}
#'   \item{Pi_0}{The zero point-mass parameter of ZIBB distribution for wild type SF3B1}
#'   \item{Alpha_1}{The 1st shape parameter of ZIBB distribution for mutant type SF3B1}
#'   \item{Beta_1}{The 2nd shape parameter of ZIBB distribution for mutant type SF3B1}
#'   \item{Pi_1}{The zero point-mass parameter of ZIBB distribution for mutant type SF3B1}
#' }
#' @source \url{https://github.com/friend1ws/SF3B1ness/data-raw/SF3B1_associated_junction_info.txt}
"SF3B1_info"


#' Information on recount2 samples
#'
#' A dataset containing recount2 sample ID, SRA project ID and SRA run ID
#' for each sample analyzed in recount2.
#'
#'
#' @format A data frame with 71,111 rows and 3 variables:
#' \describe{
#'   \item{X1}{Recount2 sample ID}
#'   \item{X2}{SRA project ID}
#'   \item{X3}{SRA run ID}
#' }
#' @source \url{https://github.com/friend1ws/SF3B1ness/data-raw/sample_ids.tsv}
"Sample_ID_info"
