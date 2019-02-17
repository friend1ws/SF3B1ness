#' Calculate the density for the zero-inflated beta-binomial distribution
#'
#' @param params The vector of parameters for the zero-inflated beta-inomial distibution.
#' @param s_n The number of trials.
#' @param s_k The number of success.
#' @return The density probability for the input arguments.
get_prob_for_zibb <- function(params, s_n, s_k) {

  p_alpha <- params[1]
  p_beta <- params[2]
  p_pi <- params[3]

  if (s_k == 0) {
    return(p_pi + (1 - p_pi) * VGAM::dbetabinom.ab(0, s_n, p_alpha, p_beta))
  } else {
    return((1 - p_pi) * VGAM::dbetabinom.ab(s_k, s_n, p_alpha, p_beta))
  }

}

#' Calculate the SF3B1ness scores for each sample
#'
#' @param junc_counts_info data frame for Junction_ID, Sample_ID, Junction_Count.
#' @return data frame for Sample_ID and SF3B1ness score.
#'
#' @importFrom magrittr %>%
get_score <- function(junc_counts_info) {

  Sample_ID_list <- unique(junc_counts_info$Sample_ID)
  scores <- c()
  for (i in 1:length(Sample_ID_list)) {

    temp_Junc_couts_info <- junc_counts_info %>% dplyr::filter(Sample_ID == Sample_ID_list[i])

    temp_junc_counts_info2 <- SF3B1_info %>%
      dplyr::left_join(temp_Junc_couts_info, by = c("Junction_ID_Alt" = "Junction_ID")) %>%
      dplyr::left_join(temp_Junc_couts_info, by = c("Junction_ID_Ref" = "Junction_ID")) %>%
      dplyr::select(Alpha_0, Beta_0, Pi_0, Alpha_1, Beta_1, Pi_1, Junction_Count_Alt = Junction_Count.x, Junction_Count_Ref = Junction_Count.y)

    temp_junc_counts_info2$Junction_Count_Alt[is.na(temp_junc_counts_info2$Junction_Count_Alt)] <- 0
    temp_junc_counts_info2$Junction_Count_Ref[is.na(temp_junc_counts_info2$Junction_Count_Ref)] <- 0


    prob0 <- unlist(purrr::map(temp_junc_counts_info2 %>% purrr::transpose(), function(x) {get_prob_for_zibb(c(x$Alpha_0, x$Beta_0, x$Pi_0), x$Junction_Count_Ref + x$Junction_Count_Alt, x$Junction_Count_Alt)}))
    prob1 <- unlist(purrr::map(temp_junc_counts_info2 %>% purrr::transpose(), function(x) {get_prob_for_zibb(c(x$Alpha_1, x$Beta_1, x$Pi_1), x$Junction_Count_Ref + x$Junction_Count_Alt, x$Junction_Count_Alt)}))

    probs <- cbind(prob0, prob1)
    probs[probs < 1e-100] <- 1e-100

    tlratios <- log(probs[,2] / rowSums(probs)) - log(probs[,1])
    tlratios[tlratios < -20] <- -20
    tlratios[tlratios > 20] <- 20

    scores <- c(scores, sum(tlratios))

  }

  return(data.frame(Sample_ID = as.character(Sample_ID_list), Score = scores, stringsAsFactors = FALSE))

}


#' Create the data frame of junctions from recount2 junction coverage files
#'
#' @param junction_coverage_file Junction coverate file obtained from recount2.
#' @return data frame for Junction_ID, Sample_ID and Junction_Count
#'
#' @importFrom magrittr %>%
get_junc_count_info_recount2 <- function(junction_coverage_file) {

  A <- readr::read_tsv(junction_coverage_file, col_names = FALSE, col_types = "ccc") %>%
    dplyr::filter(X1 %in% c(SF3B1_info$Junction_ID_Alt, SF3B1_info$Junction_ID_Ref))

  sample_ids <- c()
  junc_counts <- c()
  junc_ids <- c()
  for (i in 1:nrow(A)) {
    tsample_ids <- as.numeric(stringr::str_split(A$X2[i], pattern = ',', simplify = TRUE))
    tjunc_counts <- as.numeric(stringr::str_split(A$X3[i], pattern = ',', simplify = TRUE))

    sample_ids <- c(sample_ids, tsample_ids)
    junc_counts <- c(junc_counts, tjunc_counts)
    junc_ids <- c(junc_ids, rep(as.numeric(A$X1[i]), length(tsample_ids)))
  }

  junc_counts_info <- data.frame(Junction_ID = junc_ids, Sample_ID = sample_ids, Junction_Count = junc_counts, stringsAsFactors = FALSE)
  return(junc_counts_info)

}

#' Create the data frame of junctions from recount2 junction coverage files#'
#'
#' @param SJ_file Junction file obtained through STAR alignment as ".SJ.out.tab".
#' @param ref Reference genome (hg19 or hg38).
#' @return data frame for Junction_ID, Sample_ID and Junction_Count
#'
#' @importFrom magrittr %>%
get_junc_count_info_SJ <- function(SJ_file, ref = "hg19") {

  SJ <- readr::read_tsv(SJ_file, col_names = FALSE, col_types = "ccciiiiii") %>%
    dplyr::mutate(SJ_Key = stringr::str_c(str_replace(X1, "chr", ""), X2, X3, sep = ","), Sample_ID = "1") %>%
    dplyr::select(Sample_ID, SJ_Key, Junction_Count = X7)

  if (ref == "hg19") {
    junc_counts_info <-
      rbind(SF3B1_info %>% dplyr::inner_join(SJ, by = c("Junction_Key_Alt_GRCh37" = "SJ_Key")) %>% dplyr::select(Sample_ID, Junction_ID = Junction_ID_Alt, Junction_Count),
            SF3B1_info %>% dplyr::inner_join(SJ, by = c("Junction_Key_Ref_GRCh37" = "SJ_Key")) %>% dplyr::select(Sample_ID, Junction_ID = Junction_ID_Ref, Junction_Count))
  } else if (ref == "hg38") {
    junc_counts_info <-
      rbind(SF3B1_info %>% dplyr::inner_join(SJ, by = c("Junction_Key_Alt_GRCh38" = "SJ_Key")) %>% dplyr::select(Sample_ID, Junction_ID = Junction_ID_Alt, Junction_Count),
            SF3B1_info %>% dplyr::inner_join(SJ, by = c("Junction_Key_Ref_GRCh38" = "SJ_Key")) %>% dplyr::select(Sample_ID, Junction_ID = Junction_ID_Ref, Junction_Count))
  } else {
    stop("ref should be hg19 or hg38")
  }

  return(junc_counts_info)

}


#' Obtain SF3B1ness score for recount2 junction coverate file
#'
#' @param junction_coverage_file Junction coverate file obtained from recount2.
#' @return data frame for StudyID, Run ID and SF3B1ness score
#'
#' @importFrom magrittr %>%
#' @export
SF3B1ness_recount2 <- function(junction_coverage_file) {

  junc_counts_info <- get_junc_count_info_recount2(junction_coverage_file)
  scores <- get_score(junc_counts_info)

  D <- scores %>% dplyr::left_join(Sample_ID_info, by = c("Sample_ID" = "X1")) %>% dplyr::select(Study = X2, Run = X3, Score = Score)
  return(D)
}


#' Obtain SF3B1ness score for STAR SJ.out.tab files
#'
#' @param SJ_file Junction file obtained through STAR alignment as SJ.out.tab file
#' @return SF3B1ness score
#'
#' @importFrom magrittr %>%
#' @export
SF3B1ness_SJ <- function(SJ_file, ref = "hg19") {

  junc_counts_info <- get_junc_count_info_SJ(SJ_file, ref = "hg19")

  if (nrow(junc_counts_info) <= 5) {
      warning("Too few splicing junctions. Check the quality of the input and the reference genome ID")
    scores <- data.frame(Sample_ID = "1", Score = NA)
  } else {
    scores <- get_score(junc_counts_info)
  }

  D <- data.frame(Sample_Name = str_replace(basename(SJ_file), ".SJ.out.tab", ""), Score = scores$Score, stringsAsFactors = FALSE)
  return(D)
}



