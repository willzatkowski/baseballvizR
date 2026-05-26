#' Calculate stats of hitter over specified time
#'
#' @param firstName A string
#' @param lastName A string
#' @param startDate A string formatted YYYY-MM-DD
#' @param endDate A string formatted YYYY-MM-DD
#' @param playerIndex A positive integer
#'
#' @returns The counting stats of a hitter over a specified period of time
#' @importFrom rlang .data
#' @importFrom baseballr playerid_lookup statcast_search
#' @importFrom dplyr mutate if_else summarise
#' @export
#'
#' @examples
#' calculate_hitter_profile("Juan","Soto", "2024-05-19", "2025-06-05", playerIndex = 6)
calculate_hitter_profile <- function(firstName, lastName, startDate, endDate, playerIndex)
{
  checkmate::assert_number(playerIndex, lower = 0)
  checkmate::assert_string(firstName)
  checkmate::assert_string(lastName)
  checkmate::assert_date(startDate)
  checkmate::assert_date(endDate)

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
      data$events %in% c(
        "single",
        "double",
        "triple",
        "home_run"), 1, 0),
      walk = dplyr::if_else(.data$events == "walk", 1, 0),
      HR = dplyr::if_else(.data$events == "home_run", 1, 0),
      intentionalWalk = dplyr::if_else(.data$events == "intent_walk", 1, 0),
      fieldOut = dplyr::if_else(.data$events == "field_out", 1, 0),
      strikeOut = dplyr::if_else(.data$events == "strikeout", 1, 0),
      doublePlay = dplyr::if_else(.data$events == "grounded_into_double_play", 1, 0),
      forceOut = dplyr::if_else(.data$events == "force_out", 1, 0),
      sacFly = dplyr::if_else(.data$events == "sac_fly", 1, 0),
      fielderError = dplyr::if_else(.data$events == "field_error", 1, 0),
      hitByPitch = dplyr::if_else(.data$events == "hit_by_pitch", 1, 0)
      )

  profile <- data |>
    dplyr::summarise(
      Hits = sum(.data$hit, na.rm = TRUE),
      HRs = sum(.data$HR, na.rm = TRUE),
      Walks = sum(.data$walk, na.rm = TRUE),
      IntentionalWalk = sum(.data$intentionalWalk, na.rm = TRUE),
      HitByPitch = sum(.data$hitByPitch, na.rm = TRUE),
      StrikeOut = sum(.data$strikeOut, na.rm = TRUE),
      FieldOut = sum(.data$fieldOut, na.rm = TRUE),
      DoublePlay = sum(.data$doublePlay, na.rm = TRUE),
      ForceOut = sum(.data$forceOut, na.rm = TRUE),
      SacFly = sum(.data$sacFly, na.rm = TRUE),
      FielderError = sum(.data$fielderError, na.rm = TRUE)
    )



  return(profile)
}
