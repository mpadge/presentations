# This uses and presumes the "pre-processed.Rds" data from the `coding-alone` repo.
library(codingAlone)
f <- fs::dir_ls (regexp = "pre-process", fixed = TRUE)
dat <- readRDS (f)

a <- dat$author_issue_densities_ctb100 |>
    dplyr::filter (popularity_stratum == "all") |>
    dplyr::mutate (src = unname (SOURCE_DISPLAY_NAME [src])) |>
    dplyr::filter (month >= as.Date ("2021-01-01"))

# Label position for each line: the month closest to 70% of the x-range
x_range <- range (a$month)
x_lab <- x_range [1] + 0.7 * as.numeric (diff (x_range))
labels <- a |>
    dplyr::filter (rate > 0) |>
    dplyr::group_by (src) |>
    dplyr::slice_min (abs (as.numeric (month - x_lab)), n = 1, with_ties = FALSE) |>
    dplyr::ungroup () |>
    dplyr::mutate (vjust = dplyr::if_else (rate == min (rate), 1.8, -0.8))

p <- ggplot2::ggplot (a, ggplot2::aes (x = month, y = rate, colour = src)) +
    ggplot2::geom_line (alpha = 0.9, lty = 2) +
    ggplot2::geom_smooth (se = FALSE, method = "loess", formula = y ~ x) +
    ggplot2::geom_text (
        data = labels,
        ggplot2::aes (label = src, vjust = vjust),
        size = 8,
        show.legend = FALSE
    ) +
    ggplot2::scale_y_log10 () +
    ggplot2::xlab ("Year") +
    ggplot2::ylab ("Number of unique contributors per month") +
    ggplot2::theme_minimal () +
    ggplot2::theme (
        legend.position = "none",
        axis.text = ggplot2::element_text (size = 20),
        axis.title = ggplot2::element_text (size = 20),
        plot.background = ggplot2::element_rect (fill = "transparent", colour = NA),
        panel.background = ggplot2::element_rect (fill = "transparent", colour = NA)
    )

ggplot2::ggsave ("fig2-issue-authors.png", p, width = 10, height = 7, dpi = 300, bg = "transparent")
