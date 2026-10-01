# This uses and presumes the "pre-processed.Rds" data from the `coding-alone` repo.
library(codingAlone)
f <- fs::dir_ls (regexp = "pre-process", fixed = TRUE)
dat <- readRDS (f)

tbl <- dat$popularity_authors_tbl |>
    dplyr::mutate (source = unname (SOURCE_DISPLAY_NAME [source]))
tbl$source <- factor (tbl$source, levels = unique (tbl$source))

p <- ggplot2::ggplot (tbl, ggplot2::aes (n_authors, popularity_adj)) +
    ggplot2::geom_hex (ggplot2::aes (
        fill = ggplot2::after_stat (log (count) / log (max (count)))
    )) +
    ggplot2::scale_fill_viridis_c (guide = "none") +
    ggplot2::geom_smooth (
        method = "lm", formula = y ~ x, colour = "#c0392b", se = TRUE
    ) +
    ggplot2::scale_x_log10 () +
    ggplot2::scale_y_log10 (labels = scales::label_log ()) +
    ggplot2::facet_wrap (~source, scales = "free") +
    ggplot2::labs (
        x = "Total unique issue authors",
        y = "Popularity (adjusted to median repo lifespan)"
    ) +
    ggplot2::theme_minimal () +
    ggplot2::theme (
        # legend.position = "none",
        # axis.text = ggplot2::element_text (size = 20),
        axis.title = ggplot2::element_text (size = 20),
        strip.text = ggplot2::element_text (size = 20),
        plot.background = ggplot2::element_rect (fill = "transparent", colour = NA),
        panel.background = ggplot2::element_rect (fill = "transparent", colour = NA)
    )

ggplot2::ggsave ("fig1-popularity-authors.png", p, width = 10, height = 7, dpi = 300, bg = "transparent")
