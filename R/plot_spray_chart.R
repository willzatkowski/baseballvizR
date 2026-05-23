plot_spray_chart <- function(firstName, lastName, startDate, endDate)
{
  playerID_df <- baseballr::playerid_lookup(last_name = lastName, first_name = firstName)

  playerID <- playerID_df$mlbam_id[1]

  data <- baseballr::statcast_search(start_date = startDate, end_date = endDate,
                                     playerid = playerID)

  ggplot2::ggplot(data, ggplot2::aes(x = hc_x, y = hc_y)) +

    ggplot2::geom_point(
      ggplot2::aes(color = events),
      alpha = 0.6,
      size = 2
    ) +

    ggplot2::scale_y_reverse() +

    ggplot2::coord_fixed() +

    ggplot2::labs(
      title = "Spray Chart",
      color = "Result"
    ) +

    ggplot2::theme(
      axis.text.x = ggplot2::element_blank(),
      axis.text.y = ggplot2::element_blank(),
      axis.ticks = ggplot2::element_blank(),
      axis.title = ggplot2::element_blank()

    )
}
