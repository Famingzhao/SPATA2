

#' @title Set cnv-results
#'
#' @inherit check_sample params
#' @inherit set_dummy details
#'
#' @param cnv_list The list containing the results from \code{runCnvAnalysis()}.
#'
#' @return An updated spata-object.
#' @export
#'

setCnvResults <- function(object, cnv_list, of_sample = NA){

  check_object(object)

  of_sample <- check_sample(object = object, of_sample = of_sample, of.length = 1)

  object@cnv[[of_sample]] <- cnv_list

  base::return(object)

}


#' @title Obtain copy-number-variations results
#'
#' @description Provides convenient access to the results of \code{runCnvAnalysis()}.
#'
#' @inherit check_sample params
#'
#' @return A named list.
#' @export
#'

getCnvResults <- function(object, of_sample = NA){

  check_object(object)

  of_sample <- check_sample(object = object, of_sample = of_sample, of.length = 1)

  res_list <- object@cnv[[of_sample]]

  check_availability(test = !base::identical(x = res_list, y = list()),
                     ref_x = "CNV results",
                     ref_fns = "function 'runCNVAnalysis()")

  base::return(res_list)

}



#' @title Obtain features names under which cnv-analysis results are stored.
#'
#' @description Returns a character vector of feature names referring to the
#' barcode-spots chromosomal gains and losses as computed by \code{runCnvAnalysis()}.
#'
#' @inherit check_sample params
#'
#' @return Character vector.
#' @export
#'

getCnvFeatureNames <- function(object, of_sample = NA){

  check_object(object)

  of_sample <- check_sample(object = object, of_sample = of_sample, of.length = 1)

  cnv_results <- getCnvResults(object = object, of_sample = of_sample)

  prefix <- cnv_results$prefix

  chromosomes <-
    cnv_results$regions_df %>%
    base::rownames() %>%
    stringr::str_remove_all(pattern = "p$|q$")

  cnv_feature_names <- stringr::str_c(prefix, chromosomes)

  base::return(cnv_feature_names)

}



#' run pca on the cnv-matrix
#'
#' @param object spata-object
#' @param n_pcs number of pcs to be calculated
#' @param of_sample sample of interest
#' @param ... arguments given to the pca algorithm

hlpr_run_cnva_pca <- function(object, n_pcs = 30, of_sample = NA, ...){

  check_object(object)

  of_sample <- check_sample(object, of_sample = of_sample, desired_length = 1)

  cnv_res <- getCnvResults(object, of_sample = of_sample)

  cnv_mtr <- cnv_res$cnv_mtr

  pca_res <- irlba::prcomp_irlba(x = base::t(cnv_mtr), n = n_pcs, ...)

  pca_df <-
    base::as.data.frame(x = pca_res[["x"]]) %>%
    dplyr::mutate(barcodes = base::colnames(cnv_mtr), sample = {{of_sample}}) %>%
    dplyr::select(barcodes, sample, dplyr::everything()) %>%
    tibble::as_tibble()

  cnv_res$dim_red$pca <- pca_df

  object <- setCnvResults(object, cnv_list = cnv_res, of_sample = of_sample)

  base::return(object)


}

#' @title Identify large-scale chromosomal copy number variations
#'
#' @description This functions integrates large-scale copy number variations analysis
#' using the inferncnv-package.
#'
#' @inherit argument_dummy params
#' @inherit check_sample params
#'
#' @param ref_mtr The expression matrix that is supposed to be used as the reference.
#' Row names must refer to the gene names and column names must refer to
#' the barcodes. Alternatively a directory leading to a .RDS-file can be specfied.
#'
#' @param ref_annotaion A data.frame in which the row names refer to the barcodes
#' and a column named \emph{sample} refers to the reference group names.
#' Alternatively a directory leading to a .RDS-file can be specfied.
#'
#' @param directory_cnv_folder Character value. A directory that leads to the folder
#' in which to store temporary files, the infercnv-object as well as the output
#' heatmap.
#' @param cnv_prefix Character value. Denotes the string with which the
#' the feature variables in which the information about the chromosomal gains and
#' losses are stored are prefixed.
#' @param save_infercnv_object Logical value. If set to TRUE the infercnv-object
#' is stored in the folder denoted in argument \code{directory_cnv_folder} under
#' \emph{'infercnv-object.RDS}.
#' @param CreateInfercnvObject A list of arguments with which the function is supposed
#' to be called. Make sure that your input does not conflict with downstream function
#' calls. Input for argument \code{infercnv_obj} must not be specified.
#' @param require_above_min_mean_expr_cutoff A list of arguments with which the function is supposed
#' to be called. Make sure that your input does not conflict with downstream function
#' calls. Input for argument \code{infercnv_obj} must not be specified.
#' @param require_above_min_cells_ref A list of arguments with which the function is supposed
#' to be called. Make sure that your input does not conflict with downstream function
#' calls. Input for argument \code{infercnv_obj} must not be specified.
#' @param normalize_counts_by_seq_depth A list of arguments with which the function is supposed
#' to be called. Make sure that your input does not conflict with downstream function
#' calls. Input for argument \code{infercnv_obj} must not be specified.
#' @param anscombe_transform A list of arguments with which the function is supposed
#' to be called. Make sure that your input does not conflict with downstream function
#' calls. Input for argument \code{infercnv_obj} must not be specified.
#' @param log2xplus1 A list of arguments with which the function is supposed
#' to be called. Make sure that your input does not conflict with downstream function
#' calls. Input for argument \code{infercnv_obj} must not be specified.
#' @param apply_max_threshold_bounds A list of arguments with which the function is supposed
#' to be called. Make sure that your input does not conflict with downstream function
#' calls. Input for argument \code{infercnv_obj} must not be specified.
#' @param smooth_by_chromosome A list of arguments with which the function is supposed
#' to be called. Make sure that your input does not conflict with downstream function
#' calls. Input for argument \code{infercnv_obj} must not be specified.
#' @param center_cell_expr_across_chromosome A list of arguments with which the function is supposed
#' to be called. Make sure that your input does not conflict with downstream function
#' calls. Input for argument \code{infercnv_obj} must not be specified.
#' @param subtract_ref_expr_from_obs A list of arguments with which the function is supposed
#' to be called. Make sure that your input does not conflict with downstream function
#' calls. Input for argument \code{infercnv_obj} must not be specified.
#' @param invert_log2 A list of arguments with which the function is supposed
#' to be called. Make sure that your input does not conflict with downstream function
#' calls. Input for argument \code{infercnv_obj} must not be specified.
#' @param clear_noise_via_ref_mean_sd A list of arguments with which the function is supposed
#' to be called. Make sure that your input does not conflict with downstream function
#' calls. Input for argument \code{infercnv_obj} must not be specified.
#' @param remove_outliers_norm A list of arguments with which the function is supposed
#' to be called. Make sure that your input does not conflict with downstream function
#' calls. Input for argument \code{infercnv_obj} must not be specified.
#' @param define_signif_tumor_subclusters A list of arguments with which the function is supposed
#' to be called. Make sure that your input does not conflict with downstream function
#' calls. Input for argument \code{infercnv_obj} must not be specified.
#' @param plot_cnv A list of arguments with which the function is supposed
#' to be called. Make sure that your input does not conflict with downstream function
#' calls. Input for argument \code{infercnv_obj} and  must not be specified. Input for argument
#' \code{out_dir} is taken from argument \code{directory_cnv_folder}.
#'
#' @details \code{runCnvAnalysis} is a wrapper around all functions the infercnv-pipeline
#' is composed of. Argument \code{directory_cnv_folder} should lead to an empty folder as
#' temporary files as well as the output heatmap and the infercnv-object are stored
#' there which can lead to overwriting due to naming issues.
#'
#' Results (including a PCA) are stored in the slot @@cnv of the spata-object
#' which can be obtained via \code{getCnvResults()}. Additionally, the variables
#' that store the copy-number-variations for each barcode-spot are added to
#' the spata-object's feature data. The corresponding feature variables are named according
#' to the chromosome's number and the prefix denoted with the argument \code{cnv_prefix.}
#'
#' @return An updated spata-object containg the results in the respective slot.
#' @export
#'

runCnvAnalysis <- function(object,
                           ref_mtr = "data-development/cnv-ref-mtr.RDS",
                           ref_annotation = "data-development/cnv-ref-annotation.RDS",
                           directory_cnv_folder = "data-development/cnv-results", # output folder
                           directory_regions_df = NULL, # chromosome positions
                           n_pcs = 30,
                           cnv_prefix = "Chr",
                           save_infercnv_object = TRUE,
                           verbose = NULL,
                           of_sample = NA,
                           CreateInfercnvObject = list(ref_group_names = "ref"),
                           require_above_min_mean_expr_cutoff = list(min_mean_expr_cutoff = 0.1),
                           require_above_min_cells_ref = list(min_cells_per_gene = 3),
                           normalize_counts_by_seq_depth = list(),
                           anscombe_transform = list(),
                           log2xplus1 = list(),
                           apply_max_threshold_bounds = list(),
                           smooth_by_chromosome = list(window_length = 101, smooth_ends = TRUE),
                           center_cell_expr_across_chromosome = list(method = "median"),
                           subtract_ref_expr_from_obs = list(inv_log = TRUE),
                           invert_log2 = list(),
                           clear_noise_via_ref_mean_sd = list(sd_amplifier = 1.5),
                           remove_outliers_norm = list(),
                           define_signif_tumor_subclusters = list(p_val = 0.05, hclust_method = "ward.D2", cluster_by_groups = TRUE, partition_method = "qnorm"),
                           plot_cnv = list(k_obs_groups = 5, cluster_by_groups = TRUE, output_filename = "infercnv.outliers_removed", color_safe_pal = FALSE,
                                           x.range = "auto", x.center = 1, output_format = "pdf", title = "Outliers Removed")
                           ){

  # 1. Control --------------------------------------------------------------

  hlpr_assign_arguments(object)
  of_sample <- check_sample(object = object, of_sample = of_sample, of.lenght = 1)

  confuns::are_values(c("save_infercnv_object"), mode = "logical")

  confuns::check_directories(directories = directory_cnv_folder, type = "folders")

  if(base::is.character(directory_regions_df)){

    confuns::check_directories(directories = directory_regions_df, type = "files")

  }

  # -----


  # 2. Data extraction ------------------------------------------------------

  # preparing object derived data
  count_mtr <- getCountMatrix(object = object, of_sample = of_sample)

  obj_anno <-
    getFeatureDf(object = object, of_sample = of_sample) %>%
    dplyr::select(barcodes, sample) %>%
    tibble::column_to_rownames(var = "barcodes")


  # reading and preparing reference data
  confuns::give_feedback(msg = "Checking input for reference data.", verbose = verbose)

  if(base::is.character(ref_mtr)){

    confuns::give_feedback(
      msg = glue::glue("Reading in reference matrix from directory '{ref_mtr}'."),
      verbose = verbose
      )

    ref_mtr <- base::readRDS(file = ref_mtr)

    confuns::give_feedback(msg = "Done.", verbose = verbose)

  } else if(base::is.matrix(ref_mtr)){

    ref_mtr <- ref_mtr

  } else {

    base::stop("Input for argument 'ref_mtr' must either be a directory leading to an .RDS-file or a matrix.")

  }


  if(base::is.character(ref_annotation)){

    confuns::give_feedback(
      msg = glue::glue("Reading in reference annotation from directory '{ref_annotation}'."),
      verbose = verbose
    )

    ref_anno <- base::readRDS(file = ref_annotation)

    confuns::give_feedback(msg = "Done.", verbose = verbose)

  } else if(base::is.data.frame(ref_anno)){

    ref_anno <- ref_anno

  } else {

    base::stop("Input for argument 'ref_annotation' must either be a directory leading to an .RDS-file or a data.frame.")

  }


  # combine data sets
  confuns::give_feedback(msg = "Combining input and reference data.", verbose = verbose)

  genes_inter <-
    base::intersect(x = base::rownames(count_mtr), y = base::rownames(ref_mtr))

  expr_inter <- base::cbind(count_mtr[genes_inter, ], ref_mtr[genes_inter, ])

  anno_inter <- base::rbind(obj_anno, ref_anno)

  # read and process gene positions
  confuns::give_feedback(msg = "Getting gene positions.", verbose = verbose)

  if(base::is.character(directory_regions_df)){

    regions_df <- base::readRDS(file = directory_regions_df)

  } else {

    regions_df <- cnv_regions_df

  }

  gene_pos_df <-
    CONICSmat::getGenePositions(gene_names = base::rownames(expr_inter))

  # -----


  # 3. Analysis pipeline ----------------------------------------------------

  gene_order_df <-
    dplyr::select(gene_pos_df, chromosome_name, start_position, end_position, hgnc_symbol) %>%
    magrittr::set_rownames(value = gene_pos_df$hgnc_symbol)

  confuns::give_feedback(msg = "Starting analysis pipeline.", verbose = verbose)

  infercnv_obj <-
    confuns::call_flexibly(
      fn = "CreateInfercnvObject",
      fn.ns = "infercnv",
      fn.ns.sep = ":::",
      default = list("raw_counts_matrix" = expr_inter,
                     "annotations_file" = anno_inter,
                     "gene_order_file" = gene_order_df
                     )
    )


  confuns::give_feedback(msg = glue::glue("Removing genes from matrix with mean expression below threshold."), verbose = verbose)

  infercnv_obj <-
    confuns::call_flexibly(
      fn = "require_above_min_mean_expr_cutoff",
      fn.ns = "infercnv",
      fn.ns.sep = ":::",
      default = list("infercnv_obj" = infercnv_obj),
      v.fail = infercnv_obj
      )

  confuns::give_feedback(msg = "Removing low quality barcode spots.", verbose = verbose)

  infercnv_obj <-
    confuns::call_flexibly(
      fn = "require_above_min_cells_ref",
      fn.ns = "infercnv",
      fn.ns.sep = ":::",
      default = list("infercnv_obj" = infercnv_obj),
      v.fail = infercnv_obj
    )


  confuns::give_feedback(msg = "Normalizing counts by sequencing depth.", verbose = verbose)

  infercnv_obj <-
    confuns::call_flexibly(
      fn = "normalize_counts_by_seq_depth",
      fn.ns = "infercnv",
      fn.ns.sep = ":::",
      default = list("infercnv_obj" = infercnv_obj),
      v.fail = infercnv_obj
    )


  confuns::give_feedback(msg = "Conducting anscombe and logarithmic transformation.", verbose = verbose)

  infercnv_obj <-
    confuns::call_flexibly(
      fn = "anscombe_transform",
      fn.ns = "infercnv",
      fn.ns.sep = ":::",
      default = list("infercnv_obj" = infercnv_obj),
      v.fail = infercnv_obj
    )

  infercnv_obj <-
    confuns::call_flexibly(
      fn = "log2xplus1",
      fn.ns = "infercnv",
      fn.ns.sep = ":::",
      default = list("infercnv_obj" = infercnv_obj),
      v.fail = infercnv_obj
    )

  confuns::give_feedback(msg = "Applying maximal threshold bounds.", verbose = verbose)

  threshold <-
    base::mean(base::abs(infercnv:::get_average_bounds(infercnv_obj))) %>%
    base::round(digits = 2)

  infercnv_obj <-
    confuns::call_flexibly(
      fn = "apply_max_threshold_bounds",
      fn.ns = "infercnv",
      fn.ns.sep = ":::",
      default = list("infercnv_obj" = infercnv_obj, "threshold" = threshold),
      v.fail = infercnv_obj
    )


  confuns::give_feedback(msg = "Smoothing by chromosome.", verbose = verbose)

  infercnv_obj <-
    confuns::call_flexibly(
      fn = "smooth_by_chromosome",
      fn.ns = "infercnv",
      fn.ns.sep = ":::",
      default = list("infercnv_obj" = infercnv_obj),
      v.fail = infercnv_obj
    )


  confuns::give_feedback(msg = "Centering cell expression across chromosome.", verbose = verbose)

  infercnv_obj <-
    confuns::call_flexibly(
      fn = "center_cell_expr_across_chromosome",
      fn.ns = "infercnv",
      fn.ns.sep = ":::",
      default = list("infercnv_obj" = infercnv_obj),
      v.fail = infercnv_obj
    )

  confuns::give_feedback(msg = "Subtracting reference expression from observed expression.", verbose = verbose)

  infercnv_obj <-
    confuns::call_flexibly(
      fn = "subtract_ref_expr_from_obs",
      fn.ns = "infercnv",
      fn.ns.sep = ":::",
      default = list("infercnv_obj" = infercnv_obj),
      v.fail = infercnv_obj
    )

  confuns::give_feedback(msg = "Clearing noise via reference mean standard deviation.", verbose = verbose)

  infercnv_obj <-
    confuns::call_flexibly(
      fn = "invert_log2",
      fn.ns = "infercnv",
      fn.ns.sep = ":::",
      default = list("infercnv_obj" = infercnv_obj),
      v.fail = infercnv_obj

    )

  infercnv_obj <-
    confuns::call_flexibly(
      fn = "clear_noise_via_ref_mean_sd",
      fn.ns = "infercnv",
      fn.ns.sep = ":::",
      default = list("infercnv_obj" = infercnv_obj),
      v.fail = infercnv_obj
    )


  confuns::give_feedback(msg = "Removing outliers.", verbose = verbose)

  infercnv_obj <-
    confuns::call_flexibly(
      fn = "remove_outliers_norm",
      fn.ns = "infercnv",
      fn.ns.sep = ":::",
      default = list("infercnv_obj" = infercnv_obj),
      v.fail = infercnv_obj
    )


  confuns::give_feedback(msg = "Defining significant tumor subclusters.", verbose = verbose)

  infercnv_obj <-
    confuns::call_flexibly(
      fn = "define_signif_tumor_subclusters",
      fn.ns = "infercnv",
      fn.ns.sep = ":::",
      default = list("infercnv_obj" = infercnv_obj),
      v.fail = infercnv_obj
    )


  confuns::give_feedback(msg = "Copy number variation pipeline completed.", verbose = verbose)

  if(base::isTRUE(save_infercnv_object)){

    confuns::give_feedback(msg = glue::glue("Saving infercnv-object under '{ref_dir}'.",
                                            ref_dir = stringr::str_c(directory_cnv_folder, "infercnv-obj.RDS", sep = "/")),
                           verbose = verbose)

    base::saveRDS(infercnv_obj, file = "infercnv-obj.RDS")

  }

  confuns::give_feedback(msg = "Plotting results.", verbose = verbose)

  infercnv_obj <-
    confuns::call_flexibly(
      fn = "plot_cnv",
      fn.ns = "infercnv",
      fn.ns.sep = ":::",
      default = list("infercnv_obj" = infercnv_obj, "out_dir" = directory_cnv_folder),
      v.fail = infercnv_obj
    )

  infercnv_obj <- infercnv::plot_cnv(infercnv_obj = infercnv_obj)

  # ----



  # 4. Storing results ------------------------------------------------------


  results <- utils::read.table(plot_cnv$output_filename)

  barcodes <- base::colnames(results)

  ordered_cnv_df <-
    base::as.data.frame(results) %>%
    tibble::rownames_to_column("hgnc_symbol") %>%
    dplyr::left_join(., gene_pos_df, by="hgnc_symbol") %>%
    dplyr::group_by(chromosome_name) %>%
    dplyr::select(chromosome_name, dplyr::any_of(barcodes)) %>%
    dplyr::summarise_all(base::mean) %>%
    dplyr::mutate(Chr = stringr::str_c(cnv_prefix, chromosome_name)) %>%
    dplyr::select(Chr, dplyr::everything()) %>%
    dplyr::ungroup() %>%
    dplyr::select(-chromosome_name)

  cnames <- c("barcodes", ordered_cnv_df$Chr)

  ordered_cnv_df2 <-
    dplyr::select(ordered_cnv_df, -Chr) %>%
    base::t() %>%
    base::as.data.frame() %>%
    tibble::rownames_to_column(var = "barcodes") %>%
    magrittr::set_colnames(value = cnames) %>%
    dplyr::mutate(barcodes = stringr::str_replace_all(string = barcodes, pattern = "\\.", replacement = "-")) %>%
    dplyr::mutate(dplyr::across(dplyr::starts_with(match = cnv_prefix), .fns = base::as.numeric)) %>%
    tibble::as_tibble()

  # add results to spata object
  confuns::give_feedback(msg = "Adding results to the spata-object's feature data.", verbose = verbose)

  # feature variables
  object <- addFeatures(object = object,
                        feature_df = ordered_cnv_df2,
                        overwrite = TRUE)

  # cnv matrix
  base::colnames(results) <- stringr::str_replace_all(string = base::colnames(results), pattern = "\\.", replacement = "-")
  cnv_mtr <- base::as.matrix(results)

  # cnv list
  cnv_list <- list(prefix = cnv_prefix,
                   clustering = clustering_list,
                   cnv_df = ordered_cnv_df2,
                   cnv_mtr = cnv_mtr,
                   gene_pos_df = gene_pos_df,
                   regions_df = regions_df
                   )

  object <-
    setCnvResults(object = object, cnv_list = cnv_list, of_sample = of_sample)

  object <-
    hlpr_run_cnva_pca(object, n_pcs = n_pcs, of_sample = of_sample)

  # cnv clustering - hierarchical
  cnv_res <- getCnvResults(object, of_sample = of_sample)

  cnv_pca_df <- dplyr::select(cnv_res$dim_red$pca, -sample)

  cnv_hclust <-
    confuns::initiate_hclust_object(
      hclust_data = tibble::column_to_rownames(cnv_pca_df, var = "barcodes"),
      key_name = "barcodes"
      )

  clustering_list <-
    list(
      hierarchical = cnv_hclust
    )

  cnv_res$clustering <- clustering_list

  object <- setCnvResults(object, cnv_list = cnv_res, of_sample = of_sample)

  # -----

  confuns::give_feedback(msg = "Done.", verbose = verbose)

  base::return(object)

}




#' @title Visualize copy-number-variations results
#'
#' @description Displays a smoothed lineplot indicating
#' chromosomal gains and losses. Requires the results of \code{runCnvAnalysis()}.
#'
#' @inherit across_dummy params
#' @inherit argument_dummy params
#' @inherit check_smooth params
#' @inherit ggplot_family return
#'
#' @export

plotCnvResults <- function(object,
                           across = NULL,
                           across_subset = NULL,
                           relevel = NULL,
                           clr = "blue",
                           smooth_span = 0.08,
                           nrow = NULL,
                           ncol = NULL,
                           of_sample = NA,
                           verbose = NULL
                           ){

  # 1. Control --------------------------------------------------------------

  hlpr_assign_arguments(object)

  of_sample <- check_sample(object, of_sample = of_sample, of.length = 1)

  # -----


  # 2. Data preparation -----------------------------------------------------

  # cnv results
  cnv_results <- getCnvResults(object, of_sample = of_sample)

  cnv_data <- cnv_results$cnv_mtr

  if(base::is.null(across)){

    confuns::give_feedback(msg = "Plotting cnv-results for whole sample.", verbose = verbose)

    plot_df <-
      base::data.frame(
        mean = base::apply(cnv_data, MARGIN = 1, FUN = stats::median),
        sd = base::apply(cnv_data, MARGIN = 1, FUN = stats::sd)
      ) %>%
      tibble::rownames_to_column(var = "hgnc_symbol") %>%
      dplyr::left_join(x = ., y = cnv_results$gene_pos_df, by = "hgnc_symbol") %>%
      dplyr::mutate(
        chromosome_name = base::factor(chromosome_name, levels = base::as.character(0:23))
      ) %>%
      tibble::as_tibble()

    line_df <-
      dplyr::count(x = plot_df, chromosome_name) %>%
      dplyr::mutate(
        line_pos = base::cumsum(x = n),
        line_lag = dplyr::lag(x = line_pos, default = 0) ,
        label_breaks = (line_lag + line_pos) / 2
      ) %>%
      tidyr::drop_na()

    final_plot <-
      ggplot2::ggplot(data = plot_df, mapping = ggplot2::aes(x = 1:base::nrow(plot_df), y = mean)) +
      ggplot2::geom_smooth(method = "loess", formula = y ~ x, span = smooth_span, se = FALSE, color = clr) +
      ggplot2::geom_ribbon(mapping = ggplot2::aes(ymin = mean-sd, ymax = mean + sd),
                           alpha = 0.2) +
      ggplot2::geom_vline(data = line_df, mapping = ggplot2::aes(xintercept = line_pos), linetype = "dashed", alpha = 0.5) +
      ggplot2::theme_classic() +
      ggplot2::scale_x_continuous(breaks = line_df$label_breaks, labels = line_df$chromosome_name) +
      ggplot2::labs(x = "Chromosomes", y = "CNV-Results")

  } else if(base::is.character(across)){

    confuns::give_feedback(
      msg = glue::glue("Plotting cnv-results across '{across}'. This might take a few moments."),
      verbose = verbose
    )

    gene_names <- base::rownames(cnv_data)

    prel_df <-
      base::as.data.frame(cnv_data) %>%
      base::t() %>%
      base::as.data.frame() %>%
      tibble::rownames_to_column(var = "barcodes") %>%
      joinWith(object = object, spata_df = ., features = across) %>%
      confuns::check_across_subset(df = ., across = across, across.subset = across_subset, relevel = relevel) %>%
      tidyr::pivot_longer(
        cols = dplyr::all_of(gene_names),
        names_to = "hgnc_symbol",
        values_to = "cnv_values"
      ) %>%
      dplyr::left_join(x = ., y = cnv_results$gene_pos_df, by = "hgnc_symbol") %>%
      dplyr::mutate(
        chromosome_name = base::factor(chromosome_name, levels = base::as.character(0:23))
      ) %>%
      tibble::as_tibble()

    confuns::give_feedback(msg = "Summarising results for all groups.", verbose = verbose)

    summarized_df <-
      dplyr::group_by(prel_df, !!rlang::sym(x = across), chromosome_name, hgnc_symbol) %>%
      dplyr::summarise(
        cnv_mean = stats::median(x = cnv_values, na.rm = TRUE),
        cnv_sd = stats::sd(x = cnv_values, na.rm = TRUE),
        .groups = "drop"
      ) %>%
      dplyr::ungroup() %>%
      dplyr::group_by(!!rlang::sym(x = across)) %>%
      dplyr::mutate(x_axis = dplyr::row_number(), across = !!rlang::sym(across))

    line_df <-
      dplyr::count(x = summarized_df, chromosome_name) %>%
      dplyr::ungroup() %>%
      dplyr::group_by(!!rlang::sym(across)) %>%
      dplyr::mutate(
        line_pos = base::cumsum(x = n),
        line_lag = dplyr::lag(x = line_pos, default = 0) ,
        label_breaks = (line_lag + line_pos) / 2
      )  %>%
      tidyr::drop_na()

    final_plot <-
      ggplot2::ggplot(data = summarized_df, mapping = ggplot2::aes(x = x_axis, y = cnv_mean)) +
      ggplot2::geom_smooth(method = "loess", formula = y ~ x, span = smooth_span, se = FALSE, color = clr) +
      ggplot2::geom_ribbon(
        mapping = ggplot2::aes(ymin = cnv_mean - cnv_sd, ymax = cnv_mean + cnv_sd),
        alpha = 0.2
      ) +
      ggplot2::geom_vline(
        data = line_df,
        mapping = ggplot2::aes(xintercept = line_pos), linetype = "dashed", alpha = 0.5
      ) +
      ggplot2::facet_wrap(facets = ~ across, nrow = nrow, ncol = ncol) +
      ggplot2::theme_classic() +
      ggplot2::theme(strip.background = ggplot2::element_blank()) +
      ggplot2::scale_x_continuous(breaks = line_df$label_breaks, labels = line_df$chromosome_name) +
      ggplot2::labs(x = "Chromosomes", y = "CNV-Results")

  }

  confuns::give_feedback(msg = "Done.", verbose = verbose)

  base::return(final_plot)

}










