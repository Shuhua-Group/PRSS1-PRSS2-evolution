#!/usr/bin/env Rscript
# Newly prepared reproduction script (not recovered historical code).
# Orientation: TE_i = multiplier_i * log(reported OR_i).  A +1 multiplier keeps
# the Rosendahl workbook/ED8F direction; -1 inverts an estimate only to place it
# in that same display direction.  The workbook's A/G arrows are annotations,
# not certified effect alleles, and are not treated as universal risk alleles.
# Scope: ACP/CP, ICP/ACP and AAP outcomes are mixed, and rs13228878 is a distinct
# proxy SNP; those choices require scientific review beyond reproducing the figure.

options(stringsAsFactors = FALSE, digits = 15)
suppressPackageStartupMessages(library(grid))
Z95 <- 1.96  # exact denominator used by the worksheet: (log(upper)-log(lower))/(2*1.96)

# readxl needs a multibyte locale to open paths containing the supplied CJK path.
if (.Platform$OS.type == "windows" && !isTRUE(l10n_info()$MBCS)) {
  for (loc in c("English_United States.utf8", "Chinese_China.936")) {
    got <- suppressWarnings(tryCatch(Sys.setlocale("LC_CTYPE", loc),
                                     error = function(e) ""))
    if (nzchar(got)) break
  }
}

usage <- function() {
  cat("Usage: Rscript pancreatitis_meta_analysis.R [options]\n\n",
      "Options:\n",
      "  --input PATH       Workbook (default: <package>/data/pancreatitis_associations.xlsx)\n",
      "  --directions PATH  Direction map (default: <package>/data/effect_directions.tsv)\n",
      "  --output DIR       Output directory (default: <package>/results)\n",
      "  -h, --help         Show this help\n", sep = "")
}

parse_cli <- function(args) {
  vals <- list(input = NULL, directions = NULL, output = NULL, help = FALSE)
  i <- 1L
  while (i <= length(args)) {
    a <- args[[i]]
    if (a %in% c("-h", "--help")) {
      vals$help <- TRUE
      return(vals)
    }
    if (!startsWith(a, "--")) stop("Unknown argument: ", a, call. = FALSE)
    body <- sub("^--", "", a)
    if (grepl("=", body, fixed = TRUE)) {
      key <- sub("=.*$", "", body)
      val <- sub("^[^=]*=", "", body)
      if (!nzchar(val)) stop("Missing value for --", key, call. = FALSE)
      i <- i + 1L
    } else {
      key <- body
      if (i == length(args)) stop("Missing value for --", key, call. = FALSE)
      val <- args[[i + 1L]]
      i <- i + 2L
    }
    if (!key %in% c("input", "directions", "output")) {
      stop("Unknown option: --", key, call. = FALSE)
    }
    vals[[key]] <- val
  }
  vals
}

is_absolute <- function(path) {
  grepl("^([A-Za-z]:[/\\\\]|/|\\\\\\\\)", path)
}

as_path <- function(path) {
  if (is_absolute(path)) path else file.path(getwd(), path)
}

is_within <- function(path, parent) {
  path <- sub("/+$", "", path)
  parent <- sub("/+$", "", parent)
  if (.Platform$OS.type == "windows") {
    path <- tolower(path)
    parent <- tolower(parent)
  }
  identical(path, parent) || startsWith(path, paste0(parent, "/"))
}

write_tsv <- function(x, path) {
  utils::write.table(x, file = path, sep = "\t", quote = FALSE,
                     row.names = FALSE, col.names = TRUE, na = "NA",
                     eol = "\n", fileEncoding = "UTF-8")
}

# Univariate REML profile.  The objective includes the log(v+t) term, the
# log(sum(1/(v+t))) term and the weighted residual sum of squares.  t=0 is an
# explicit boundary candidate.  The bracket is expanded multiplicatively, then
# optimized twice at high precision.
reml_tau2 <- function(te, v) {
  profile <- function(t2) {
    vv <- v + t2
    ww <- 1 / vv
    mu <- sum(ww * te) / sum(ww)
    0.5 * (sum(log(vv)) + log(sum(ww)) + sum(ww * (te - mu)^2))
  }
  f0 <- profile(0)
  hi <- max(1e-8, max(v), stats::var(te))
  if (!is.finite(hi) || hi <= 0) hi <- 1e-6
  for (i in seq_len(80L)) {
    if (profile(hi) >= profile(hi / 2)) break
    hi <- hi * 2
    if (!is.finite(hi) || hi > 1e8) stop("Could not bracket the REML tau2 optimum.")
  }
  opt <- stats::optimize(profile, interval = c(0, hi), tol = 1e-12)
  if (opt$minimum > 0 && opt$minimum < hi) {
    span <- max(1e-10, min(opt$minimum, hi - opt$minimum) * 0.1)
    opt2 <- stats::optimize(profile,
                            interval = c(max(0, opt$minimum - span),
                                         min(hi, opt$minimum + span)),
                            tol = 1e-14)
    if (opt2$objective <= opt$objective) opt <- opt2
  }
  tol <- 1e-13 * max(1, abs(opt$objective))
  if (f0 <= opt$objective + tol) {
    list(tau2 = 0, objective = f0, boundary = TRUE)
  } else {
    list(tau2 = opt$minimum, objective = opt$objective, boundary = FALSE)
  }
}

draw_forest <- function(d, summary_row) {
  grid.newpage()
  sans <- gpar(fontfamily = "sans", col = "black")
  gtext <- function(label, x, y, just = "centre", size = 8.6,
                    face = "plain", col = "black") {
    grid.text(label, x = unit(x, "npc"), y = unit(y, "npc"), just = just,
              gp = gpar(fontfamily = "sans", fontsize = size,
                        fontface = face, col = col))
  }

  x_study <- 0.015
  x_pop <- 0.160
  x_te <- 0.305
  x_se <- 0.372
  panel <- c(0.415, 0.735)
  x_or <- 0.777
  x_ci <- 0.807
  x_w <- 0.985

  gtext("Study", x_study, 0.925, "left", 8.8, "bold")
  gtext("Population", x_pop, 0.925, "left", 8.8, "bold")
  gtext("TE", x_te, 0.925, "right", 8.8, "bold")
  gtext("seTE", x_se, 0.925, "right", 8.8, "bold")
  gtext("Odds Ratio", mean(panel), 0.925, "centre", 8.8, "bold")
  gtext("(log scale)", mean(panel), 0.884, "centre", 7.8, "plain", "gray30")
  gtext("OR", x_or, 0.925, "right", 8.8, "bold")
  gtext("95%-CI", x_ci, 0.925, "left", 8.8, "bold")
  gtext("Weight", x_w, 0.925, "right", 8.8, "bold")

  lo <- min(c(d$CI_lower, summary_row$CI_lower, 0.5))
  hi <- max(c(d$CI_upper, summary_row$CI_upper, 2))
  span <- log(hi) - log(lo)
  pad <- if (is.finite(span) && span > 0) 0.035 * span else 0.05
  xlim <- exp(c(log(lo) - pad, log(hi) + pad))
  mapx <- function(v) {
    panel[1] + (log(v) - log(xlim[1])) / (log(xlim[2]) - log(xlim[1])) *
      diff(panel)
  }

  ticks <- 2^seq(floor(log2(xlim[1])), ceiling(log2(xlim[2])))
  ticks <- ticks[ticks >= xlim[1] & ticks <= xlim[2]]
  if (!any(abs(ticks - 1) < 1e-10)) ticks <- sort(unique(c(ticks, 1)))
  tick_labels <- sprintf("%g", ticks)

  grid.lines(unit(panel, "npc"), unit(c(0.805, 0.805), "npc"),
             gp = gpar(lwd = 0.8, col = "black"))
  grid.segments(unit(mapx(ticks), "npc"), unit(rep(0.805, length(ticks)), "npc"),
                unit(mapx(ticks), "npc"), unit(rep(0.785, length(ticks)), "npc"),
                gp = gpar(lwd = 0.8, col = "black"))
  gtext(tick_labels, mapx(ticks), 0.842, "centre", 7.8, "plain", "gray20")

  grid.lines(unit(c(0.012, 0.988), "npc"), unit(c(0.780, 0.780), "npc"),
             gp = gpar(lwd = 1.0, col = "black"))
  grid.lines(unit(rep(mapx(1), 2), "npc"), unit(c(0.230, 0.780), "npc"),
             gp = gpar(lwd = 0.8, lty = "dashed", col = "gray35"))

  row_y <- if (nrow(d) == 1) 0.565 else seq(0.685, 0.445, length.out = nrow(d))
  max_weight <- max(d$weight_pct)
  for (i in seq_len(nrow(d))) {
    y <- row_y[i]
    gtext(d$study[i], x_study, y, "left", 8.8)
    gtext(d$population[i], x_pop, y, "left", 8.3)
    gtext(sprintf("%.2f", d$TE[i]), x_te, y, "right", 8.3)
    gtext(sprintf("%.4f", d$seTE[i]), x_se, y, "right", 8.3)
    xl <- mapx(d$CI_lower[i])
    xu <- mapx(d$CI_upper[i])
    grid.segments(unit(xl, "npc"), unit(y, "npc"),
                  unit(xu, "npc"), unit(y, "npc"),
                  gp = gpar(lwd = 1.05, col = "gray35"))
    grid.segments(unit(c(xl, xu), "npc"), unit(c(y - 0.009, y - 0.009), "npc"),
                  unit(c(xl, xu), "npc"), unit(c(y + 0.009, y + 0.009), "npc"),
                  gp = gpar(lwd = 0.9, col = "gray35"))
    side <- 0.145 * sqrt(d$weight_pct[i] / max_weight)
    grid.rect(unit(mapx(d$OR[i]), "npc"), unit(y, "npc"),
              width = unit(side, "inches"), height = unit(side, "inches"),
              gp = gpar(fill = "gray75", col = "gray75", lwd = 0.4))
    grid.points(unit(mapx(d$OR[i]), "npc"), unit(y, "npc"),
                pch = 3, size = unit(1.7, "mm"), gp = gpar(col = "black", lwd = 0.8))
    gtext(sprintf("%.2f", d$OR[i]), x_or, y, "right", 8.7)
    gtext(sprintf("[%.2f; %.2f]", d$CI_lower[i], d$CI_upper[i]),
          x_ci, y, "left", 8.3)
    gtext(sprintf("%.1f%%", d$weight_pct[i]), x_w, y, "right", 8.3)
  }

  summary_y <- 0.305
  grid.lines(unit(c(0.012, 0.988), "npc"), unit(c(0.382, 0.382), "npc"),
             gp = gpar(lwd = 0.7, col = "gray65"))
  gtext("Common effect model", x_study, summary_y, "left", 8.8, "bold")
  xl <- mapx(summary_row$CI_lower)
  xc <- mapx(summary_row$OR)
  xu <- mapx(summary_row$CI_upper)
  h <- 0.034
  grid.polygon(unit(c(xl, xc, xu, xc), "npc"),
               unit(c(summary_y, summary_y + h, summary_y, summary_y - h), "npc"),
               gp = gpar(fill = "gray80", col = "black", lwd = 0.7))
  gtext(sprintf("%.2f", summary_row$OR), x_or, summary_y, "right", 8.8, "bold")
  gtext(sprintf("[%.2f; %.2f]", summary_row$CI_lower, summary_row$CI_upper),
        x_ci, summary_y, "left", 8.3)
  gtext(sprintf("%.1f%%", 100), x_w, summary_y, "right", 8.3)

  grid.lines(unit(c(0.012, 0.988), "npc"), unit(c(0.225, 0.225), "npc"),
             gp = gpar(lwd = 0.9, col = "black"))
  heterogeneity <- bquote(paste("Heterogeneity: ", I^2, " = ",
                                .(sprintf("%.0f%%", summary_row$I2)), ", ",
                                tau^2, " = ", .(sprintf("%.4f", summary_row$tau2)),
                                ", ", italic(p), " = ", .(sprintf("%.2f", summary_row$pQ))))
  gtext(heterogeneity, 0.012, 0.145, "left", 8.3)
}

cli <- parse_cli(commandArgs(trailingOnly = TRUE))
if (isTRUE(cli$help)) {
  usage()
  quit(save = "no", status = 0)
}

full_args <- commandArgs(trailingOnly = FALSE)
file_arg <- grep("^--file=", full_args, value = TRUE)
if (!length(file_arg)) stop("Cannot locate this script; run it with Rscript.")
script_arg <- sub("^--file=", "", file_arg[[1]])
script_path <- normalizePath(as_path(script_arg), winslash = "/", mustWork = TRUE)
script_dir <- dirname(script_path)
root <- if (identical(basename(script_dir), "code")) dirname(script_dir) else script_dir

input_path <- if (is.null(cli$input)) file.path(root, "data", "pancreatitis_associations.xlsx") else as_path(cli$input)
directions_path <- if (is.null(cli$directions)) file.path(root, "data", "effect_directions.tsv") else as_path(cli$directions)
output_dir <- if (is.null(cli$output)) file.path(root, "results") else as_path(cli$output)

input_path <- normalizePath(input_path, winslash = "/", mustWork = TRUE)
directions_path <- normalizePath(directions_path, winslash = "/", mustWork = TRUE)
output_dir <- suppressWarnings(normalizePath(output_dir, winslash = "/", mustWork = FALSE))
if (file.exists(output_dir) && !dir.exists(output_dir)) {
  stop("Output path exists and is not a directory: ", output_dir)
}
for (protected in c(file.path(root, "data"), file.path(root, "code"))) {
  protected <- suppressWarnings(normalizePath(protected, winslash = "/", mustWork = FALSE))
  if (is_within(output_dir, protected)) {
    stop("Refusing to write output inside protected directory: ", protected)
  }
}
if (!dir.exists(output_dir) &&
    !dir.create(output_dir, recursive = TRUE, showWarnings = FALSE)) {
  stop("Could not create output directory: ", output_dir)
}
output_dir <- normalizePath(output_dir, winslash = "/", mustWork = TRUE)

if (!requireNamespace("readxl", quietly = TRUE)) {
  stop("Package 'readxl' is required. No automatic installation is attempted.")
}

required_cols <- c("study_id", "workbook_row", "expected_source", "expected_snp",
                   "expected_allele_transition", "study_label", "multiplier",
                   "se_source", "basis")
dirs <- utils::read.delim(directions_path, sep = "\t", header = TRUE,
                          quote = "", comment.char = "", check.names = FALSE,
                          stringsAsFactors = FALSE, fileEncoding = "UTF-8")
if (!identical(names(dirs), required_cols)) {
  stop("Direction file columns must be: ", paste(required_cols, collapse = ", "))
}
if (nrow(dirs) != 3L) stop("Direction file must contain exactly three studies.")
for (nm in required_cols) dirs[[nm]] <- trimws(as.character(dirs[[nm]]))
if (any(!nzchar(dirs$study_id)) || anyDuplicated(dirs$study_id)) {
  stop("study_id values must be nonempty and unique.")
}
if (any(!nzchar(dirs$study_label)) || anyDuplicated(dirs$study_label)) {
  stop("study_label values must be nonempty and unique.")
}
if (any(is.na(dirs$workbook_row) |
        abs(as.numeric(dirs$workbook_row) - round(as.numeric(dirs$workbook_row))) > 0)) {
  stop("workbook_row must contain integers.")
}
dirs$workbook_row <- as.integer(dirs$workbook_row)
multiplier <- suppressWarnings(as.numeric(dirs$multiplier))
if (any(!is.finite(multiplier) | !(multiplier %in% c(-1, 1)))) {
  stop("multiplier must be 1 or -1 for every study.")
}
dirs$multiplier <- multiplier
if (any(!dirs$se_source %in% c("ci_width", "provided"))) {
  stop("se_source must be 'ci_width' or 'provided'.")
}
if (any(!nzchar(dirs$basis))) stop("Every direction row needs a factual basis.")

expected_cols <- c("source", "SNV*", "population", "disease", "OR", "95%CI",
                   "lower95%CI", "upper95%CI", "SE", "logP", "case", "control",
                   "Allele", "annot")
wb <- as.data.frame(readxl::read_excel(input_path, sheet = "CN",
                                       range = "A1:N4", col_names = TRUE,
                                       .name_repair = "minimal"))
if (!identical(names(wb), expected_cols)) {
  stop("Workbook header or range A1:N4 does not match the expected 14 columns.")
}
if (nrow(wb) != 3L) stop("Workbook range A1:N4 must contain three study rows.")

for (nm in c("source", "SNV*", "population", "disease", "95%CI", "Allele", "annot")) {
  wb[[nm]] <- trimws(as.character(wb[[nm]]))
}
dirs <- dirs[order(dirs$workbook_row), , drop = FALSE]
multiplier <- dirs$multiplier
if (!identical(dirs$workbook_row, 2:4)) {
  stop("Direction rows must map one-to-one to workbook rows 2, 3 and 4.")
}
for (i in seq_len(nrow(dirs))) {
  wb_row <- dirs$workbook_row[i]
  dat <- wb[wb_row - 1L, , drop = FALSE]
  checks <- list(
    source = c(dat$source, dirs$expected_source[i]),
    SNP = c(dat[["SNV*"]], dirs$expected_snp[i]),
    Allele = c(dat$Allele, dirs$expected_allele_transition[i])
  )
  for (nm in names(checks)) {
    if (!identical(checks[[nm]][1], checks[[nm]][2])) {
      stop(sprintf("Workbook row %d %s mismatch: workbook '%s' vs directions '%s'.",
                   wb_row, nm, checks[[nm]][1], checks[[nm]][2]))
    }
  }
}

or_reported <- suppressWarnings(as.numeric(wb$OR))
lo_reported <- suppressWarnings(as.numeric(wb[["lower95%CI"]]))
hi_reported <- suppressWarnings(as.numeric(wb[["upper95%CI"]]))
se_given <- suppressWarnings(as.numeric(wb$SE))
if (any(!is.finite(or_reported)) || any(!is.finite(lo_reported)) ||
    any(!is.finite(hi_reported))) {
  stop("OR and both workbook CI limits must be numeric and finite.")
}
if (any(or_reported <= 0) || any(lo_reported <= 0) || any(hi_reported <= 0) ||
    any(lo_reported >= hi_reported)) {
  stop("OR and CI limits must be positive with lower < upper.")
}
if (any(or_reported < lo_reported | or_reported > hi_reported)) {
  stop("Each reported OR must lie within its reported CI.")
}
se_ci <- (log(hi_reported) - log(lo_reported)) / (2 * Z95)
se_te <- ifelse(dirs$se_source == "ci_width", se_ci, se_given)
if (any(!is.finite(se_te)) || any(se_te <= 0)) {
  stop("All study SEs must be finite and positive (provided SE is required where specified).")
}

te <- multiplier * log(or_reported)
w <- 1 / se_te^2
weight_pct <- 100 * w / sum(w)
aligned_reported_lower <- ifelse(multiplier > 0, lo_reported, 1 / hi_reported)
aligned_reported_upper <- ifelse(multiplier > 0, hi_reported, 1 / lo_reported)
ci_lower <- exp(te - Z95 * se_te)
ci_upper <- exp(te + Z95 * se_te)

studies <- data.frame(
  study_id = dirs$study_id,
  study = dirs$study_label,
  population = wb$population,
  disease = wb$disease,
  snp = wb[["SNV*"]],
  allele_transition = wb$Allele,
  workbook_row = dirs$workbook_row,
  reported_OR = or_reported,
  reported_CI = wb[["95%CI"]],
  reported_CI_lower = lo_reported,
  reported_CI_upper = hi_reported,
  aligned_reported_CI_lower = aligned_reported_lower,
  aligned_reported_CI_upper = aligned_reported_upper,
  multiplier = multiplier,
  se_source = dirs$se_source,
  TE = te,
  seTE = se_te,
  OR = exp(te),
  CI_lower = ci_lower,
  CI_upper = ci_upper,
  weight_pct = weight_pct,
  check.names = FALSE
)

te_fixed <- sum(w * te) / sum(w)
se_fixed <- sqrt(1 / sum(w))
z_fixed <- te_fixed / se_fixed
p_fixed <- 2 * stats::pnorm(-abs(z_fixed))
ci_fixed <- exp(te_fixed + c(-1, 1) * Z95 * se_fixed)
q_stat <- sum(w * (te - te_fixed)^2)
q_df <- length(te) - 1L
pq <- stats::pchisq(q_stat, df = q_df, lower.tail = FALSE)
i2 <- if (q_stat > 0) max(0, 100 * (q_stat - q_df) / q_stat) else 0
tau_fit <- reml_tau2(te, se_te^2)

fmt <- function(x) sprintf("%.15g", x)
summary_df <- data.frame(
  metric = c("model", "k", "TE", "seTE", "OR", "CI_lower", "CI_upper", "z", "p",
             "Q", "Q_df", "pQ", "I2_pct", "tau2_REML", "tau2_method",
             "tau2_at_boundary", "ci_level", "z_for_ci", "direction",
             "direction_note", "scope_note"),
  value = c("common_effect_inverse_variance", "3", fmt(te_fixed), fmt(se_fixed),
            fmt(exp(te_fixed)), fmt(ci_fixed[1]), fmt(ci_fixed[2]), fmt(z_fixed),
            fmt(p_fixed), fmt(q_stat), as.character(q_df), fmt(pq), fmt(i2),
            fmt(tau_fit$tau2), "REML_univariate_profile_nonnegative",
            ifelse(tau_fit$boundary, "TRUE", "FALSE"), "0.95", "1.96",
            "Rosendahl workbook/ED8F figure direction; explicit multipliers 1,-1,-1",
            "Workbook allele-transition arrows are annotations, not certified effect alleles.",
            "Mixed ACP/ICP/AAP outcomes and rs13228878 proxy require scientific review beyond reproducing the existing figure."),
  stringsAsFactors = FALSE
)

summary_row <- data.frame(
  OR = exp(te_fixed), CI_lower = ci_fixed[1], CI_upper = ci_fixed[2],
  Q = q_stat, df = q_df, pQ = pq, I2 = i2, tau2 = tau_fit$tau2
)

write_tsv(studies, file.path(output_dir, "studies.tsv"))
write_tsv(summary_df, file.path(output_dir, "meta_summary.tsv"))

pdf_file <- file.path(output_dir, "forest_plot.pdf")
png_file <- file.path(output_dir, "forest_plot.png")
grDevices::pdf(pdf_file, width = 13.2, height = 5.0, family = "sans",
               useDingbats = FALSE, bg = "white")
tryCatch(draw_forest(studies, summary_row), finally = grDevices::dev.off())

png_type <- if (.Platform$OS.type == "windows") {
  if (isTRUE(capabilities("cairo"))) "cairo-png" else "windows"
} else "cairo"
grDevices::png(png_file, width = 13.2, height = 5.0, units = "in", res = 300,
               type = png_type, family = "sans", bg = "white")
tryCatch(draw_forest(studies, summary_row), finally = grDevices::dev.off())

session_lines <- c(
  "R session information",
  "",
  paste0("Executed: ", format(Sys.time(), "%Y-%m-%d %H:%M:%S %Z")),
  paste0("Command: ", paste(commandArgs(trailingOnly = FALSE), collapse = " ")),
  paste0("Working directory: ", getwd()),
  paste0("Input: ", input_path),
  paste0("Directions: ", directions_path),
  paste0("Output: ", output_dir),
  paste0("R: ", R.version.string),
  paste0("readxl: ", as.character(utils::packageVersion("readxl"))),
  "",
  capture.output(utils::sessionInfo())
)
con <- file(file.path(output_dir, "session_info.txt"), open = "wb")
tryCatch(writeLines(enc2utf8(session_lines), con = con, useBytes = TRUE),
         finally = close(con))

cat("Wrote results to:", output_dir, "\n")
cat(sprintf("Common effect: OR %.6f [%.6f; %.6f], p = %.6g, I2 = %.4g%%, tau2 = %.8g\n",
            exp(te_fixed), ci_fixed[1], ci_fixed[2], p_fixed, i2, tau_fit$tau2))
