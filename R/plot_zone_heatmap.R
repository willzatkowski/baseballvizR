#' Plotting zone heatmap of batting average over specified time
#'
#' @param firstName A string
#' @param lastName A string
#' @param startDate A string formatted YYYY-MM-DD
#' @param endDate A string formatted YYYY-MM-DD
#' @param playerIndex A positive integer
#'
#' @returns A table with all players that match the input name, and a heatmap plot of the specified time period data
#' @importFrom rlang .data
#' @importFrom ggplot2 ggplot aes geom_rect stat_summary_2d scale_fill_gradient coord_fixed labs theme_minimal
#' @importFrom baseballr playerid_lookup statcast_search
#' @importFrom dplyr mutate if_else
#' @export
#'
#' @examples
#' plot_zone_heatmap("Juan","Soto", "2024-05-19", "2025-06-05", playerIndex = 6)
plot_zone_heatmap <- function(firstName, lastName, startDate, endDate, playerIndex = 1)
{
  checkmate::assert_number(playerIndex, lower = 0)
  checkmate::assert_string(firstName)
  checkmate::assert_string(lastName)
  checkmate::assert_string(startDate)
  checkmate::assert_string(endDate)

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
        .data$events %in% c("single", "double", "triple", "home_run"),
        1,
        0)
    )

  plot <- ggplot2::ggplot(data, ggplot2::aes(x = .data$plate_x, y = .data$plate_z, z = .data$hit)) +
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

  return(plot)

}
