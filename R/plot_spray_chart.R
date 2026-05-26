#' Plotting spray chart over specified time
#'
#' @param firstName A string
#' @param lastName A string
#' @param startDate A string formatted YYYY-MM-DD
#' @param endDate A string formatted YYYY-MM-DD
#' @param playerIndex A positive integer
#'
#' @returns A table with all players that match the input name, and a spray chart plot of the specified time period data
#' @importFrom rlang .data
#' @importFrom ggplot2 ggplot aes geom_point scale_y_reverse coord_fixed labs element_blank
#' @importFrom baseballr playerid_lookup statcast_search
#' @export
#'
#' @examples
#' plot_spray_chart("Juan","Soto", "2024-05-19", "2025-06-05", playerIndex = 6)
plot_spray_chart <- function(firstName, lastName, startDate, endDate, playerIndex = 1)
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

  ggplot2::ggplot(data, ggplot2::aes(x = .data$hc_x, y = .data$hc_y)) +

    ggplot2::geom_point(
      ggplot2::aes(color = .data$events),
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
