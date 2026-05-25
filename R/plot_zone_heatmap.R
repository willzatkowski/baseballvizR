#' Plotting zone heatmap of batting average over specified time
#'
#' @param firstName A string
#' @param lastName A string
#' @param startDate A string formatted YYYY-MM-DD
#' @param endDate A string formatted YYYY-MM-DD
#' @param playerIndex A positive integer
#'
#' @returns A table with all players that match the input name, and a heatmap plot of the specified time period data
#' @export
#'
#' @examples
#' plot_zone_heatmap("Juan","Soto", "2024-05-19", "2025-06-05", playerIndex = 6)
plot_zone_heatmap <- function(firstName, lastName, startDate, endDate, playerIndex = 1)
{
  playerID_df <- baseballr::playerid_lookup(last_name = lastName, first_name = firstName)
  print(playerID_df)

  if (nrow(playerID_df) == 0) {
    stop("No players found.")
  }

  if (playerIndex > nrow(playerID_df)) {
    stop("playerIndex exceeds number of matching players.")
  }

  playerID <- playerID_df$mlbam_id[playerIndex]

  data <- baseballr::statcast_search(start_date = startDate, end_date = endDate,
                             playerid = playerID)

  data <- data |>
    dplyr::mutate(
      hit = dplyr::if_else(
        events %in% c("single", "double", "triple", "home_run"),
        1,
        0)
    )

  ggplot2::ggplot(data, ggplot2::aes(x = plate_x, y = plate_z, z = hit)) +
    ggplot2::stat_summary_2d(
      fun = mean,
      bins = 30) +
    ggplot2::scale_fill_gradient(
      low = "blue",
      high = "red"
    ) +
    ggplot2::coord_fixed() +
    ggplot2::geom_rect(xmin = -0.83,
                       xmax = 0.83,
                       ymin = 1.5,
                       ymax = 3.5,
                       fill = NA,
                       color = "black",
                       linewidth = 1) +
    ggplot2::labs(
      title = "Pitch Location Heatmap",
      x = "Horizontal Location",
      y = "Vertical Location",
      fill = "Batting Average"
    ) +
    ggplot2::theme_minimal()

}
