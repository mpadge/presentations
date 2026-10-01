library(codingAlone)
f <- fs::dir_ls (regexp = "pre-process", fixed = TRUE)
dat <- readRDS (f)
repo_tbl <- dat$repo_tbl
issue_authors_tbl <- dat$issue_authors_tbl
primary_sources <- unique (repo_tbl$source)

solo_by_source <- purrr::map_dfr (primary_sources, \ (src) {
    solo_repo_share_tbl (
        issue_authors_tbl, repo_tbl, src, date_start = as.Date ("2021-01-01")
    ) |>
        dplyr::mutate (source = src)
}) |>
    dplyr::mutate (source = unname (SOURCE_DISPLAY_NAME [source]))

# Label position for each line: the month closest to 70% of the x-range
x_range <- range (solo_by_source$month)
x_lab <- x_range [1] + 0.7 * as.numeric (diff (x_range))
labels <- solo_by_source |>
    dplyr::filter (!is.na (solo_share)) |>
    dplyr::group_by (source) |>
    dplyr::slice_min (abs (as.numeric (month - x_lab)), n = 1, with_ties = FALSE) |>
    dplyr::ungroup () |>
    dplyr::mutate (
        vjust = dplyr::if_else (solo_share == min (solo_share), 1.8, -0.8)
    )

p <- solo_by_source |>
    ggplot2::ggplot (ggplot2::aes (month, solo_share, colour = source)) +
    ggplot2::geom_line (linewidth = 0.7, alpha = 0.9) +
    ggplot2::geom_text (
        data = labels,
        ggplot2::aes (label = source, vjust = vjust),
        size = 8,
        show.legend = FALSE
    ) +
    ggplot2::scale_y_continuous (labels = scales::percent) +
    ggplot2::scale_colour_brewer (palette = "Set1") +
    ggplot2::labs (
        x = "Year",
        y = "Proportion Solo Authors (%)",
        colour = NULL
    ) +
    ggplot2::theme_minimal () +
    ggplot2::theme (
        legend.position = "none",
        axis.text = ggplot2::element_text (size = 20),
        axis.title = ggplot2::element_text (size = 20),
        plot.background = ggplot2::element_rect (fill = "transparent", colour = NA),
        panel.background = ggplot2::element_rect (fill = "transparent", colour = NA)
    )
ggplot2::ggsave ("fig3-solo-share-plot.png", p, width = 10, height = 7, dpi = 300, bg = "transparent")
